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

  #Enable timeago
  $('.requests-list .timeago').timeago()

  if $('.requests-list').length > 0
    #We are on the requests page

    poll = ->
      getRequestData()
      setTimeout(poll, 1000 * 3)

    poll()


getRequestData = () ->
  $.getJSON '/assistance_requests', (data) ->
    #don't do anything if modal is open
    return if $('.media-list.requests-list .modal.in').length > 0

    $('.media-list.requests-list').html('')
    $('.media-list.code-reviews-list').html('')


    assistances = JSON.parse(data['active_assistances'])
    if(assistances.length > 0)
      $('.media-list.requests-list').append('<h4>Currently Assisting</h4><hr />')
      assistance_template = $('#assitance_template').html()
      Mustache.parse(assistance_template)
      for assistance in assistances
        rendered = Mustache.render(assistance_template, assistance)
        $('.media-list.requests-list').append(rendered)


    requests = JSON.parse(data['requests'])
    if(requests.length > 0)
      $('.media-list.requests-list').append('<h4>Awaiting Assistance</h4><hr />')
      request_template = $('#request_template').html()
      Mustache.parse(request_template)
      for request in requests
        rendered = Mustache.render(request_template, request)
        $('.media-list.requests-list').append(rendered)

    code_review_requests = JSON.parse(data['code_reviews'])
    if(code_review_requests.length > 0)
      $('.media-list.code-reviews-list').append('<h4>Awaiting Code Review</h4><hr />')
      code_reviews_template = $('#code_reviews_template').html()
      Mustache.parse(code_reviews_template)
      for request in code_review_requests
        rendered = Mustache.render(code_reviews_template, request)
        $('.media-list.code-reviews-list').append(rendered)

    all_students = JSON.parse(data['all_students'])
    if(all_students.length > 0)
      $('.media-list.requests-list').append('<h4>All Students</h4><hr />')
      all_student_template = $('#all_student_template').html()
      Mustache.parse(all_student_template)
      for student in all_students
        rendered = Mustache.render(all_student_template, student)
        $('.media-list.requests-list').append(rendered)


    $('.timeago').timeago()
