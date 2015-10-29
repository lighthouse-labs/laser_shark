$ ->

  actionDayFeedback = (id) ->
    $.ajax
      url: '/admin/dayfeedbacks/' + id
      type: 'DELETE'

  $('.archive-button').click (e) ->
    $(this).siblings('.archive-confirm-button').show()
    $(this).hide()

  $('.archive-confirm-button').click (e) ->
    id = $(this).parents('td').data 'id'
    archived_filter_status = $('#archived_').val()

    actionDayFeedback(id)
    if archived_filter_status is 'false'
      $(this).closest('tr').hide(500)
    else
      $(this).hide()
      $(this).siblings('.unarchive-button').show()

  $('.unarchive-button').click (e) ->
    id = $(this).parents('td').data 'id'
    $(this).hide()
    actionDayFeedback(id)
    $(this).siblings('.archive-button').show()