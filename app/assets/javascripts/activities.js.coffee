$ ->
  $('#student_submit_code_review_button').on 'click', (event) ->
    hiddenGithubUrl = $('#hidden_github_url_input')
    visibleGithubUrl = $('#activity_submission_github_url')
    hiddenGithubUrl.val(visibleGithubUrl.val())

  $('#show-objectives-button').on 'click', (event) ->
    $(this).toggle()
    $(this).siblings('#hide-objectives-button').css('display', 'inline-block')
    $(this).siblings('.day-objectives-holder').toggle()

  $('#hide-objectives-button').on 'click', (event) ->
    $(this).toggle()
    $(this).siblings('#show-objectives-button').css('display', 'inline-block')
    $(this).siblings('.day-objectives-holder').toggle()