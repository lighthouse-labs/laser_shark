$ ->

  $('#eventlist').gCalReader

    # Public Google Calendar
    calendarId:'en.canadian#holiday@group.v.calendar.google.com'

    # Google API KEY
    apiKey:'AIzaSyA0e9Ts3CSV9CQ-dOV-Pxwc2d5EszJBFLI'

    # <a href="http://www.jqueryscript.net/time-clock/">date</a> format
    dateFormat: 'LongDate'

    # error message
    errorMsg: 'No events in calendar'

    # maximum events
    maxEvents: 25

    # future-events filter
    futureEventsOnly: true

    # descending sort order
    sortDescending: true