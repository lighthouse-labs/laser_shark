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

    setInterval(getRequestData, 1000*30)
    getRequestData()


getRequestData = () ->
  $.getJSON '/assistance_requests', (data) ->
    #don't do anything if modal is open
    return if $('.media-list.requests-list .modal.in').length > 0

    $('.media-list.requests-list').html('')

    assistance_template = $('#assitance_template').html()
    Mustache.parse(assistance_template)
    assistances = JSON.parse(data['active_assistances'])
    for assistance in assistances
      rendered = Mustache.render(assistance_template, assistance)
      $('.media-list.requests-list').append(rendered)

    request_template = $('#request_template').html()
    Mustache.parse(request_template)
    requests = JSON.parse(data['requests'])
    for request in requests
      rendered = Mustache.render(request_template, request)
      $('.media-list.requests-list').append(rendered)

    $('.media-list.requests-list').append('<hr />')

    all_student_template = $('#all_student_template').html()
    Mustache.parse(all_student_template)
    all_students = JSON.parse(data['allStudents'])
    for all_student in all_students
      rendered = Mustache.render(all_student_template, all_student)
      $('.media-list.requests-list').append(rendered)

    $('.requests-list .timeago').timeago()
