$ ->
  $('.incomplete-activity-submit-button').click (e) ->
    that = $(e.target)
    activityId = that.data 'activity-id'
    activityType = that.data 'activity-type'

    incompleteActivitiesTitle = $('.incomplete-activities-title')
    numberOfIncompleteActivities = parseInt incompleteActivitiesTitle.text().match(/\d+/)

    feedbackNavItem = $('#feedback-link')
    numberOfFeedbacks = parseInt feedbackNavItem.text().match(/\d+/)

    $.ajax
      url: '/activities/' + activityId + '/activity_submission'
      type: 'POST'
      success: (result) ->
        that.closest('.incomplete-activity-details-row').hide() 
        # Update total count of incomplete activities on index page
        incompleteActivitiesTitle.text('Incomplete Activities (' + (numberOfIncompleteActivities-1).toString() + ')')
        # Update total number of feedbacks in nav menu if activity is not a lecture.
        # This will need to change once Web Sockets are used
        unless activityType is 'Lecture'
          feedbackNavItem.text('Feedback (' + (numberOfFeedbacks+1).toString() + ')')