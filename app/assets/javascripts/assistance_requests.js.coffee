$ ->
  assistance_template = $('#assitance_template').html()
  request_template = $('#request_template').html()
  code_reviews_template = $('#code_reviews_template').html()
  all_student_template = $('#all_student_template').html()
  Mustache.parse(assistance_template)
  Mustache.parse(request_template)
  Mustache.parse(code_reviews_template)
  Mustache.parse(all_student_template)

  getRequestData = () ->
    $.getJSON '/assistance_requests', (data) ->
      # Don't do anything if modal is open
      return if $('.requests-list .modal.in').length > 0

      requests_list = $('.requests-list')
      requests_list.empty()

      assistances = JSON.parse(data['active_assistances'])
      if (assistances.length > 0)
        requests_list.append('<h3 class="section-heading">Currently Assisting</h3>')
        assistances_list = $('<ul class="student-list">')
        requests_list.append(assistances_list)
        for assistance in assistances
          assistances_list.append(Mustache.render(assistance_template, assistance))

      requests = JSON.parse(data['requests'])
      if (requests.length > 0)
        requests_list.append('<h3 class="section-heading">Awaiting Assistance</h3>')
        requests_media_list = $('<ul class="student-list">')
        requests_list.append(requests_media_list)
        for request in requests
          requests_media_list.append(Mustache.render(request_template, request))

      code_review_requests = JSON.parse(data['code_reviews'])
      if (code_review_requests.length > 0)
        requests_list.append('<h3 class="section-heading">Awaiting Code Review</h3>')
        code_reviews_list = $('<ul class="student-list">')
        requests_list.append(code_reviews_list)
        for code_review_request in code_review_requests
          code_reviews_list.append(Mustache.render(code_reviews_template, code_review_request))

      all_students = JSON.parse(data['all_students'])
      if (all_students.length > 0)
        requests_list.append('<h3 class="section-heading">All Students</h3>')
        all_students_list = $('<ul class="student-list">')
        requests_list.append(all_students_list)
        for student in all_students
          all_students_list.append(Mustache.render(all_student_template, student))

      $('.timeago').timeago()

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
