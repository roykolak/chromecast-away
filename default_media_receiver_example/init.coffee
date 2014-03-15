castAway = new CastAway
  namespace: "sample.test.default_media.receiver"

castAway.initialize
  receiversAvailable: ->
    castAway.requestSession
      success: (receiver) ->
        media =
          url: 'https://s3.amazonaws.com/roysfunfun/ghostbuster_ringtone.mp3'
          contentType: 'audio/mpeg'

        receiver.load media,
          success: (controls) ->
            attachMediaControls(receiver, controls)

          error: (data) ->
            # Error loading media

      error: (data) ->
        # Error requesting session

  receiversUnAvailable: ->
    # No receivers found

  error: (data) ->
    # Error connecting

attachMediaControls = (receiver, controls) ->
  document.getElementsByClassName('pause')[0].addEventListener 'click', (ev) ->
    controls.pause()
  document.getElementsByClassName('play')[0].addEventListener 'click', (ev) ->
    controls.play()
  document.getElementsByClassName('release')[0].addEventListener 'click', (ev) ->
    receiver.release()
