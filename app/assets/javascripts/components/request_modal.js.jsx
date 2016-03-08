var RequestModal = React.createClass({

  getInitialState: function(){
    return {
      notesValid: true,
      ratingValid: true
    }
  },

  open: function() {
    $(this.refs.modal).modal()
  },

  close: function() {
    $(this.refs.modal).modal('hide')
  },

  setNotesError: function(){
    this.setState({ notesValid: this.notesIsValid() });
  },

  setRatingError: function(){
    this.setState({ ratingValid: this.ratingIsValid() });
  },

  ratingIsValid: function(){
    var rating = this.refs.rating.value;
    return rating !== '';
  },

  notesIsValid: function(){
    var notes = this.refs.notes.value;
    return notes.trim() !== '';
  },

  formIsValid: function(){
    return this.notesIsValid() && this.ratingIsValid();
  },

  endAssistance: function() {
    var notes = this.refs.notes.value;
    var rating = this.refs.rating.value;

    if(!this.formIsValid()){
      this.setNotesError();
      this.setRatingError();
      return;
    }

    this.close();

    if(this.props.assistance){
      App.assistance.endAssistance(this.props.assistance, notes, rating);
    } else {
      App.assistance.providedAssistance(this.props.student, notes, rating);
    }
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

              <div className={this.state.notesValid ? "form-group" : "form-group has-error"}>
                <textarea
                  onChange={this.setNotesError}
                  className="form-control" 
                  placeholder="How did the assistance go?"
                  ref="notes">
                </textarea>
              </div>

              <div className={this.state.ratingValid ? "form-group" : "form-group has-error"}>
                <label>Rating</label>
                <select
                  onChange={this.setRatingError}
                  className="form-control" 
                  ref="rating"
                  required="true">
                    <option value=''>Please Select</option>
                    <option value="1">L1 | Struggling</option>
                    <option value="2">L2 | Slightly behind</option>
                    <option value="3">L3 | On track</option>
                    <option value="4">L4 | Excellent (Needs stretch)</option>
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