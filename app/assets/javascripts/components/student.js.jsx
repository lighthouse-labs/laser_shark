var Student = React.createClass({

  openModal: function() {
    this.refs.requestModal.open()
  },

  render: function() {
    var student = this.props.student;

    return (
      <RequestItem student={student}>
        <p className="assistance-timestamp">
          Last received assistance
          <abbr className='timeago' ref="lastAssistedTime" title={student.last_assisted_at}>
            {student.last_assisted_at ? <TimeAgo date={student.last_assisted_at} /> : "never"}
          </abbr>
        </p>

        <p>
          <a className="btn btn-primary btn-lg" onClick={this.openModal}>
            Assisted
          </a>
        </p>

        <RequestModal student={student} ref="requestModal" />
      </RequestItem>
    )
  }

})