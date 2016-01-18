$ ->

  $('#view_code_review_modal').on 'show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    codeReviewAssistanceId = button.data('code-review-assistance-id')
    modal = $(this)
    $.ajax(
      url: '/assistances/' + codeReviewAssistanceId + '/code_review_assistance_modal'
      method: 'GET').done (info) ->
        modal.find('.modal-content').html(info)