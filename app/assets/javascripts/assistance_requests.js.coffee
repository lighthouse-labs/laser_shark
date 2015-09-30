$ ->
  assistance_template = $('#assitance_template').html()
  request_template = $('#request_template').html()
  code_reviews_template = $('#code_reviews_template').html()
  all_student_template = $('#all_student_template').html()
  Mustache.parse(assistance_template)
  Mustache.parse(request_template)
  Mustache.parse(code_reviews_template)
  Mustache.parse(all_student_template)

  # Set variable for checkboxes
  cohorts_locations_checkboxes = $('#cohort-locations').find('input[type=radio]')
  
  getLocation = ->
    return cohorts_locations_checkboxes.filter(':checked')[0].value

  getRequestData = ->
    location = getLocation()
    $.getJSON("/assistance_requests/queue?location=#{location}", requestSuccess)
      
  requestSuccess = (data) ->
    # Don't do anything if modal is open
    return if $('.requests-list .modal.in').length > 0

    requests_list = $('.requests-list')
    requests_list.empty()

    assistances = data['active_assistances']
    if (assistances.length > 0)
      requests_list.append('<h3 class="section-heading">Currently Assisting</h3>')
      assistances_list = $('<ul class="student-list">')
      requests_list.append(assistances_list)
      for assistance in assistances
        assistances_list.append(Mustache.render(assistance_template, assistance))

    requests = data['requests']
    if (requests.length > 0)
      requests_list.append('<h3 class="section-heading">Awaiting Assistance</h3>')
      requests_media_list = $('<ul class="student-list">')
      requests_list.append(requests_media_list)
      for request in requests
        requests_media_list.append(Mustache.render(request_template, request))

    code_review_requests = data['code_reviews']
    if (code_review_requests.length > 0)
      requests_list.append('<h3 class="section-heading">Awaiting Code Review</h3>')
      code_reviews_list = $('<ul class="student-list">')
      requests_list.append(code_reviews_list)
      for code_review_request in code_review_requests
        code_reviews_list.append(Mustache.render(code_reviews_template, code_review_request))

    all_students = data['all_students']
    if (all_students.length > 0)
      requests_list.append('<h3 class="section-heading">All Students</h3>')
      all_students_list = $('<ul class="student-list">')
      requests_list.append(all_students_list)
      for student in all_students
        all_students_list.append(Mustache.render(all_student_template, student))

    $('.timeago').timeago()

  onRequestsPage = ->
    return $('.requests-list').length > 0
  
  if onRequestsPage()
    poll = ->
      getRequestData().always(->
        setTimeout(poll, 10000)
      )

    poll()

  # when checkbox changes, fetch new data immediately 
  cohorts_locations_checkboxes.on 'change', getRequestData
  
  # updateCohortLocationsCookie = ->
  #   locations_string = encodeURIComponent(JSON.stringify(selected_locations))
  #   expires = new Date()
  #   expires.setFullYear(expires.getFullYear() + 1)
  #   expiry_string = expires.toUTCString()
  #   document.cookie = 'cohort_locations=' + locations_string + '; expires=' + expiry_string + '; path=/'
  #   getRequestData()
