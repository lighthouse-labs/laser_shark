window.App = {};
App.cable = Cable.createConsumer('ws://compass.dev:3000/websocket');

App.userChannel = App.cable.subscriptions.create("UserChannel", 
  requestAssistance: (reason) ->
    @perform 'request_assistance', reason: reason

  cancelAssistanceRequest: ->
    @perform 'cancel_assistance'

  received: (data) ->
    console.log data
)