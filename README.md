ChromecastAway
=====================

[![NPM version](https://badge.fury.io/js/chromecast-away.svg)](http://badge.fury.io/js/chromecast-away)

A nice, friendly wrapper for Chromecast that doesn't judge you and always sends thank you cards upon receiving something nice from a friend because it appreciates emotional responses.

Supports:

(Receiver = the app that's running on the chromecast)

* Playing via default media receiver
* Playing via custom media receiver
* Displaying HTML via custom receiver

For code examples, visit the [project page](http://roykolak.github.io/chromecast-away/)

Important Notes:

* Register your chromecast's ID number [with Google](https://developers.google.com/cast/docs/registration#RegisterDevice)
* Configure your chromecast to send it's ID number via the Chromecast app on your telephone
* You must include Google's [official js script](https://www.gstatic.com/cv/js/sender/v1/cast_sender.js) on the page
* The [Chromecast extension](https://chrome.google.com/webstore/detail/google-cast/boadgeojelhgndaghljhdicfkmllpafd?hl=en) is required as it will pop open when users try to cast.
* Here's all the [official docs](https://developers.google.com/cast/docs/developers)
* Inspect the Chromecast by hitting http://CHROMECAST-IP:9222 (get the ip via the phone app)
