// Generated by CoffeeScript 1.7.1
(function() {
  var CustomReceiver, DEFAULT_MAX_INACTIVITY, DEFAULT_STATUS_TEXT, EventEmitter,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  EventEmitter = require("./event_emitter");

  DEFAULT_STATUS_TEXT = "Ready";

  DEFAULT_MAX_INACTIVITY = 60;

  module.exports = CustomReceiver = (function(_super) {
    __extends(CustomReceiver, _super);

    function CustomReceiver(config, castAway) {
      this.castAway = castAway;
      this.onMessage = __bind(this.onMessage, this);
      this.namespace = this.castAway.namespace || "urn:x-cast:json";
      this.config = new cast.receiver.CastReceiverManager.Config();
      this.config.statusText = config.statusText || DEFAULT_STATUS_TEXT;
      this.config.maxInactivity = config.maxInactivity || DEFAULT_MAX_INACTIVITY;
    }

    CustomReceiver.prototype.start = function() {
      var bus, manager;
      manager = cast.receiver.CastReceiverManager.getInstance();
      bus = manager.getCastMessageBus(this.namespace);
      bus.onMessage = this.onMessage;
      return manager.start(this.config);
    };

    CustomReceiver.prototype.onMessage = function(event) {
      var data, msgName, payload;
      data = JSON.parse(event.data);
      msgName = data._name;
      payload = data._payload;
      return this.emit(msgName, payload);
    };

    return CustomReceiver;

  })(EventEmitter);

}).call(this);