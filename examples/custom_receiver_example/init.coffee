castAway = window.castAway = new CastAway applicationID: "8D5CA342", namespace: "urn:x-cast:json"

castAway.on "receivers:available", ->
  console.log "receivers available"
  $("#cast").click (ev) ->
    ev.preventDefault()
    console.log "requesting session"
    castAway.requestSession
      success: (session) ->
        console.log "Got session", session
        window.session = session
        $("#start-panel").hide()
        $("#message-panel").show()
        $("#send-message").click (e) ->
          val = $("#message").val()
          console.log "Sending #{val}"
          $("#message").val("")
          session.sendMessage "urn:x-cast:json", JSON.stringify(message: val),
            (() -> console.log "success", arguments),
            (() -> console.log "error", arguments)
      error: ->
        console.log "Error", arguments

castAway.initialize
  success: (data) ->
    console.log "initialized", data
  error: (data) ->
    console.log "error initialized", data
