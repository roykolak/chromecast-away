Chromecast Wrapper
=====================

A nice, friendly wrapper for Chromecast that doesn't judge you and always sends thank you cards upon receiving something nice from a friend because it appreciates emotional responses.

_Still in heavy development._

Supports:

* Playing media and audio
* Displaying webpages (Coming Soon)

Important Notes:

* Register your chromecast's ID number [with Google](https://developers.google.com/cast/docs/registration#RegisterDevice)
* Configure your chromecast to send it's ID number via the Chromecast app on your telephone
* You must include Google's [official js script](https://www.gstatic.com/cv/js/sender/v1/cast_sender.js) on the page
* The [Chromecast extension](https://chrome.google.com/webstore/detail/google-cast/boadgeojelhgndaghljhdicfkmllpafd?hl=en) is required as it will pop open when users try to cast.

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
