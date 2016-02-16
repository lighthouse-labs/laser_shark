var RequestModal = React.createClass({

  open: function() {
    $(this.refs.modal).modal()
  },

  close: function() {
    $(this.refs.modal).modal('hide')
  },

  endAssistance: function() {
    var notes = this.refs.notes.value;
    var rating = this.refs.rating.value;

    this.close()

    if(this.props.assistance)
      App.assistance.endAssistance(this.props.assistance, notes, rating)
    else
      App.assistance.renderOffline(this.props.student, notes, rating)
  },

  renderReason: function(assistanceRequest) {
    if(assistanceRequest.reason)
      return (
        <div className="form-group">
          <b>Original reason:</b>
          {assistanceRequest.reason}
        </div>
      )
  },

  render: function() {
    var assistance = this.props.assistance;

    if(assistance)
      var assistanceRequest = assistance.assistance_request;

    return (
      <div className="modal fade" ref="modal">
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <button type="button" className="close">
                <span aria-hidden="true">&times;</span>
                <span className="sr-only">Close</span>
              </button>
              <h4 className="modal-title">Notes</h4>
            </div>
            <div className="modal-body">

              { assistanceRequest ? this.renderReason(assistanceRequest) : null }

              <div className="form-group">
                <textarea
                  className="form-control"
                  placeholder="How did the assistance go?"
                  ref="notes">
                </textarea>
              </div>

              <div className="form-group">
                <label>Rating</label>
                <select
                  className="form-control"
                  defaultValue="3"
                  ref="rating">
                    <option value="1">Needs improvement</option>
                    <option value="2">Fair</option>
                    <option value="3">Good</option>
                    <option value="4">Excellent</option>
                </select>
              </div>
            </div>
            <div className="modal-footer">
              <button type="button" className="btn btn-default" onClick={this.close}>Cancel</button>
              <button type="button" className="btn btn-primary" onClick={this.endAssistance}>End Assistance</button>
            </div>
          </div>
        </div>
      </div>
    )
  }

});