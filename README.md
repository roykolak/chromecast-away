Chromecast Wrapper
=====================

A nice, friendly wrapper for Chromecast that doesn't judge you and always sends thank you cards upon receiving something nice from a friend because it appreciates emotional responses.

_Still in heavy development._

Supports:

* Playing media and audio
* Displaying webpages (Coming Soon)

Playing Media/Audio
------------------------

```coffee
  castConnection = new CastConnection()
  castConnection.connect ->
    castConnection.requestSession (castMedia) ->
      url = 'https://s3.amazonaws.com/roysfunfun/ghostbuster_ringtone.mp3'
      castMedia.load url: url, contentType: 'audio/mpeg', ->
        castMedia.pause()
        castMedia.play()
        castMedia.stop()
        castMedia.quit() # kills session, releases chromecast
```

Displaying Webpages
------------------------

```coffee
  castConnection = new CastConnection()
  castConnection.connect ->
    castConnection.requestSession (castPage) ->

    # Coming soon!
```
