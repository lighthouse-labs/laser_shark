$ ->
  $('.outcome-skills-form').on 'click', '.remove_fields', (event) ->
    event.preventDefault()

    $(this).parent().prev().find('input[type=hidden]').val('true')
    $(this).closest('.row').hide()

  $('.add_fields').on 'click', (event) ->
    event.preventDefault()
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    