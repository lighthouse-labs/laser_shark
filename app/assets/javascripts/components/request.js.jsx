var Request = React.createClass({

  startAssisting: function() {
    App.assistance.startAssisting(this.props.request);
  },
  
  render: function() {
    var request = this.props.request;
    var student = request.requestor;

    return (
      <RequestItem student={student}>
        <p className="assistance-timestamp">
          Requested assistance 
          <abbr className="timeago" title="{request.start_at}">
            {$.timeago(request.start_at)}
          </abbr>
        </p>
        <p><b>Reason:</b> {request.reason}</p>
        <p>
          <a className="btn btn-primary btn-lg" onClick={this.startAssisting}>Start Assisting</a>
          &nbsp;
          <a href={"/assistance_requests/" + request.id} className="btn btn-danger btn-lg" data-method="delete">&times;</a>
        </p>
      </RequestItem>
    )
  }

});