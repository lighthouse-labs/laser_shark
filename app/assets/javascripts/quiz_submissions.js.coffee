$ ->
  $('#new_quiz_submission').submit (e) ->
    $('.submission-answer .list-group').each () ->
      if $(this).children(':checked').length < 1
        $(this).addClass 'unanswered'
    if $('.unanswered').length < 0
      e.preventDefault()
