var RequestQueueItems = React.createClass({

  getInitialState: function() {
    return {
      activeAssistances: [],
      requests: [],
      codeReviews: [],
      students: []
    }
  },

  componentDidMount: function() {
    this.loadQueue();
  },

  componentDidUpdate: function(prevProps, prevState) {
    if(prevProps.location != this.props.location)
      this.loadQueue();
  },

  loadQueue: function() {
    $.getJSON("/assistance_requests/queue?location=" + this.props.location, this.requestSuccess)  
  },

  requestSuccess: function(response) {
    this.setState({
      activeAssistances: response.active_assistances,
      requests: response.requests,
      codeReviews: response.code_reviews,
      students: response.all_students
    });
  },

  renderAssisting: function() {
    if(this.state.activeAssistances.length > 0) {
      return (
        <div>
          <h3 className="section-heading">Currently Assisting</h3>
          <ul className="student-list">
            { 
              this.state.activeAssistances.map(function(assistance) { 
                return <Assistance assistance={assistance} key={assistance.id}/>
              })
            }
          </ul>
        </div>
      )
    }
  },

  renderRequests: function() {
    if(this.state.requests.length > 0)
      return this.state.requests.map(function(request) {
        return <Request request={request} key={request.id} />
      })
    else
      return <i>This queue is empty.  Good job!</i>
  },

  renderCodeReviews: function() {
    if(this.state.codeReviews.length > 0)
      return this.state.codeReviews.map(function(codeReview) {
        return <CodeReview codeReview={codeReview} key={codeReview.id} />
      })
    else
      return <i>There aren&#39;t any code reviews</i>
  },

  renderStudents: function() {
    return this.state.students.map(function(student) {
      return <Student student={student} key={student.id} />
    })
  },

  render: function() {
    return (
      <div className="requests-list">
        
        { this.renderAssisting() }

        <h3 className="section-heading">Awaiting Assistance</h3>
        <ul className="student-list">
          { this.renderRequests() }
        </ul>

        <h3 className="section-heading">Awaiting Code Review</h3>
        <ul className="student-list">
          { this.renderCodeReviews() }
        </ul>        

        <h3 className="section-heading">All Students</h3>
        <ul className="student-list">
          { this.renderStudents() }
        </ul>
      </div>
    )
  }
})