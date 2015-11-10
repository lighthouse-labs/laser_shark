var CodeReview = React.createClass({

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
          <a href={"/assistance_requests/" + codeReview.id + "/start_assistance"} className="btn btn-primary btn-lg" data-method="post">Start Reviewing</a>
          &nbsp;
          <a href={"/assistance_requests/" + codeReview.id} className="btn btn-danger btn-lg" data-method="delete">&times;</a>
        </p>
      </RequestItem>
    )
  }

});