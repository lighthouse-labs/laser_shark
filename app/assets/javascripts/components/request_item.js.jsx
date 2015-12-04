var RequestItem = React.createClass({
  
  render: function() {
    var student = this.props.student;

    return(
      <li>
        <div className="student-avatar">
          <img src={student.avatar_url} />
        </div>

        <div className="student-description">
          <h4 className="student-heading">{student.first_name} {student.last_name}</h4>
          <p className="student-cohort">
            <a href={"cohorts/" + student.cohort.id + "/students"} className="cohort-name">
              {student.cohort.name}
              <span className="cohort-location">
                {student.location.name}
              </span>
              { student.remote ? <span className="student-remote">Remote</span> : null }
            </a>
          </p>

          { this.props.children }
        </div>
      </li>
    )
  }

})