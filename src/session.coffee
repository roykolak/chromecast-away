EventEmitter = require('./event_emitter')
MediaControls = require('./media_controls')

class Session extends EventEmitter
  constructor: (@session, @castAway) ->
    throw "CastAway instance not found" unless @castAway.cast
    @cast = @castAway.cast
    @namespace = @castAway.namespace || "urn:x-cast:json"

  send: (name, payload={}, cb=->) ->
    onSuccess = (data) -> cb(null, data)
    onError = (err) -> cb err
    data = JSON.stringify(_name: name, _payload: payload)
    @session.sendMessage @namespace, data, onSuccess, onError

  load: (mediaInfo, cb=->) ->
    request = new chrome.cast.media.LoadRequest(mediaInfo)

    onSuccess = (media) =>
      media.addUpdateListener => @sessionUpdateListener()
      controls = new MediaControls(media, @castAway)
      cb(null, controls)

    onError = (err) ->
      cb(err)

    @session.loadMedia request, onSuccess, onError

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

  music: (config = {}, cb=->) ->
    throw "Url required for music" unless config.url
    throw "Content-type required for music" unless config.contentType

    mediaInfo = new chrome.cast.media.MediaInfo(config.url, config.contentType)
    metadata = new chrome.cast.media.MusicTrackMediaMetadata()
    metadata.metadataType = chrome.cast.media.MetadataType.MUSIC_TRACK
    mediaInfo.metadata = assignMetadata(metadata, config)

    @load mediaInfo, cb

  tvShow: (config = {}, cb=->) ->
    throw "Url required for tv show" unless config.url
    throw "Content-type required for tv show" unless config.contentType

    mediaInfo = new chrome.cast.media.MediaInfo(config.url, config.contentType)
    metadata = new chrome.cast.media.TvShowMediaMetadata()
    metadata.metadataType = chrome.cast.media.MetadataType.TV_SHOW
    mediaInfo.metadata = assignMetadata(metadata, config)

    @load mediaInfo, cb

  movie: (config = {}, cb=->) ->
    throw "Url required for movie" unless config.url
    throw "Content-type required for movie" unless config.contentType

    mediaInfo = new chrome.cast.media.MediaInfo(config.url, config.contentType)
    metadata = new chrome.cast.media.MovieMediaMetadata()
    metadata.metadataType = chrome.cast.media.MetadataType.MOVIE
    mediaInfo.metadata = assignMetadata(metadata, config)

    @load mediaInfo, cb

  photo: (config = {}, cb=->) ->
    throw "Url required for photo" unless config.url
    throw "Content-type required for photo" unless config.contentType

    mediaInfo = new chrome.cast.media.MediaInfo(config.url, config.contentType)
    metadata = new chrome.cast.media.PhotoMediaMetadata()
    metadata.metadataType = chrome.cast.media.MetadataType.PHOTO
    mediaInfo.metadata = assignMetadata(metadata, config)

    @load mediaInfo, cb

  release: (cb=->) ->
    return unless @session
    @session.stop(
      ((data) -> cb(null, data)),
      ((err) -> cb(err))
    )

assignMetadata = (metadata, config) ->
  # for key, value of config
  #   value = (new chrome.cast.media.Image(image) for image in value) if key == 'images'
  #   metadata[key] = value
  metadata

module.exports = Session
