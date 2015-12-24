$ ->

  reactivateStudent = (id) ->
    $.ajax
      url: '/admin/students/' + id + '/reactivate'
      type: 'POST'

  deactivateStudent = (id) ->
    $.ajax
      url: '/admin/students/' + id + '/deactivate'
      type: 'POST'

  changeCohort = (studentID, cohortID) ->
    $.ajax
      url: '/admin/students/' + studentID + '?cohort_id=' + cohortID
      type: 'PUT'

  changeMentor = (studentID, mentorID) ->
    $.ajax
      url: '/admin/students/' + studentID + '?mentor_id=' + cohortID
      type: 'PUT'    

  $('.student-reactivate-button').click (e) ->
    id = $(this).parents('td').parents('tr').data 'id'
    reactivateStudent(id)
    $(this).hide()
    $(this).siblings('.student-deactivate-button').show()
    
  $('.student-deactivate-button').click (e) ->
    id = $(this).parents('td').parents('tr').data 'id'
    deactivateStudent(id)
    $(this).hide()
    $(this).siblings('.student-reactivate-button').show()

  $('.admin-student-cohort-selector').change ->
    cohortID = $(this).val()
    newCohortName = $(this).find('option:selected').text()
    studentID = $(this).parents('td').parents('tr').data 'id'
    changeCohort(studentID, cohortID)
    $(this).parents('td').html('<div class="admin-student-cohort-changed"> Cohort changed to ' + newCohortName + '! </div>')

  $('#student-actions-modal').on 'show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    studentID = button.data('student-id')
    modal = $(this)
    $.ajax(
      url: '/admin/students/'+studentID+'/modal_content'
      method: 'GET').done (info) ->
        modal.find('.modal-content').html(info)
