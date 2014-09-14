$ ->
  $('.assistance-request > .btn').click (e) ->
    if $(@).hasClass('delete-request')
      if !confirm("Are you sure you want to cancel your request?")
        e.stopPropagation()
        e.preventDefault()
      else
        $(@).removeClass('active')
        $(@).parent().children().not('.delete-request').addClass('active')
    else
      $(@).removeClass('active')
      $(@).parent().children('.delete-request').addClass('active')
