castAway = new CastAway
  namespace: "sample.test.default_media.receiver"

castAway.on 'receivers:available', ->
  # Receivers found

castAway.on 'receivers:unavailable', ->
  # No receivers found

castAway.on 'initialize:error', ->
  # Error initializing

castAway.on 'session:release', ->
  # Receiver session ended


castAway.initialize()

castEl = document.getElementsByClassName('cast')[0]
castEl.addEventListener 'click', (ev) ->
  # verify that receivers were found
  castAway.createSession (receiver) ->
    media =
      url: 'https://s3.amazonaws.com/roysfunfun/ghostbuster_ringtone.mp3'
      contentType: 'audio/mpeg'

    console.log receiver
    receiver.load media,
      success: (controls) ->
        attachMediaControls(receiver, controls)

      error: (data) ->
        # Error loading media


attachMediaControls = (receiver, controls) ->
  pauseEl = document.getElementsByClassName('pause')[0]
  pauseEl.addEventListener 'click', (ev) ->
    controls.pause()

  playEl = document.getElementsByClassName('play')[0]
  playEl.addEventListener 'click', (ev) ->
    controls.play()

  releaseEl = document.getElementsByClassName('release')[0]
  releaseEl.addEventListener 'click', (ev) ->
    castAway.getReceiver
      success: (receiver) ->
        receiver.release()
