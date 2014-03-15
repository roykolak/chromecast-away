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

        success = ->
        error = (args...) -> @callbacks.error?(args...)

        @cast.initialize(apiConfig, success, error)

  sessionListener: (session) ->
    session.addUpdateListener(@sessionUpdateListener)
    session.addMessageListener(@namespace, @receiverMessage)

  receiverListener: (receiver) ->
    if receiver == @cast.ReceiverAvailability.AVAILABLE
      @callbacks.receiversAvailable?()
    else
      @callbacks.receiversUnavailable?()

  sessionUpdateListener: (isAlive) ->
    console.log isAlive

  receiverMessage: (namespace, message) ->

  requestSession: (callbacks) ->
    @cast.requestSession (session) ->
      receiver = if @applicationID
        new CustomReceiver(session)
      else
        new MediaReceiver(session)
      callbacks.success?(receiver)
    , (args...) ->
      callbacks.error?(args...)

class Receiver
  constructor: (@session) ->
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

    @session.sendMessage request, (mediaReceiver) =>
      callbacks.success?(new MediaControls(mediaReceiver))
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
