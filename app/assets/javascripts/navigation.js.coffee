$ ->

  $('.request-assistance-button').click (e) ->
    e.preventDefault()
    reason = $(@).closest('form').find('textarea').val()
    $.ajax
      url: '/assistance_requests'
      dataType: 'json'
      type: 'post'
      data: 
        reason: reason
      success: (data, textStatus, request) ->
        $('#cancel-assistance-request').attr('data-id', data.id)

  $('.cancel-request-assistance-button').click (e) ->
    e.preventDefault()
    e.stopPropagation()
    if confirm("Are you sure you want to withdraw this assistance request?")
      $.ajax
        url: '/assistance_requests/' + $('#cancel-assistance-request').attr('data-id')
        dataType: 'json'
        type: 'delete'

  $('.duty-state-button').click (e) ->
    e.preventDefault()
    $.ajax
      url: '/teachers/' + window.current_user.id + '/toggleDutyState'
      dataType: 'json'
      type: 'patch'

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