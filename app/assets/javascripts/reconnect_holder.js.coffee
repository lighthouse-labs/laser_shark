$ ->
  $('.reconnect-holder .reconnect').click ->
    window.location.reload()

  $('.reconnect-holder .dismiss').click ->
    $('.reconnect-holder').hide()