var Request = React.createClass({

  getInitialState: function() {
    return {
      disabled: false
    }
  },

  startAssisting: function() {
    this.setState({disabled: true})
    App.assistance.startAssisting(this.props.request);
  },

  cancelAssistance: function() {
    if(confirm("Are you sure you want to cancel this Request?")) {
      this.setState({disabled: true})
      App.assistance.cancelAssistanceRequest(this.props.request);
    }
  },
  
  render: function() {
    var request = this.props.request;
    var student = request.requestor;

    return (
      <RequestItem student={student}>
        <p className="assistance-timestamp">
          Requested assistance: 
          <abbr className="timeago" title="{request.start_at}">
            <TimeAgo date={request.start_at} />
          </abbr>
        </p>
        <p><b>Reason:</b> {request.reason}</p>
        <p>
          <a className="btn btn-primary btn-lg" onClick={this.startAssisting} disabled={this.state.disabled}>Start Assisting</a>
          &nbsp;
          <a className="btn btn-danger btn-lg" onClick={this.cancelAssistance} disabled={this.state.disabled}>Remove from queue</a>
        </p>
      </RequestItem>
    )
  }

});