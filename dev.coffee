watch = require('watch')
exec = require('child_process').exec

exec('./node_modules/.bin/coffee -w -o lib/ -c src/')
exec('./node_modules/.bin/coffee -w -o examples/default_media_receiver_example/ -c examples/default_media_receiver_example/')
exec('./node_modules/.bin/http-server examples -p 8989')
console.log "Running examples at localhost:8989"

watch.createMonitor 'lib', (monitor) ->
  callback = (f) ->
    console.log "bundling\n"
    exec('./node_modules/.bin/browserify lib/cast-away.js -o cast-away.js')

  monitor.on "changed", callback
  monitor.on "removed", callback
  monitor.on "created", callback
