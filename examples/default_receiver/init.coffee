# A reusable media control view that gets passed an active session
# and control object to interaction with a cast session.
sessionView = new MediaSessionView()
sessionView.render()

mediaConfig =
  music:
    url: 'https://s3.amazonaws.com/roysfunfun/ghostbuster_ringtone.mp3'
    contentType: 'audio/mpeg'
    albumName: 'Album name'
    albumArtist: 'Album artist'
    artist: 'Music artist'
    composer: 'Composer'
    images: ['http://www.popstarsplus.com/images/WillSmithPicture.jpg']

  tvShow:
    url:'http://commondatastorage.googleapis.com/gtv-videos-bucket/ED_1280.mp4'
    title: 'Elephant Dream'
    seriesTitle: 'TV show name here'
    images: ['http://img1.wikia.nocookie.net/__cb20130823094044/disney/images/a/a2/Will-smith-image3.jpg']
    contentType: 'video/mp4'

  movie:
    url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/tears_of_steel_1080p.mov'
    title: 'Tears of Steel'
    images: ['http://img1.wikia.nocookie.net/__cb20130823094044/disney/images/a/a2/Will-smith-image3.jpg']
    subtitle: 'subtitle'
    studio: 'By Blender Foundation'
    releaseYear: '2006'
    contentType: 'video/mp4'

  photo:
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

castAway = new CastAway()

castAway.on 'receivers:available', ->
  console.log 'receivers available, safe to request a session'

  $('.cast').click (ev) ->
    $el = $(ev.currentTarget)
    castAway.requestSession (err, session) ->
      if err
        $el.addClass 'error'
      else
        $el.addClass 'active'
        sessionView.updateSession session

        session.on 'release', ->
          $el.removeClass('active')

        # the media-type data attribute maps to a func name on the returned session and in the mediaConfig object. This is not smart IRL, just drying up some demo code...
        mediaType =  $el.data('media-type')
        session[mediaType] mediaConfig[mediaType], (err, controls) ->
          if err
            $el.addClass 'error'
          else
            sessionView.attachEvents(session, controls)

castAway.on 'receivers:unavailable', ->
  console.log 'no receivers found'
  $('.name').text 'No receivers found'

castAway.on 'existingMediaFound', (session, controls) ->
  console.log 'found existing media session'
  sessionView.updateSession session
  sessionView.attachEvents session, controls

castAway.initialize (err, data) ->
  if err
    console.log 'unsuccessfully initialized'
  else
    console.log 'successfully initialized'
