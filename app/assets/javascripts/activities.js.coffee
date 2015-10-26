$ ->
  $('#student-submit-code-review-button').on 'click', (event) ->
    hiddenGithubUrl = $('#hidden_github_url_input')
    visibleGithubUrl = $('#activity_submission_github_url')
    hiddenGithubUrl.val(visibleGithubUrl.val())