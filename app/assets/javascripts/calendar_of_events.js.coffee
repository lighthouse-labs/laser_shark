$ ->

  getEvents = (calendar, startDate, endDate, tag) ->

    $('#eventlist').gCalReader

      calendarId: calendar

      apiKey: $('meta[name="google-key"]').attr 'content'

      startDate: startDate

      endDate: endDate

      tag: tag

  getUserDetails = ->

    list = $('#eventlist')
    calendar = list.data 'calendar'
    tag = list.data 'tag'
    day = list.data 'day'
    cohortStartDate = list.data 'start-date'
    startDate = calculateDateOfCurriculumDay(day, cohortStartDate, 'start')
    endDate = calculateDateOfCurriculumDay(day, cohortStartDate, 'end')
    getEvents(calendar, startDate, endDate, tag)

  calculateDateOfCurriculumDay = (day, startDate, type) ->
    # Get which week/day is currently being viewed
    # Subtract one because if they are week 1, should not add an extra week. Similarly, if day 2 should only add 1 day and not 2.
    weeks = parseInt(day[1]) - 1
    # If day is a weekend the number of days to add is 5
    if day[3] is undefined
      days = 5
    else
      days = parseInt day[3] - 1
    # Get the date that curriculum day translates to, e.g. w2d1 would be 1 week after the start date
    dateYear = startDate.substring(0,4)
    dateMonth = startDate.substring(5,7)
    dateDay = startDate.substring(8,10)

    currentDate = new Date dateYear, dateMonth-1, dateDay
    currentDate.setDate(currentDate.getDate() + (weeks * 7 + days))
    if type is 'start'
      currentDate.setHours(1)
    else
      currentDate.setHours(23)
    return currentDate.toISOString()

  # Only do request if eventlist element exists on page
  if $('#eventlist').length is 1
    getUserDetails()
