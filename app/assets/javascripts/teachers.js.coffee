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

  $('.read-more').readmore
    speed: 75
    moreLink: '<a class="read-more-link" href="#">Read More</a>'
    lessLink: '<a class="read-more-link" href="#">Close</a>'
    collapsedHeight: 38