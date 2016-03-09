$ ->

  teachers_locations_checkboxes = $('#teachers-selected-locations').find('input[type=radio]')

  show_teachers_in_location = ->
    $('.teacher').hide()
    selected_locations = teachers_locations_checkboxes.filter(':checked').map(-> $(this).val()).get()
    selected_locations.forEach (location) ->
      $('.teacher.' + location).show()

  show_teachers_in_location()

  teachers_locations_checkboxes.on 'change', ->  
    show_teachers_in_location()    

  bind_readmore_to_feedbacks = (element) ->
    if element
      element.readmore
        speed: 75
        moreLink: '<a class="read-more-link" href="#">Read More</a>'
        lessLink: '<a class="read-more-link" href="#">Close</a>'
        collapsedHeight: 45
    else
      $('.read-more').readmore
        speed: 75
        moreLink: '<a class="read-more-link" href="#">Read More</a>'
        lessLink: '<a class="read-more-link" href="#">Close</a>'
        collapsedHeight: 45

  bind_readmore_to_feedbacks()

  $('.best_in_place').bind 'ajax:success', ->
    bind_readmore_to_feedbacks $(this).closest('.read-more')

  # For modifying mentor status of teachers:

  removeMentorship = (id, callback) ->
    $.ajax
      url: '/teachers/' + id + '/remove_mentorship'
      type: 'POST'
      success: callback

  addMentorship = (id, callback) ->
    $.ajax
      url: '/teachers/' + id + '/add_mentorship'
      type: 'POST'
      success: callback

  $('.remove-mentor-button').click (e) ->
    that = this
    $(this).attr('disabled', true)
    id = $(this).siblings('.teacher-mentor-status').data 'id'
    removeMentorship(id, -> 
      $(that).css('display', 'none')
      $(that).attr('disabled', false)
      $(that).siblings('.make-mentor-button').css('display', 'inline-block')
      )

  $('.make-mentor-button').click (e) ->
    that = this
    $(this).attr('disabled', true)
    id = $(this).siblings('.teacher-mentor-status').data 'id'
    addMentorship(id, -> 
      $(that).css('display', 'none')
      $(that).attr('disabled', false)
      $(that).siblings('.remove-mentor-button').css('display', 'inline-block')
      )
