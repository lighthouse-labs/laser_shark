window.App = {};

window.connectToTeachersSocket = ->
  channelName = formatChannelName('TeacherChannel')

  App.teacherChannel = pusher.subscribe(channelName)

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

  window.connectToTeachersSocket()