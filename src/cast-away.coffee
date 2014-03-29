EventEmitter = require('./event_emitter')
Session = require('./session')
MediaControls = require('./media_controls')
CustomReceiver = require('./custom-receiver')

class CastAway extends EventEmitter
  constructor: ({@applicationID, @namespace} = {}) ->
    throw "chrome.cast namespace not found" unless chrome?.cast || cast
    @cast = chrome?.cast || cast

  initialize: (cb) ->
    window['__onGCastApiAvailable'] = (loaded, errorInfo) =>
      if loaded
        app = @applicationID || @cast.media.DEFAULT_MEDIA_RECEIVER_APP_ID

        sessionRequest = new @cast.SessionRequest(app)
        apiConfig = new @cast.ApiConfig sessionRequest,
          (data...) => @sessionListener(data...),
          (data...) => @receiverListener(data...)

        success = (data) -> cb(null, data)
        error = (err) -> cb(err)

        @cast.initialize(apiConfig, success, error)

  receive: (config={}) ->
    @receiver = new CustomReceiver(config, this)
    @receiver.start()
    @receiver

  sessionListener: (session) ->
    if session.media.length != 0
      @currentSession = session
      session.addUpdateListener(@sessionUpdateListener)
      @emit 'existingMediaFound',
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
