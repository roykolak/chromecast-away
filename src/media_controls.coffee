class MediaControls
  constructor: (@session, @castAway) ->
    throw "No session passed" unless @session
    throw "CastAway instance not found" unless @castAway.cast

    @cast = @castAway.cast

  play: (cb=->) ->
    @session.play null,
      (data) -> cb(null, data),
      (err) -> cb(err)

  pause: (cb=->) ->
    @session.pause null,
      (data) -> cb(null, data)
      (err) -> cb(err)

  stop: (cb=->) ->
    @session.stop null,
      (data) -> cb(null, data)
      (err) -> cb(err)

  seek: (time, cb=->) ->
    seekRequest = @cast.session.SeekRequest(time)
    @session.seek seekRequest,
      (data) -> cb(null, data)
      (err) -> cb(err)

module.exports = MediaControls
