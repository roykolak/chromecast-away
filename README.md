Chromecast-Away
=====================

A nice, friendly wrapper for Chromecast that doesn't judge you and always sends thank you cards upon receiving something nice from a friend because it appreciates emotional responses.

_Still in heavy development._

Supports:

* Playing via default media receiver
* Playing via custom media receiver (Coming Soon)
* Displaying HTML via custom receiver (Coming Soon)

Important Notes:

* Register your chromecast's ID number [with Google](https://developers.google.com/cast/docs/registration#RegisterDevice)
* Configure your chromecast to send it's ID number via the Chromecast app on your telephone
* You must include Google's [official js script](https://www.gstatic.com/cv/js/sender/v1/cast_sender.js) on the page
* The [Chromecast extension](https://chrome.google.com/webstore/detail/google-cast/boadgeojelhgndaghljhdicfkmllpafd?hl=en) is required as it will pop open when users try to cast.
* Here's all the [official docs](https://developers.google.com/cast/docs/developers)

Playing via default media receiver
------------------------

Want to just play media right now?

```coffee
  castAway = new CastAway()
  castAway.initialize
    receiversAvailable: ->
      castConnection.requestSession
        success: (receiver) ->
          media =
            url: 'https://s3.amazonaws.com/roysfunfun/ghostbuster_ringtone.mp3'
            contentType: 'audio/mpeg'

          receiver.load media,
            success: (controls) ->
              controls.pause()
              controls.play()
              controls.stop()
              controls.seek(100) # time in seconds
              receiver.release() # kills session, releases chromecast

            error: (data) ->
              # Error loading media

        error: (data) ->
          # Error requesting session

    receiversUnAvailable: ->
      # No receivers found

    error: (data) ->
      # Error connecting
```

Playing via custom media receiver
------------------------

Want all the baked in goodness of the default media receiver, but your own custom look via CSS?

```js
  # Coming soon
```

Displaying HTML via custom receiver
------------------------

Want send HTML/CSS/JS to a chromecast and do everything yourself to impress your friends and win influence?

```coffee
  # Coming soon!
```
