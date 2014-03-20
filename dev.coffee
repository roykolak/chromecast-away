watch = require('watch')
exec = require('child_process').exec

exec('./node_modules/.bin/coffee -w -o lib/ -c src/')
exec('./node_modules/.bin/coffee -w -o examples/default_media_receiver_example/ -c examples/default_media_receiver_example/')
exec('./node_modules/.bin/http-server examples -p 8989')
console.log "Running examples at localhost:8989"

callback = ->
  console.log "bundling\n"
  exec('./node_modules/.bin/browserify lib/cast-away.js -o cast-away.js')
  exec('./node_modules/.bin/uglifyjs cast-away.js --screw-ie8 -o cast-away.min.js')

callback()

watch.createMonitor 'lib', (monitor) ->
  monitor.on "changed", callback
  monitor.on "removed", callback
  monitor.on "created", callback
