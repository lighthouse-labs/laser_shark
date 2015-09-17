$.fn.raty.defaults.path = "/assets"

$ ->

  bindRatyElements = =>
    # Make viewer raty divs
    $('div.raty-viewer').raty
      readOnly: true,
      hints: ['Terrible', 'Bad', 'OK', 'Good', 'Awesome'],
      score: ->
        $(@).data('score')

    # Make editable raty divs
    $('div.raty-editor').raty
      hints: ['Terrible', 'Bad', 'OK', 'Good', 'Awesome'],
      score: ->
        $(@).data('score')
      click: (score, evt) ->
        # TODO: Set a hidden field value
        $(this).find('input').attr('value', score)

  bindRatyElements()

  $('#feedback_modal').on 'show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    feedback_id = button.data('feedback-id')
    modal = $(this)
    $.ajax(
      url: '/feedbacks/'+feedback_id+'/modal_content'
      method: 'GET').done (info) ->
        modal.find('.modal-content').html(info)
        # Redraw the Raty stars on new elements
        bindRatyElements()

  $('#feedback_modal').on 'hidden.bs.modal', ->
    $(this).find('form')[0].reset()