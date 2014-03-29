// Generated by CoffeeScript 1.7.1
(function() {
  var castAway;

  castAway = window.castAway = new CastAway({
    applicationID: "EC8A2707",
    namespace: "urn:x-cast:json"
  });

  castAway.on("receivers:available", function() {
    console.log("receivers available");
    return $("#cast").click(function(ev) {
      ev.preventDefault();
      return castAway.requestSession(function(err, session) {
        if (err) {
          return console.log("Error getting session", err);
        }
        window.session = session;
        $("#start-panel").hide();
        $("#message-panel").show();
        return $("#send-message").click(function(e) {
          var val;
          val = $("#message").val();
          console.log("Sending " + val);
          $("#message").val("");
          return session.send("displayMessage", {
            message: val
          }, function(err, data) {
            if (err) {
              return console.log("error", err);
            }
          });
        });
      });
    });
  });

  castAway.on('existingMediaFound', function(session) {
    debugger;
    window.session = session;
    $("#start-panel").hide();
    $("#message-panel").show();
    return $("#send-message").click(function(e) {
      var val;
      val = $("#message").val();
      console.log("Sending " + val);
      $("#message").val("");
      return session.send("displayMessage", {
        message: val
      }, function(err, data) {
        if (err) {
          return console.log("error", err);
        }
      });
    });
  });

  castAway.initialize(function(err, data) {
    if (err) {
      return console.log("error initialized", err);
    } else {
      return console.log("initialized", data);
    }
  });

}).call(this);