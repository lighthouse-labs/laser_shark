window.App = {};
# A counter as a temporary workaround of multiple TeacherChannel subscriptions to
# be made.
window.counter = 0;

window.connectToTeachersSocket = ->
  window.counter = window.counter + 1
  if window.counter isnt 1
    console.log('window.connectToTeachersSocket = -> executed: ' + window.counter + ' times')
  else
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

  $.ajax
    url: '/assistance_requests/subscribed'
    dataType: 'json'
    type: 'put'