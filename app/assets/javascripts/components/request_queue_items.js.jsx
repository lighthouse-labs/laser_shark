var RequestQueueItems = React.createClass({

  renderAssisting: function() {
    if(this.props.activeAssistances.length > 0) {
      return (
        <div>
          <h3 className="section-heading">Currently Assisting</h3>
          <ul className="student-list">
            { 
              this.props.activeAssistances.map(function(assistance) { 
                return <Assistance assistance={assistance} key={assistance.id}/>
              })
            }
          </ul>
        </div>
      )
    }
  },

  renderRequests: function() {
    if(this.props.requests.length > 0)
      return this.props.requests.map(function(request) {
        return <Request request={request} key={request.id} />
      })
    else
      return <i>This queue is empty.  Good job!</i>
  },

  renderCodeReviews: function() {
    if(this.props.codeReviews.length > 0)
      return this.props.codeReviews.map(function(codeReview) {
        return <CodeReview codeReview={codeReview} key={codeReview.id} />
      })
    else
      return <i>There aren&#39;t any code reviews</i>
  },

  renderStudents: function() {
    return this.props.students.map(function(student) {
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