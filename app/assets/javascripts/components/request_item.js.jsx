var RequestItem = React.createClass({

  renderStudentLocation: function() {
    var student = this.props.student;

    if(this.props.location.id != student.location.id)
      return (
        <small>
          - {student.location.name}
          { student.remote ? <span className="label label-info">Remote</span> : null }
        </small>
      )
  },
  
  render: function() {
    var student = this.props.student;

    return(
      <li>
        <div className="student-avatar">
          <img src={student.avatar_url} />
        </div>

        <div className="student-description">
          <h4 className="student-heading">
            {student.first_name} {student.last_name}
            { this.renderStudentLocation() }
          </h4>
          <p className="student-cohort">
            <a href={"cohorts/" + student.cohort.id + "/students"} className="cohort-name">
              {student.cohort.name}
            </a>
          </p>

          { this.props.children }
        </div>
      </li>
    )
  }

})