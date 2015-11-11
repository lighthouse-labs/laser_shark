var RequestQueue = React.createClass({

  componentWillMount: function() {
    var location;

    if(this.props.user.location)
      location = this.props.user.location.name;
    else
      location = "Vancouver";

    this.setState({location: location});
  },

  componentDidMount: function() {
    this.loadQueue();
    this.subscribeToSocket();
  },

  componentDidUpdate: function(prevProps, prevState) {
    if(prevState.location != this.state.location)
      this.loadQueue();
  },

  getInitialState: function() {
    return {
      activeAssistances: [],
      requests: [],
      codeReviews: [],
      students: []
    }
  },
  
  loadQueue: function() {
    $.getJSON("/assistance_requests/queue?location=" + this.state.location, this.requestSuccess)  
  },

  requestSuccess: function(response) {
    this.setState({
      activeAssistances: response.active_assistances,
      requests: response.requests,
      codeReviews: response.code_reviews,
      students: response.all_students
    });
  },

  subscribeToSocket: function() {
    var that = this;
    App.assistance = App.cable.subscriptions.create("AssistanceChannel", {
      connected: function() {
        console.log("connected")
      },
      received: function(data) {
        console.log(data)
        switch(data.type) {
          case "AssistanceRequest":
            that.handleAssistanceRequest(data.object);
            break;
          case "CancelAssistanceRequest":
            that.handleCancelAssistanceRequest(data.object)
            break;
        }
      }
    });
  },

  handleAssistanceRequest: function(assistanceRequest) {
    var requests = this.state.requests;
    requests.push(assistanceRequest);
    this.setState({requests: requests});
  },

  handleCancelAssistanceRequest: function(assistanceRequest) {
    var requests = this.state.requests;
    var ids = requests.map(function(r){ 
      return r.id;
    });

    var ind = ids.indexOf(assistanceRequest.id);
    
    if(ind > -1) {
      requests.splice(ind, 1);
      this.setState({requests: requests});
    }
  },

  locationChanged: function(event) {
    this.setState({location: event.target.value});
  },

  renderLocations: function() {
    var that = this;

    if(this.props.user.location)
      return (
        <div id="cohort-locations">
          Cohort locations:
          { 
            this.props.locations.map(function(location) {
              return (
                <label key={location}>
                  <input 
                    type="radio" 
                    value={location} 
                    checked={that.state.location == location}
                    onChange={that.locationChanged}
                    onClick={that.locationChanged} />
                    { location }
                </label>
              )
            })
          }
        </div>
      )
    else
      return (
        <div id="cohort-locations">
          Looks like your profile doesn&#39;t have a location!
        </div>
      )
  },

  render: function() {
    return(
      <div>
        { this.renderLocations() }
        <RequestQueueItems
          activeAssistances={this.state.activeAssistances}
          requests={this.state.requests}
          codeReviews={this.state.codeReviews}
          students={this.state.students} />
      </div>
    )
  }
})