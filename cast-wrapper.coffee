class CastConnection
  constructor: (@applicationID) ->
    throw "chrome.cast namespace not found" unless chrome.cast
    @cast = chrome.cast

  connect: (@callback) ->
    window['__onGCastApiAvailable'] = (loaded, errorInfo) =>
      if loaded
        app = @applicationID || @cast.media.DEFAULT_MEDIA_RECEIVER_APP_ID

        sessionRequest = new @cast.SessionRequest(app)
        apiConfig = new @cast.ApiConfig sessionRequest,
          (data...) => @sessionListener(data...),
          (data...) => @receiverListener(data...)

        success = ->
        error = -> throw 'Failed to initialize connection'

        @cast.initialize(apiConfig, success, error)

  sessionListener: (session) ->
    console.log session
    session.addUpdateListener(@sessionUpdateListener)
    session.addMessageListener(@namespace, @receiverMessage)

  receiverListener: (receiver) ->
    state = 'available' if receiver == @cast.ReceiverAvailability.AVAILABLE
    @callback(receivers: state || 'unavailable')

  sessionUpdateListener: (isAlive) ->
    console.log isAlive

  receiverMessage: (namespace, message) ->

  requestSession: (callback) ->
    @cast.requestSession (session) ->
      callback new CastMedia(session)
    , (error) ->
      console.log error
      throw "Failed to create a session #{error}"

class CastMedia
  constructor: (@session) ->
    throw "chrome.cast namespace not found" unless chrome.cast
    @cast = chrome.cast

  load: (media, callback) ->
    throw "No media url set" unless media.url
    throw "No media content type set" unless media.contentType

    mediaInfo = new @cast.media.MediaInfo(media.url, media.contentType)
    request = new @cast.media.LoadRequest(mediaInfo)

    @session.loadMedia request, (media) =>
      @media = media
      callback()
    , (error) ->
      throw "Failed to load media"

  play: (success, error) ->
    return unless @media
    @media.play null,
      (args...) -> success?(args...),
      (args...) -> error?(args...)

  pause: (success, error) ->
    return unless @media
    @media.pause null,
      (args...) -> success?(args...),
      (args...) -> error?(args...)

  stop: (success, error) ->
    return unless @media
    @media.stop null,
      (args...) -> success?(args...),
      (args...) -> error?(args...)

  seek: (success, error) ->
    return unless @media
    @media.seek null,
      (args...) -> success?(args...),
      (args...) -> error?(args...)

  quit: (success, error) ->
    return unless @session
    @session.stop(
      (args...) -> success?(args...),
      (args...) -> error?(args...)
    )

window.CastConnection = CastConnection
