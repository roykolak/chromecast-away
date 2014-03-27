CastAway
=====================

A nice, friendly wrapper for Chromecast that doesn't judge you and always sends thank you cards upon receiving something nice from a friend because it appreciates emotional responses.

_Still in heavy development._

Supports:

(Receiver = the app that's running on the chromecast)

* Playing via default media receiver
* Playing via custom media receiver (Coming Soon)
* Displaying HTML via custom receiver (Coming Soon)

Important Notes:

* Register your chromecast's ID number [with Google](https://developers.google.com/cast/docs/registration#RegisterDevice)
* Configure your chromecast to send it's ID number via the Chromecast app on your telephone
* You must include Google's [official js script](https://www.gstatic.com/cv/js/sender/v1/cast_sender.js) on the page
* The [Chromecast extension](https://chrome.google.com/webstore/detail/google-cast/boadgeojelhgndaghljhdicfkmllpafd?hl=en) is required as it will pop open when users try to cast.
* Here's all the [official docs](https://developers.google.com/cast/docs/developers)
* Inspect the Chromecast by hitting http://CHROMECAST-IP:9222 (get the ip via the phone app)

Playing via default media receiver
------------------------

Want to just play media (music, video, photos) right now with some baked in support for displaying basic metadata about the content?

```coffee
castAway = new CastAway()

castAway.on 'receivers:available', ->
  # receivers available, safe to request a session

  castAway.requestSession (err, session) ->
    if err
      return # error starting session (user canceled it)

    config =
      url: 'https://s3.amazonaws.com/...mp3'
      contentType: 'audio/mpeg'
      artist: 'Will Smith'
      images: ["http://www.willy-smith.com/men-in-black....jpg"]

    # Also available: '.photo', '.movie', '.tvShow' ... see examples
    session.music config, (err, controls) ->
      if err
        return # error loading media

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

castAway.on 'receivers:unavailable', ->
  # No receivers found

castAway.on 'existingMediaFound', (session, controls) ->
  # found existing media session, interact with it via
  # the passed session and controls.

castAway.initialize (err, data) ->
  if err
    # unsuccessfully initialized, cry
  else
    # successfully initialized, party
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

### Receiver Code

```html
<h1>Put Messages on Your TV!</h1>
<ul id="messages"></ul>
```

```coffee
castAway = new CastAway()
receiver = castAway.receive()

receiver.on "displayMessage", (data) ->
  $("#messages").append "<li>" + data.message + "</li>"
```

### Sender Code

```html
<h1>Put Messages on Your TV!</h1>
<input id="message" type="text" /><button id="send-message">Send</button>
```

```coffee
castAway = new CastAway applicationID: "XXXXXXXXX"

castAway.on "receivers:available", ->
  castAway.requestSession (err, session) ->
    $("#send-message").click ->
      val = $("#message").val()
      session.send "displayMessage", message: val, (err, data) ->
        if err
          console.log "error", err
        else
          console.log "success", data

castAway.initialize (err, data) ->
  if err
    console.log "error initializing", err
  else
    console.log "initialized", data
```
