var RequestQueue = React.createClass({

  propTypes: {
    locations: React.PropTypes.array.isRequired,
    user: React.PropTypes.object.isRequired
  },

  componentWillMount: function() {
    var location;

    if(this.props.user.location)
      location = this.props.user.location;
    else
      location = this.props.locations[0];

    this.setState({location: location});
  },

  componentDidMount: function() {
    this.loadQueue();
    this.requestNotificationPermission();
  },

  componentDidUpdate: function(prevProps, prevState) {
    if(prevState.location.id != this.state.location.id)
      this.loadQueue();
  },

  requestNotificationPermission: function() {
    that = this;
    switch(Notification.permission) {
    case "granted":
      this.setState({canNotify: true})
      break;
    default:
      Notification.requestPermission(function(e) {
        if(e == "granted") {
          that.setState({canNotify: true})
        }
      });
    }
  },

  getInitialState: function() {
    return {
      activeAssistances: [],
      requests: [],
      codeReviews: [],
      students: [],
      hasNotification: ("Notification" in window),
      canNotify: false,

    }
  },

  loadQueue: function() {
    $.getJSON("/assistance_requests/queue?location=" + this.state.location.name, this.requestSuccess);
    this.subscribeToSocket();
  },

  requestSuccess: function(response) {
    this.setState({
      activeAssistances: response.active_assistances,
      requests: response.requests,
      codeReviews: response.code_reviews,
      students: response.all_students
    });
  },

  perform: function(action, data) {
    var url = '/assistances/' + action;
    $.ajax({
      url: url,
      dataType: 'json',
      data: data,
      type: 'put'
    });
  },

  subscribeToSocket: function() {
    var that = this;
    if(App.assistance)
      App.assistance.unsubscribe();

    channel = formatChannelName('assistance', this.state.location.name);
    App.assistance = pusher.subscribe(channel)

    App.assistance.bind('rejected', function() {
      window.location.reload();
    });

    App.assistance.startAssisting = function(request){
      that.perform('start_assisting', {request_id: request.id})
    };

    App.assistance.endAssistance = function(assistance, notes, rating){
      that.perform('end_assistance', {assistance_id: assistance.id, notes: notes, rating: rating})
    };

    App.assistance.providedAssistance = function(student, notes, rating){
      that.perform('provided_assistance', {student_id: student.id, notes: notes, rating: rating})
    };

    App.assistance.cancelAssistanceRequest = function(request){
      that.perform('cancel_assistance_request', {request_id: request.id})
    };

    App.assistance.stopAssisting = function(assistance) {
      that.perform('stop_assisting', {assistance_id: assistance.id})
    };

    App.assistance.bind('received', function(data) {
      switch(data.type) {
        case "AssistanceRequest":
          that.handleAssistanceRequest(data.object);
          break;
        case "CodeReviewRequest":
          that.handleCodeReviewRequest(data.object);
          break;
        case "CancelAssistanceRequest":
          that.removeFromQueue(data.object)
          break;
        case "AssistanceStarted":
          that.handleAssistanceStarted(data.object);
          break;
        case "AssistanceEnded":
          that.removeFromQueue(data.object.assistance_request)
          break;
        case "StoppedAssisting":
          that.removeFromQueue(data.object.assistance_request);

          var assistanceRequest = data.object.assistance_request;
          if(assistanceRequest.activity_submission)
            that.handleCodeReviewRequest(assistanceRequest);
          else
            that.handleAssistanceRequest(assistanceRequest);

          break;
      }
    });

    App.assistance.bind('disconnected', function() {
      $('.reconnect-holder').delay(500).show(0);
    })

    App.assistance.bind('connected', function() {
      if ($('.reconnect-holder').is(':visible')) {
        $('.reconnect-holder').hide();
      }
    });
  },

  handleAssistanceRequest: function(assistanceRequest) {
    var requests = this.state.requests;
    if(this.getRequestIndex(assistanceRequest) === -1 && this.inLocation(assistanceRequest)) {
      requests.push(assistanceRequest);
      requests.sort(function(a,b){
        return new Date(a.start_at) - new Date(b.start_at);
      })
      this.setState({requests: requests});

      this.html5Notification(assistanceRequest);
    }
  },

  html5Notification: function(assistanceRequest) {
    if(this.state.hasNotification && this.state.canNotify) {
      new Notification(
        "Assistance Requested by " + assistanceRequest.requestor.first_name + ' ' + assistanceRequest.requestor.last_name,
        {
          body: assistanceRequest.requestor.cohort.name + "\r\n" + (assistanceRequest.reason || ''),
          icon: assistanceRequest.requestor.avatar_url
        }
      );
    }
  },

  handleCodeReviewRequest: function(codeReviewRequest) {
    var codeReviews = this.state.codeReviews;
    if(this.inLocation(codeReviewRequest)) {
      codeReviews.push(codeReviewRequest);
      codeReviews.sort(function(a,b){
        return new Date(a.start_at) - new Date(b.start_at);
      })
      this.setState({codeReviews: codeReviews});
    }
  },

  removeFromQueue: function(assistanceRequest) {
    this.removeAssistanceFromRequests(assistanceRequest);
    this.removeFromAssisting(assistanceRequest);
    this.removeFromCodeReviews(assistanceRequest);
  },

  handleAssistanceStarted: function(assistance) {
    this.removeAssistanceFromRequests(assistance.assistance_request);
    this.removeFromCodeReviews(assistance.assistance_request);
    if(assistance.assistor.id === this.props.user.id) {
      var activeAssistances = this.state.activeAssistances;
      activeAssistances.push(assistance);
      this.setState({activeAssistances: activeAssistances});
    }
  },

  removeAssistanceFromRequests: function(assistanceRequest) {
    var requests = this.state.requests;
    var ind = this.getRequestIndex(assistanceRequest);
    if(ind > -1) {
      requests.splice(ind, 1);
      this.setState({requests: requests});
    }
  },

  removeFromAssisting: function(assistanceRequest) {
    var activeAssistances = this.state.activeAssistances;
    var ids = activeAssistances.map(function(a) {
      return a.assistance_request.id;
    });

    var ind = ids.indexOf(assistanceRequest.id);
    if(ind > -1) {
      activeAssistances.splice(ind, 1);
      this.setState({activeAssistances: activeAssistances});
    }
  },

  removeFromCodeReviews: function(assistanceRequest) {
    var codeReviews = this.state.codeReviews;
    var ids = codeReviews.map(function(cr) {
      return cr.id;
    });

    var ind = ids.indexOf(assistanceRequest.id);
    if(ind > -1) {
      codeReviews.splice(ind, 1);
      this.setState({codeReviews: codeReviews});
    }
  },

  inLocation: function(assistanceRequest) {
    return assistanceRequest.requestor.cohort.location.id === this.state.location.id;
  },

  getRequestIndex: function(assistanceRequest) {
    var requests = this.state.requests;
    var ids = requests.map(function(r){
      return r.id;
    });

    return ids.indexOf(assistanceRequest.id);
  },

  locationChanged: function(event) {
    var locationNames = this.props.locations.map(function(l) { return l.name });
    var ind = locationNames.indexOf(event.target.value);
    this.setState({location: this.props.locations[ind]});
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
                <label key={location.id}>
                  <input
                    type="radio"
                    value={location.name}
                    checked={that.state.location.id == location.id}
                    onChange={that.locationChanged} />
                    { location.name }
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
          students={this.state.students}
          location={this.state.location} />
      </div>
    )
  }
})