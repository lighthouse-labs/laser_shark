var RequestModal = React.createClass({

  open: function() {
    $(this.refs.modal).modal()
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
    var assistanceRequest = this.props.assistanceRequest;

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
            <form action={"/assistances/" + assistanceRequest.id} method="post">
              <div className="modal-body">

                { this.renderReason(assistanceRequest) }

                <div className="form-group">
                  <textarea 
                    id="assistance_notes" 
                    name="assistance[notes]" 
                    className="form-control" 
                    placeholder="How did the assistance go?">
                  </textarea>
                </div>

                <div className="form-group">
                  <label>Rating</label>
                  <select id="assistance_rating" name="assistance[rating]" className="form-control" defaultValue="3">
                    <option value="1">Needs improvement</option>
                    <option value="2">Fair</option>
                    <option value="3">Good</option>
                    <option value="4">Excellent</option>
                  </select>
                </div>
              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" className="btn btn-primary" data-dismiss="modal">End Assistance</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    )
  }

});