class window.UserChannelHandler
  constructor: (data) ->
    @type = data.type
    @object = data.object

  processResponse: (callback) ->
    switch @type
      when "UserConnected"
        @userConnected()
      else
        presenter = new RequestButtonPresenter @type, @object
        presenter.render()

  userConnected: ->
    window.current_user = @object

    if(!App.teacherChannel || (App.teacherChannel && App.teacherChannel.consumer.connection.disconnected))
      # Connect to the teachers socket when we know the user has connected
      window.connectToTeachersSocket()
    