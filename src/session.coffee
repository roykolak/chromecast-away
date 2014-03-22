EventEmitter = require('./event_emitter')
MediaControls = require('./media_controls')

class Session extends EventEmitter
  constructor: (@session) ->
    throw "chrome.cast namespace not found" unless chrome.cast
    @cast = chrome.cast

  sendMessage: (args...) ->
    @session.sendMessage args...

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
    mediaInfo.metadata = assignMetadata(metadata, config)

    @load mediaInfo, (media) =>
      callbacks.success?(new MediaControls(media))
    , (args...) ->
      callbacks.error?(args...)

  tvShow: (config = {}, callbacks) ->
    throw "Url required for tv show" unless config.url
    throw "Content-type required for tv show" unless config.contentType

    mediaInfo = new @cast.media.MediaInfo(config.url, config.contentType)
    metadata = new chrome.cast.media.TvShowMediaMetadata()
    metadata.metadataType = chrome.cast.media.MetadataType.TV_SHOW
    mediaInfo.metadata = assignMetadata(metadata, config)

    @load mediaInfo, (media) =>
      callbacks.success?(new MediaControls(media))
    , (args...) ->
      callbacks.error?(args...)

  movie: (config = {}, callbacks) ->
    throw "Url required for movie" unless config.url
    throw "Content-type required for movie" unless config.contentType

    mediaInfo = new @cast.media.MediaInfo(config.url, config.contentType)
    metadata = new chrome.cast.media.MovieMediaMetadata()
    metadata.metadataType = chrome.cast.media.MetadataType.MOVIE
    mediaInfo.metadata = assignMetadata(metadata, config)

    @load mediaInfo, (media) =>
      callbacks.success?(new MediaControls(media))
    , (args...) ->
      callbacks.error?(args...)

  photo: (config = {}, callbacks) ->
    throw "Url required for photo" unless config.url
    throw "Content-type required for photo" unless config.contentType

    mediaInfo = new @cast.media.MediaInfo(config.url, config.contentType)
    metadata = new chrome.cast.media.PhotoMediaMetadata()
    metadata.metadataType = chrome.cast.media.MetadataType.PHOTO
    mediaInfo.metadata = assignMetadata(metadata, config)

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

assignMetadata = (metadata, config) ->
  for key, value of config
    value = (new chrome.cast.Image(image) for image in value) if key == 'images'
    metadata[key] = value
  metadata

module.exports = Session
