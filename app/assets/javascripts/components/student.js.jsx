var Student = React.createClass({

  render: function() {
    var student = this.props.student;

    return (
      <RequestItem student={student}>
        <p className="assistance-timestamp">
          Last received assistance
          <abbr className='timeago' ref="lastAssistedTime" title={student.last_assisted_at}>
            {student.last_assisted_at ? $.timeago(student.last_assisted_at) : "never"}
          </abbr>
        </p>

        <p>
          <a href={"students/" + student.id + "/assistances"} className="btn btn-primary btn-lg" data-method="post">
            Checkin On
          </a>
        </p>
      </RequestItem>
    )
  }

})