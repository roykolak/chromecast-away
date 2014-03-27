EventEmitter = require "./event_emitter"

DEFAULT_STATUS_TEXT = "Ready"
DEFAULT_MAX_INACTIVITY = 60

module.exports = class CustomReceiver extends EventEmitter
  constructor: (config, @castAway) ->
    @namespace = @castAway.namespace || "urn:x-cast:json"
    @config = new cast.receiver.CastReceiverManager.Config()
    @config.statusText = config.statusText || DEFAULT_STATUS_TEXT
    @config.maxInactivity = config.maxInactivity || DEFAULT_MAX_INACTIVITY

  start: ->
    manager = cast.receiver.CastReceiverManager.getInstance()
    bus = manager.getCastMessageBus(@namespace)
    bus.onMessage = @onMessage
    manager.start @config

  onMessage: (event) =>
    data = JSON.parse event.data
    msgName = data._name
    payload = data._payload
    @emit msgName, payload
