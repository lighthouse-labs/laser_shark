# Set the location for the images used in Raty Star plugin
$.fn.raty.defaults.path = "/assets"

$ ->

  bindValidation = ->
    $('#modal-submit-button').on 'click', (event) ->
      technical_rating = $('#modal-technical-rating').val()
      style_rating = $('#modal-style-rating').val()
      
      unless technical_rating && style_rating
        event.preventDefault()        
      
        error_message = $('<strong id="error_message">**Please fill in both ratings**</strong><br>')
        error_message.css('color', 'tomato')
        error_message.prependTo '.modal-body'

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

  $('#feedback_modal').on 'show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    feedback_id = button.data('feedback-id')
    modal = $(this)
    $.ajax(
      url: '/feedbacks/'+feedback_id+'/modal_content'
      method: 'GET').done (info) ->
        modal.find('.modal-content').html(info)
        # Redraw the Raty stars on new elements after they load from AJAX
        bindRatyElements()
        bindValidation()


  $('#feedback_modal').on 'hidden.bs.modal', (event) ->
    $(this).find('form')[0].reset()

  # Draw all Raty stars on the page when it loads
  bindRatyElements()

  


  