window.App = {};

window.connectToTeachersSocket = ->
  App.teacherChannel = pusher.subscribe(formatChannelName('TeacherChannel'))
  App.teacherChannel.bind('received', (data) ->
    h = new TeacherChannelHandler data
    h.processResponse()
  )

$ ->
  channel = formatChannelName('UserChannel', window.current_user.id)
  App.userChannel = pusher.subscribe(channel)
  App.userChannel.bind('connected', ->
    if $('.reconnect-holder').is(':visible')
       $('.reconnect-holder').hide()
  )

  App.userChannel.bind('disconnected', () ->
    $('.reconnect-holder').delay(500).show(0)
  )

  App.userChannel.bind('received', (data) ->
    handler = new UserChannelHandler data
    handler.processResponse()
  )

  $.ajax
    url: '/assistance_requests/subscribed'
    dataType: 'json'
    type: 'put'