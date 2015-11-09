var RequestQueue = React.createClass({

  componentWillMount: function() {
    var location;

    if(this.props.user.location)
      location = this.props.user.location.name;
    else
      location = "Vancouver";

    this.setState({location: location});
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
        <RequestQueueItems location={this.state.location} />
      </div>
    )
  }
})