$ ->

  $('.archive-button').click (e) ->
    that = $(e.target)
    action = that.text()
    archived_filter_status = $('#archived_').val()
    id = that.data 'id'
    if action is 'Archive'
      response = confirm 'Are you sure?'
      if response is true
        $.ajax
          url: '/admin/dayfeedbacks/' + id
          type: 'DELETE'
          success: (result) ->
            if archived_filter_status is 'false'
              that.closest('tr').hide()
            else
              that.text 'Unarchive'    
    else
      $.ajax
        url: '/admin/dayfeedbacks/' + id
        type: 'DELETE'
        success: (result) ->
          that.text 'Archive'