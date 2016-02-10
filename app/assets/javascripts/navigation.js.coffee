$ ->

  $('.request-assistance-button').click (e) ->
    e.preventDefault()
    reason = $(@).closest('form').find('textarea').val()
    $.ajax
      url: '/assistance_requests'
      dataType: 'json'
      type: 'post'
      data: reason: reason

  $('.cancel-request-assistance-button').click (e) ->
    e.preventDefault()
    e.stopPropagation()

    if confirm("Are you sure you want to withdraw this assistance request?")
      $.ajax
        url: '/assistance_requests/cancel'
        dataType: 'json'
        type: 'delete'

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

  $('.sign-out-link').click (e) ->
    window.App.teacherChannel.offDuty()

  $('#search-activities-button').click (e) ->
    $('#search-form').slideToggle(250, 'swing', focusOnSearchField)

  focusOnSearchField = ->
    inputField = $('#search-form').find('.search-input-field').find('input')
    if !(inputField.is(':hidden'))
      inputField.focus()

  if window.location.pathname == '/search_activities'
    $('#search-form').toggle()