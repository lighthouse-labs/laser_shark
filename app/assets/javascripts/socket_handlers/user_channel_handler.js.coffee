class window.UserChannelHandler
  constructor: (data) ->
    @type = data.type
    @object = data.object

  processResponse: (callback) ->
    # For now these all do the same thing, but they may do other things
    switch @type
      when "UserConnected"
        @userConnected()
      when "AssistanceRequested" then updateAssistanceUI() 
      when "AssistanceStarted" then updateAssistanceUI()
      when "AssistanceCancelled" then updateAssistanceUI()
      when "AssistanceEnded" then updateAssistanceUI()

  userConnected: ->
    window.current_user = @object

    # Connect to the teachers socket when we know the user has connected
    window.connectToTeachersSocket()