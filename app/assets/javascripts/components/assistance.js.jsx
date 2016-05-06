var Assistance = React.createClass({

  getInitialState: function() {
    return {
      disabled: false
    }
  },

  renderReason: function() {
    var assistance = this.props.assistance;

    if(assistance.assistance_request && assistance.assistance_request.reason)
      return (
        <p>
          <b>Reason:</b> {assistance.assistance_request.reason}
        </p>
      )
  },

  renderSubmission: function() {
    var assistance = this.props.assistance;
    var assistanceRequest = assistance.assistance_request;

    if(assistanceRequest.activity) {
      var activityUrl = "/days/" + assistanceRequest.activity.day + "/activities/" + assistanceRequest.activity.id

      return (
        <div>
          <p>
            <b>Activity:</b>
            <a href={activityUrl}>
              {assistanceRequest.activity.name}
            </a>
          </p>
          <p>
            <b>Submission URL:</b>
            <a target="_blank" href={assistanceRequest.activity_submission.github_url}>
              {assistanceRequest.activity_submission.github_url}
            </a>
          </p>
        </div>
      )
    }
  },

  getContactInformation: function(student) {
    var contacts = [["Email/Screenhero", student.email], ["Slack", student.slack], ["Skype", student.skype]]

    return contacts.filter(function(contact) {
      return contact[1] != null && contact[1] != "";
    });
  },

  renderCancelButton: function(text) {
    return (
      <a className="btn btn-danger btn-lg" onClick={this.stopAssisting} disabled={this.state.disabled}>
        Cancel {text}
      </a>
    )
  },

  stopAssisting: function() {
    this.setState({disabled: true})
    App.assistance.stopAssisting(this.props.assistance)
  },

  openModal: function() {
    this.refs.requestModal.open()
  },

  render: function() {
    var assistance = this.props.assistance;
    var assistanceRequest = assistance.assistance_request;
    var activitySubmission = assistanceRequest.activity_submission;

    var student = assistance.assistee;

    return (
      <RequestItem student={student} location={this.props.location}>
        <p className="assistance-timestamp">
          You started { activitySubmission ? "reviewing" : "assisting"}
          <abbr className="timeago" title="{assitance.start_at}">
            <TimeAgo date={assistance.start_at} />
          </abbr>
        </p>

        { this.renderReason() }
        { this.renderSubmission() }

        <dl className="well">
          {
            this.getContactInformation(student).map(function(contact) {
              return(
                <span key={contact[1]}>
                  <dt>{contact[0]}</dt>
                  <dd>{contact[1]}</dd>
                </span>
              )
            })
          }
        </dl>

        <p>
          <button className="btn btn-primary btn-lg" onClick={this.openModal}>
            { activitySubmission ? "End Code Review" : "End Assistance"}
          </button>

          &nbsp;
          { this.renderCancelButton(activitySubmission ? "Code Review" : "Assisting") }
        </p>

        <RequestModal assistance={assistance} ref="requestModal" />

      </RequestItem>
    )
  }

})
