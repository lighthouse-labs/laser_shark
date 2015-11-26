$ ->

  $('.request-assistance-button').click (e) ->
    e.preventDefault()
    reason = $(@).closest('form').find('textarea').val()
    window.App.userChannel.requestAssistance(reason)

  $('.cancel-request-assistance-button').click (e) ->
    e.preventDefault()
    e.stopPropagation()

    if confirm("Are you sure you want to withdraw this assistance request?")
      window.App.userChannel.cancelAssistanceRequest()

  $('.on-duty-link').click (e) ->
    e.preventDefault()
    window.App.teacherChannel.onDuty()

    $('.on-duty-link').addClass('hidden')
    $('.off-duty-link').removeClass('hidden')

  $('.off-duty-link').click (e) ->
    e.preventDefault()
    window.App.teacherChannel.offDuty()

    $('.off-duty-link').addClass('hidden')
    $('.on-duty-link').removeClass('hidden')