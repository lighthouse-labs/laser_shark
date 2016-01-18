$ ->    

  $('#view_code_review_modal').on 'show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    codeReviewAssistanceId = button.data('code-review-assistance-id')
    modal = $(this)
    $.ajax(
      url: '/assistances/' + codeReviewAssistanceId + '/view_code_review_modal'
      method: 'GET').done (info) ->
        modal.find('.view-modal-content').html(info)

  $('#new_code_review_modal').on 'show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    studentID = button.data('student-id')
    modal = $(this)
    $.ajax(
      url: '/students/' + studentID + '/new_code_review_modal'
      method: 'GET').done (info) ->
        modal.find('.new-modal-content').html(info)  
        initEditors()
        bindValidationsToForm()

  initEditors = ->
    teacherNotesEditor = ace.edit("teacher-notes")
    studentNotesEditor = ace.edit("student-notes")

    teacherNotesEditor.setTheme("ace/theme/monokai")
    studentNotesEditor.setTheme("ace/theme/monokai")

    teacherNotesEditor.getSession().setMode("ace/mode/markdown")
    studentNotesEditor.getSession().setMode("ace/mode/markdown")

    teacherNotesEditor.setValue('Please enter some teacher (internal) notes')
    studentNotesEditor.setValue('Please enter some feedback to be emailed to the student')

    $('#new_assistance').submit (e) ->
      e.preventDefault()
      # $('#assistance_notes').val(teacherNotesEditor.getValue())
      # $('#assistance_student_notes').val(studentNotesEditor.getValue())
      # this.submit()

  bindValidationsToForm = ->
    $('#new-code-review-submit-button').on 'click', (e) ->
      error_messages = []

      activity = $('#activity_submission_id').val()
      if activity == ''
        e.preventDefault()
        error_messages.push('Please choose an activity to code review')

      console.log error_messages