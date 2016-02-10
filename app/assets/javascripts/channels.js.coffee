window.App = {};

# This is a hack because the asset pipeline doesn't respect the ENV['HOST'] when doing a precompile for production
host = window.location.hostname;
if window.location.port isnt ""
  host += ":#{window.location.port}"

App.cable = Cable.createConsumer('ws://' + host + '/websocket');

window.connectToTeachersSocket = ->
  App.teacherChannel = App.cable.subscriptions.create("TeacherChannel",
    onDuty: ->
      @perform 'on_duty'

    offDuty: ->
      @perform 'off_duty'

    received: (data) ->
      handler = new TeacherChannelHandler data
      handler.processResponse()
  )

$ ->
  App.userChannel = pusher.subscribe('UserChannel' + window.current_user.id)
  App.userChannel.bind('connected', ->
    if $('.reconnect-holder').is(':visible')
       $('.reconnect-holder').hide()
  )

  App.userChannel.bind('AssistanceRequested', (data) ->
    handler = new UserChannelHandler { type: 'AssistanceRequested', object: data.object}
    handler.processResponse()
  )

  App.userChannel.bind('AssistanceEnded', ->
    handler = new UserChannelHandler { type: 'AssistanceEnded' }
    handler.processResponse()
  )

  App.userChannel.bind('disconnected', () ->
    $('.reconnect-holder').delay(500).show(0)
  )
  # App.userChannel = App.cable.subscriptions.create("UserChannel",

  #   connected: ->

  #   requestAssistance: (reason) ->

  #   cancelAssistanceRequest: ->

  #   received: (data) ->

  #   disconnected: ->
  # )