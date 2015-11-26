class window.RequestButtonPresenter
  constructor: (type, object) ->
    @type = type
    @object = object
    @ar_create = $('#create-assistance-request')
    @ar_create_button = @ar_create.find('a')
    @ar_cancel = $('#cancel-assistance-request')
    @ar_cancel_button = @ar_cancel.find('a')

  render: ->
    switch @type
      when "AssistanceRequested" then @assistanceRequested(@object) 
      when "AssistanceStarted" then @assistanceStarted(@object)
      when "AssistanceEnded" then @assistanceEnded()
      when "QueueUpdate" then @updateQueuePosition(@object)

  updateQueuePosition: (position) ->
    @ar_cancel_button.text('No. ' + position + ' in Request Queue')

  assistanceStarted: (assistor) ->
    @ar_cancel_button.text(assistor.first_name + ' ' + assistor.last_name + ' assisting')

  assistanceEnded: ->
    @ar_create.removeClass('hidden')
    @ar_cancel.addClass('hidden')

  assistanceRequested: (position) ->
    @ar_create.addClass('hidden')
    @ar_cancel.removeClass('hidden') 
    @ar_cancel_button.text('No. ' + position + ' in Request Queue')
    @ar_cancel_button.tooltip()



