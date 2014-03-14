castConnection = new CastConnection()
castConnection.connect (data) ->
  castConnection.requestSession (castMedia) ->
    url = 'https://s3.amazonaws.com/roysfunfun/ghostbuster_ringtone.mp3'

    castMedia.load url: url, contentType: 'audio/mpeg', ->
      document.getElementsByClassName('pause')[0].addEventListener 'click', (ev) ->
        castMedia.pause()
      document.getElementsByClassName('play')[0].addEventListener 'click', (ev) ->
        castMedia.play()
      document.getElementsByClassName('exit')[0].addEventListener 'click', (ev) ->
        castMedia.quit()
