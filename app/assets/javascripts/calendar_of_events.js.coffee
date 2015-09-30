$ ->

  list = $('#eventlist')  
  location = list.data 'location'
  if location is 'Toronto'
    calendarLocation = 'functionalimperative.com_du453ucqlvlir8rtf1sdjdd1ak@group.calendar.google.com'
  else
    # Need to get Vancouver calendar address
    calendarLocation = 'en.canadian#holiday@group.v.calendar.google.com'

  $('#eventlist').gCalReader

    # Public Google Calendar
    # calendarId:'functionalimperative.com_du453ucqlvlir8rtf1sdjdd1ak@group.calendar.google.com'
    calendarId: calendarLocation

    # Google API KEY
    # I think we need to put one for compass
    apiKey:'AIzaSyA0e9Ts3CSV9CQ-dOV-Pxwc2d5EszJBFLI'

    # <a href="http://www.jqueryscript.net/time-clock/">date</a> format
    dateFormat: 'LongDate'

    # error message
    errorMsg: 'No events in calendar'

    # maximum events
    maxEvents: 50

    # future-events filter
    futureEventsOnly: true

    # descending sort order
    sortDescending: true