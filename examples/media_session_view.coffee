class MediaSessionView
  constructor: ->
    @$el = $('.session')

  attachEvents: (session, controls) ->
    $('.controls', @$el).show()

    $('.pause', @$el).click (ev) =>
      ev.preventDefault()
      controls.pause()
      @markAsSelected $(ev.currentTarget)

    $('.play', @$el).click (ev) =>
      ev.preventDefault()
      controls.play()
      @markAsSelected $(ev.currentTarget)

    $('.stop', @$el).click (ev) =>
      ev.preventDefault()
      controls.stop()
      @markAsSelected $(ev.currentTarget)

    $('.release', @$el).click (ev) ->
      ev.preventDefault()
      $('.name').text 'Not casting'
      $('.controls').hide()
      session.release()

  updateSession: (session) ->
    $('.receiver_name').text session.receiverName()
    $('.display_name').text session.displayName()

    session.on 'play', =>
      @markAsSelected $('.play')
    session.on 'pause', =>
      @markAsSelected $('.pause')
    session.on 'stop', =>
      @markAsSelected $('.stop')
    session.on 'release', =>
      $('.receiver_name').text 'Not casting'
      $('.display_name').text ''

  markAsSelected: ($el) ->
    $('.current', @$el).removeClass('current')
    $el.addClass('current')

window.MediaSessionView = MediaSessionView
