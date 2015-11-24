class window.TeacherChannelHandler
  constructor: (data) ->
    @type = data.type
    @object = data.object

  processResponse: ->
    switch @type
      when "UserConnected"
        @userConnected()
      when "TeacherOnDuty" 
        @teacherOnDuty()
      when "TeacherOffDuty" 
        @teacherOffDuty()
      when "TeacherBusy"
        @teacherBusy()
      when "TeacherAvailable"
        @teacherAvailable()

  userConnected: ->
    for teacher in @object
      if @teacherInLocation(teacher)
        @addTeacherToSidebar(teacher)

  teacherOnDuty: ->
    if @teacherInLocation(@object)
      @addTeacherToSidebar(@object)

  teacherOffDuty: ->
    if @teacherInLocation(@object)
      @removeTeacherFromSidebar(@object)

  teacherBusy: ->
    $('.teacher-holder').find('#teacher_' + @object.id).addClass('busy')

  teacherAvailable: ->
    $('.teacher-holder').find('#teacher_' + @object.id).removeClass('busy')

  teacherInLocation: (teacher) ->
    if current_user
      if current_user.type is 'Teacher' 
        return current_user.location.id is teacher.location.id
      else
        if current_user.cohort
          return current_user.cohort.location.id is teacher.location.id

  addTeacherToSidebar: (teacher) ->
    if $('.teacher-holder').find('#teacher_' + teacher.id).length is 0
      img = document.createElement('img')
      img.id = 'teacher_' + teacher.id
      img.src = teacher.avatar_url

      link = document.createElement('a')
      link.href = "/teachers/" + teacher.id

      link.appendChild(img)

      if teacher.busy
        img.className = 'busy'

      $('.teacher-holder').append(link)

  removeTeacherFromSidebar: (teacher) ->
    $('.teacher-holder').find('#teacher_' + teacher.id).remove()

  