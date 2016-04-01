$ ->
  console.log($('#new_quiz_submission'))
$('#new_quiz_submission').on 'submit', (e) ->
    console.log("submit")
    $('.submission-answer').each ->
      if $(this).children(':checked').length < 1
        $(this).addClass 'list-group-item-danger'
        e.preventDefault

