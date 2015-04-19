$ ->
  ar_module = $('#assistance-request-module')

  haveAssistanceUI = ->
    return ar_module.length > 0

  if haveAssistanceUI()

    ar_create_button = $('#assistance-request-create-button')
    ar_cancel_button = $('#assistance-request-cancel-button')
    ar_cancel_buttons = $('.cancel-request')
    ar_current_assistor = $('#assistance-request-current-assistor')
    ar_current_assistor_name = ar_current_assistor.find('.assistor_name')

    default_cancel_button_text = ar_cancel_button.text()

    ar_create_button.click (e) ->
      $(@).addClass('hidden')
      ar_cancel_button.removeClass('hidden')

    ar_cancel_buttons.click (e) ->
      if confirm("Are you sure you want to cancel your request?")
        ar_cancel_button.addClass('hidden')
        ar_current_assistor.addClass('hidden')
        ar_create_button.removeClass('hidden')
      else
        return false

    updateAssistanceUI = ->
      $.getJSON '/assistance_requests/status', (data) ->
        cancel_button_text = if data.state == 'waiting' then 'No. ' + data.position_in_queue + ' in Request Queue' else default_cancel_button_text
        ar_cancel_button.text(cancel_button_text)

        current_assistor_text = if data.state == 'active' then data.assistor.first_name + ' ' + data.assistor.last_name else ''
        ar_current_assistor_name.text(current_assistor_text)

        if data.state == 'active'
          ar_create_button.addClass('hidden')
          ar_cancel_button.addClass('hidden')
          ar_current_assistor.removeClass('hidden')
        else if data.state == 'waiting'
          ar_create_button.addClass('hidden')
          ar_cancel_button.removeClass('hidden')
          ar_current_assistor.addClass('hidden')
        else
          ar_create_button.removeClass('hidden')
          ar_cancel_button.addClass('hidden')
          ar_current_assistor.addClass('hidden')

    poll = ->
      updateAssistanceUI()
      setTimeout(poll, 6000)

    poll()