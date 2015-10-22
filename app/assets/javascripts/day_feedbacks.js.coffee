$ ->
  $('.archive-button').click (e) ->
    that = $(e.target)
    action = that.text()
    archived_filter_status = $('#archived_').val()
    id = that.data 'id'
    if action is 'Archive'
      that.hide()
      that.next().show()
      $('.archive-confirm-button').click (e) ->
        $.ajax
          url: '/admin/dayfeedbacks/' + id
          type: 'DELETE'
          success: (result) ->
            if archived_filter_status is 'false'
              that.closest('tr').hide(500)
            else
              that.text 'Unarchive'    
              that.show()
              that.next().hide()
    else
      $.ajax
        url: '/admin/dayfeedbacks/' + id
        type: 'DELETE'
        success: (result) ->
          that.text 'Archive'