$ ->    

  $('#view_code_review_modal').on 'show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    codeReviewAssistanceId = button.data('code-review-assistance-id')
    modal = $(this)
    $.ajax(
      url: '/assistances/' + codeReviewAssistanceId + '/view_code_review_modal'
      method: 'GET').done (info) ->
        modal.find('.view-modal-content').html(info)

  $('#new_code_review_modal').on 'show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    studentID = button.data('student-id')
    modal = $(this)
    $.ajax(
      url: '/students/' + studentID + '/new_code_review_modal'
      method: 'GET').done (info) ->
        modal.find('.new-modal-content').html(info)  