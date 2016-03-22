$(function() {

  var app = window.app = {};

  app.Outcomes = function() {
    this._input = $('#search-bar-input-display');
    this._hiddenAcitivityIdField = $('#hidden-activity-id-field');
    this._initAutocomplete();
  };

  app.Outcomes.prototype = {

    _initAutocomplete: function() {
      this._input
        .autocomplete({
          source: window.location.pathname.replace("/edit", "") + "/autocomplete.json?",
          appendTo: '.activities-autocomplete-selections',
          select: $.proxy(this._select, this)
        })
        .autocomplete('instance')._renderItem = $.proxy(this._render, this);
    },

    _select: function(e, ui) {
      if (ui.item.day)
        this._input.val(ui.item.name + ' - ' + ui.item.day);
      else
        this._input.val(ui.item.text);
      
      this._hiddenAcitivityIdField.val(ui.item.id);
      return false;
    },

    _render: function(ul, item) {
      // Check whether we are autocompleting activities or outcomes
      if (item.day)
        var display = [
          '<span class="activity-display activity-display-name">' + item.name + '</span>',
          '<span class="activity-display activity-display-type">' + item.type + '</span>',
          '<span class="activity-display activity-display-day">' + item.day + '</span>'
        ];
      else
        var display = [
          '<span class="activity-display activity-display-name">' + item.text + '</span>',
        ];

      return $('<li>').append(display.join('')).appendTo(ul);
    },

  };

  new app.Outcomes;
})