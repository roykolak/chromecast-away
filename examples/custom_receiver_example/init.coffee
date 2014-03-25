castAway = window.castAway = new CastAway applicationID: "8D5CA342", namespace: "urn:x-cast:json"

castAway.on "receivers:available", ->
  console.log "receivers available"
  $("#cast").click (ev) ->
    ev.preventDefault()
    castAway.requestSession (err, session) ->
      if err
        return console.log "Error getting session", err
      window.session = session
      $("#start-panel").hide()
      $("#message-panel").show()
      $("#send-message").click (e) ->
        val = $("#message").val()
        console.log "Sending #{val}"
        $("#message").val("")
        session.send "displayMessage", message: val, (err, data) ->
          if err
            console.log "error", err

castAway.initialize (err, data) ->
  if err
    console.log "error initialized", err
  else
    console.log "initialized", data
