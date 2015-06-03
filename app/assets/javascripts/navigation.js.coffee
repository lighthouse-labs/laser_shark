$ ->
  ar_module = $('#assistance-request-module')

  haveAssistanceUI = ->
    return ar_module.length > 0

  if haveAssistanceUI()

    ar_create = $('#create-assistance-request')
    ar_create_button = ar_create.find('a')
    ar_cancel = $('#cancel-assistance-request')
    ar_cancel_button = ar_cancel.find('a')

    ar_cancel_button.tooltip()

    ar_form = $('#assistance-request-form')
    ar_modal = $('#assistance-request-reason-modal')

    ar_form.on('submit', ->
      ar_modal.modal('hide')
      ar_cancel_button.text('Waiting for Assistance')
      ar_create.addClass('hidden')
      ar_cancel.removeClass('hidden')
      setTimeout(updateAssistanceUI, 10000)
    )

    ar_cancel_button.click (e) ->
      if confirm("Are you sure you want to withdraw this assistance request?")
        ar_cancel.addClass('hidden')
        ar_create.removeClass('hidden')
      else
        return false

    updateAssistanceUI = ->
      $.getJSON '/assistance_requests/status', (data) ->
        if data.state == 'waiting'
          ar_cancel_button.text('No. ' + data.position_in_queue + ' in Request Queue')

        if data.state == 'active'
          ar_cancel_button.text(data.assistor.first_name + ' ' + data.assistor.last_name + ' assisting')

        if data.state == 'waiting' || data.state == 'active'
          ar_create.addClass('hidden')
          ar_cancel.removeClass('hidden')
          setTimeout(updateAssistanceUI, 30000)
        else
          ar_create.removeClass('hidden')
          ar_cancel.addClass('hidden')

    updateAssistanceUI()
