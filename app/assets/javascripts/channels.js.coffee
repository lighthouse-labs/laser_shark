window.App = {};

# This is a hack because the asset pipeline doesn't respect the ENV['HOST'] when doing a precompile for production
host = window.location.hostname;
if window.location.port isnt ""
  host += ":#{window.location.port}"

App.cable = Cable.createConsumer('ws://' + host + '/websocket');

App.userChannel = App.cable.subscriptions.create("UserChannel", 
  requestAssistance: (reason) ->
    @perform 'request_assistance', reason: reason

  cancelAssistanceRequest: ->
    @perform 'cancel_assistance'

  received: (data) ->
    # For now these all do the same thing, but they may do other things
    switch data.type
      when "AssistanceRequested" then updateAssistanceUI() 
      when "AssistanceStarted" then updateAssistanceUI()
      when "AssistanceCancelled" then updateAssistanceUI()
      when "AssistanceEnded" then updateAssistanceUI()

)