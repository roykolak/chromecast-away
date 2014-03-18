castAway = new CastAway()

castAway.on 'receivers:available', ->
  console.log 'receivers available, safe to request a session'

  $('.cast').click (ev) ->
    castAway.requestSession
      success: (session) ->
        config =
          url: 'https://s3.amazonaws.com/roysfunfun/ghostbuster_ringtone.mp3'
          contentType: 'audio/mpeg'
          albumName: 'Album name'
          albumArtist: 'Album artist'
          artist: 'Music artist'
          composer: 'Composer'
          images: ["http://www.biography.com/imported/images/Biography/Images/Profiles/S/Will-Smith-9542165-1-402.jpg"]

        session.music config,
          success: (controls) ->

            # Interact with the media via controls
            $('.pause').click (ev) -> controls.pause()
            $('.play').click (ev) -> controls.play()
            $('.stop').click (ev) -> controls.stop()
            $('.release').click (ev) -> session.release()

            # will emit the following events...
            session.on 'pause', -> # media paused
            session.on 'play', -> # media playing
            session.on 'stop', -> # media stopped
            session.on 'seek', -> # media seeking
            session.on 'error', -> # media errored
            session.on 'idle', -> # media idle
            session.on 'load', -> # media loading

          error: (data) ->
            # Error loading media

      error: ->

castAway.on 'receivers:unavailable', ->
  console.log 'no receivers found'

castAway.on 'existingMediaFound', (session, controls) ->
  console.log 'found existing media session'

  # Interact with the media via controls
  $('.pause').click (ev) -> controls.pause()
  $('.play').click (ev) -> controls.play()
  $('.stop').click (ev) -> controls.stop()
  $('.release').click (ev) -> session.release()

castAway.initialize
  success: (data) ->
    console.log 'successfully initialized'
  error: (data) ->
    console.log 'unsuccessfully initialized'
