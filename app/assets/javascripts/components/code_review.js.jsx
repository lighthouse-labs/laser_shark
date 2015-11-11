var CodeReview = React.createClass({

  startAssisting: function() {
    App.assistance.startAssisting(this.props.codeReview);
  },

  cancelAssistance: function() {
    if(confirm("Are you sure you want to cancel this Request?"))
      App.assistance.cancelAssistanceRequest(this.props.codeReview);
  },

  renderSubmission: function() {
    var codeReview = this.props.codeReview;

    if(codeReview.activitySubmission)
      return (
        <div>
          <p>
            <b>Activity:</b> 
            <a href={"/days/" + codeReview.activity_submission.activity.day + "/activities/" + codeReview.activity_submission.activity.id}>
              {codeReview.activity_submission.activity.name}
            </a>
          </p>
          <p>
            <b>Submission URL:</b> 
            <a target="_blank" href={codeReview.activity_submission.github_url}>
              {codeReview.activity_submission.github_url}
            </a>
          </p>
        </div>
      )
  },
  
  render: function() {
    var codeReview = this.props.codeReview;
    var student = codeReview.requestor;

    return (
      <RequestItem student={student}>
        <p className="assistance-timestamp">
          Generated code review 
          <abbr className="timeago" title="{codeReview.start_at}">
            {$.timeago(codeReview.start_at)}
          </abbr>
        </p>

        { this.renderSubmission() }
        <p>
          <a className="btn btn-primary btn-lg" onClick={this.startAssisting}>Start Reviewing</a>
          &nbsp;
          <a className="btn btn-danger btn-lg" onClick={this.cancelAssistance}>&times;</a>
        </p>
      </RequestItem>
    )
  }

});