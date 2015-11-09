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
      students: response.all_students,
      requests: response.requests
    });
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
        <h3 className="section-heading">Currently Assisting</h3>
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