var Request = React.createClass({

  startAssisting: function() {
    App.assistance.startAssisting(this.props.request);
  },

  cancelAssistance: function() {
    if(confirm("Are you sure you want to cancel this Request?"))
      App.assistance.cancelAssistanceRequest(this.props.request);
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
          <a className="btn btn-danger btn-lg" onClick={this.cancelAssistance}>&times;</a>
        </p>
      </RequestItem>
    )
  }

});