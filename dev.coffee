watch = require('watch')
exec = require('child_process').exec

exec('./node_modules/.bin/coffee -w -o lib/ -c src/')

watch.createMonitor 'lib', (monitor) ->
  callback = (f) ->
    console.log "bundling\n"
    exec('./node_modules/.bin/browserify lib/cast-away.js -o cast-away.js')

  monitor.on "changed", callback
  monitor.on "removed", callback
  monitor.on "created", callback
