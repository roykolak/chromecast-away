EventEmitter = require('./event_emitter')
Session = require('./session')
MediaControls = require('./media-controls')
CustomReceiver = require('./custom-receiver')

class CastAway extends EventEmitter
  constructor: ({@applicationID, @namespace} = {}) ->
    throw "chrome.cast namespace not found" unless chrome?.cast || cast
    @cast = chrome?.cast || cast

  initialize: (cb) ->

    initializeCastApi = =>
      app = @applicationID || @cast.media.DEFAULT_MEDIA_RECEIVER_APP_ID

      sessionRequest = new @cast.SessionRequest(app)
      apiConfig = new @cast.ApiConfig sessionRequest,
        (data...) => @sessionListener(data...),
        (data...) => @receiverListener(data...)

      success = (data) -> cb(null, data)

      error = (err) -> cb(err)

      @cast.initialize(apiConfig, success, error)

    # Initialize Chromecast with this one weird trick!
    # Developers hate us!
    # Because of the way the chromecast API is loaded,
    # there is a chance that the initialization callback
    # is registered to __onGCastApiAvailable may be defined
    # after the it has already fired. This polls to
    # make sure that the API is appropriately initialized.
    intervalId = setInterval (->
      if chrome.cast && chrome.cast.isAvailable && chrome.cast.media && chrome.cast.SessionRequest
        clearInterval(intervalId)
        initializeCastApi()
    ), 15

  receive: (config={}) ->
    @receiver = new CustomReceiver(config, this)
    @receiver.start()
    @receiver

  sessionListener: (session) ->
    @currentSession = session
    session.addUpdateListener(@sessionUpdateListener)
    @emit 'session:started', new Session(@currentSession, this)
    if session.media.length != 0
      @emit 'session:existingMedia',
        new Session(@currentSession, this),
        new MediaControls(@currentSession.media[0], this)

  receiverListener: (receiver) ->
    available = @cast.ReceiverAvailability.AVAILABLE
    state = if receiver == available then 'available' else 'unavailable'
    @emit "receivers:#{state}"

  sessionUpdateListener: (isAlive) ->
    unless isAlive
      @currentSession = null

  requestSession: (cb) ->
    onSuccess = (session) => cb null, new Session(session, this)
    onError = (err) -> cb(err)
    @cast.requestSession onSuccess, onError

window.CastAway = CastAway
