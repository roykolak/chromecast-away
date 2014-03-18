class MediaControls
  constructor: (@session) ->
    throw "No session passed" unless @session
    throw "chrome.cast namespace not found" unless chrome.cast

    @cast = chrome.cast

  play: (success, error) ->
    @session.play null,
      (args...) -> success?(args...),
      (args...) -> error?(args...)

  pause: (success, error) ->
    @session.pause null,
      (args...) -> success?(args...),
      (args...) -> error?(args...)

  stop: (success, error) ->
    @session.stop null,
      (args...) -> success?(args...),
      (args...) -> error?(args...)

  seek: (time, success, error) ->
    seekRequest = @cast.session.SeekRequest(time)
    @session.seek seekRequest,
      (args...) -> success?(args...),
      (args...) -> error?(args...)

module.exports = MediaControls
