class CastAway
  constructor: ({@applicationID, @namespace} = {}) ->
    throw "chrome.cast namespace not found" unless chrome.cast
    @cast = chrome.cast

  initialize: (@callbacks) ->
    window['__onGCastApiAvailable'] = (loaded, errorInfo) =>
      if loaded
        app = @applicationID || @cast.media.DEFAULT_MEDIA_RECEIVER_APP_ID

        sessionRequest = new @cast.SessionRequest(app)
        apiConfig = new @cast.ApiConfig sessionRequest,
          (data...) => @sessionListener(data...),
          (data...) => @receiverListener(data...)

        success = -> # success!
        error = (args...) => @emit 'initialize:error'

        @cast.initialize(apiConfig, success, error)

  sessionListener: (session) ->
    @session = session.media[0] if session.media.length != 0
    session.addUpdateListener(@sessionUpdateListener)

  receiverListener: (receiver) ->
    state = if receiver == @cast.ReceiverAvailability.AVAILABLE
      'available'
    else
      'unavailable'
    @emit "receivers:#{state}"

  sessionUpdateListener: (isAlive) ->
    unless isAlive
      @session = null
      @emit 'session:release'

  createSession: (callbacks) ->
    getReceiver = (session) ->
      if @applicationID
        new CustomReceiver(session)
      else
        new MediaReceiver(session)

    if @session?
      callbacks.success?(getReceiver(@session))
    else
      @cast.requestSession (session) =>
        callbacks.success?(getReceiver(session))
      , (args...) ->
        callbacks.error?(args...)

class Receiver
  constructor: (@session, @namespace) ->
    throw "chrome.cast namespace not found" unless chrome.cast
    @cast = chrome.cast

  release: (success, error) ->
    return unless @session
    @session.stop(
      (args...) -> success?(args...),
      (args...) -> error?(args...)
    )

class CustomReceiver extends Receiver
  load: (url, callbacks) ->
    # todo


class MediaReceiver extends Receiver
  load: (media, callbacks) ->
    throw "No media url set" unless media.url
    throw "No media content type set" unless media.contentType

    mediaInfo = new @cast.media.MediaInfo(media.url, media.contentType)
    request = new @cast.media.LoadRequest(mediaInfo)

    @session.loadMedia request, (receiver) =>
      callbacks.success?(new MediaControls(receiver))
    , (args...) ->
      callbacks.error?(args...)

class MediaControls
  constructor: (@receiver) ->
    throw "No receiver passed" unless @receiver

  play: (success, error) ->
    @receiver.play null,
      (args...) -> success?(args...),
      (args...) -> error?(args...)

  pause: (success, error) ->
    @receiver.pause null,
      (args...) -> success?(args...),
      (args...) -> error?(args...)

  stop: (success, error) ->
    @receiver.stop null,
      (args...) -> success?(args...),
      (args...) -> error?(args...)

  seek: (time, success, error) ->
    seekRequest = @cast.media.SeekRequest(time)
    @receiver.seek seekRequest,
      (args...) -> success?(args...),
      (args...) -> error?(args...)

window.CastAway = CastAway
