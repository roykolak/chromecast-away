EventEmitter = require('./event_emitter')
MediaControls = require('./media_controls')

class Session extends EventEmitter
  constructor: (@session) ->
    throw "chrome.cast namespace not found" unless chrome.cast
    @cast = chrome.cast

  load: (mediaInfo, success, error) ->
    request = new @cast.media.LoadRequest(mediaInfo)

    @session.loadMedia request, (media) =>
      media.addUpdateListener => @sessionUpdateListener()
      success(media)
    , (args...) ->
      error(args...)

  sessionUpdateListener: ->
    media = @session.media[0]
    event = switch media.playerState
      when 'PLAYING' then 'play'
      when 'PAUSED'  then 'pause'
      when 'STOPPED' then 'stop'
      when 'SEEKING' then 'seek'
      when 'ERROR'   then 'error'
      when 'IDLE'    then 'idle'
      when 'LOADING' then 'load'
    @emit event

  music: (config = {}, callbacks) ->
    throw "Url required for music" unless config.url
    throw "Content-type required for music" unless config.contentType

    mediaInfo = new @cast.media.MediaInfo(config.url, config.contentType)

    metadata = new chrome.cast.media.MusicTrackMediaMetadata()
    metadata.metadataType = chrome.cast.media.MetadataType.MUSIC_TRACK

    for key, value of config
      if key == 'images'
        value = (new @cast.Image(image) for image in value)
      metadata[key] = value

    mediaInfo.metadata = metadata

    @load mediaInfo, (media) =>
      callbacks.success?(new MediaControls(media))
    , (args...) ->
      callbacks.error?(args...)

  release: (success, error) ->
    return unless @session
    @session.stop(
      ((args...) -> success?(args...)),
      ((args...) -> error?(args...))
    )

module.exports = Session
