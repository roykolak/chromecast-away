castAway = new CastAway()

castAway.on 'receivers:available', ->
  console.log 'receivers available, safe to request a session'

  $('.music .cast').click (ev) ->
    castAway.requestSession (err, session) ->
      config =
        url: 'https://s3.amazonaws.com/roysfunfun/ghostbuster_ringtone.mp3'
        contentType: 'audio/mpeg'
        albumName: 'Album name'
        albumArtist: 'Album artist'
        artist: 'Music artist'
        composer: 'Composer'
        images: ["http://www.biography.com/imported/images/Biography/Images/Profiles/S/Will-Smith-9542165-1-402.jpg"]

      session.music config, (err, controls) ->
        attachControls($('.music'), session, controls)

  $('.tv_show .cast').click (ev) ->
    castAway.requestSession (err, session) ->
      config =
        url:'http://commondatastorage.googleapis.com/gtv-videos-bucket/ED_1280.mp4'
        title: 'Elephant Dream'
        seriesTitle: 'TV show name here'
        images: ['http://img1.wikia.nocookie.net/__cb20130823094044/disney/images/a/a2/Will-smith-image3.jpg']
        contentType: 'video/mp4'

      session.tvShow config, (err, controls) ->
        attachControls($('.tv_show'), session, controls)

  $('.movie .cast').click (ev) ->
    castAway.requestSession (err, session) ->
      config =
        url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/tears_of_steel_1080p.mov'
        title: 'Tears of Steel'
        images: ['http://img1.wikia.nocookie.net/__cb20130823094044/disney/images/a/a2/Will-smith-image3.jpg']
        subtitle: 'subtitle'
        studio: 'By Blender Foundation'
        releaseYear: '2006'
        contentType: 'video/mp4'

      session.movie config, (err, controls) ->
        attachControls($('.movie'), session, controls)

  $('.photo .cast').click (ev) ->
    castAway.requestSession (err, session) ->
      config =
        url: 'http://www.videws.com/eureka/castv2/images/San_Francisco_Fog.jpg'
        title: 'San Francisco Fog'
        contentType: 'image/jpg'
        artist: 'Photo artist'
        location: 'San Francisco'
        longitude: 37.7833
        latitude: 122.4167
        width: 1728
        height: 1152
        creationDateTime: '1999'

      session.photo config, (err, controls) ->
        attachControls($('.photo'), session, controls)

castAway.on 'receivers:unavailable', ->
  console.log 'no receivers found'

castAway.on 'existingMediaFound', (session, controls) ->
  console.log 'found existing media session'

  # Interact with the media via controls
  $('.pause').click (ev) -> controls.pause()
  $('.play').click (ev) -> controls.play()
  $('.stop').click (ev) -> controls.stop()
  $('.release').click (ev) -> session.release()

castAway.initialize (err, data) ->
  if err
    console.log 'unsuccessfully initialized'
  else
    console.log 'successfully initialized'

attachControls = ($el, session, controls) ->
  # Interact with the media via controls
  $('.pause', $el).click (ev) -> controls.pause()
  $('.play', $el).click (ev) -> controls.play()
  $('.stop', $el).click (ev) -> controls.stop()
  $('.release', $el).click (ev) -> session.release()

  session.on 'pause', ->
    console.log 'paused'
  session.on 'play', ->
    console.log 'playing'
  session.on 'stop', ->
    console.log 'stopped'
  session.on 'seek', ->
    console.log 'seeking'
  session.on 'error', ->
    console.log 'errored'
  session.on 'idle', ->
    console.log 'idle'
  session.on 'load', ->
    console.log 'loading'
