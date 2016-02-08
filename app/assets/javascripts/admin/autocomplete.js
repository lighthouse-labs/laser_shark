$(function() {

  function dataProvider(data) {
    $('#search-bar-input-display').autocomplete({
      source: data,
      autoFocus: true,
      select: select,
      focus: focus
    }).autocomplete('instance')._renderItem = render;
    $( '#search-bar-input-display' ).autocomplete( "option", "appendTo", ".activities-autocomplete-selections" );
  }

  function select(e, ui) {
    $('#search-bar-input-display').val(ui.item.name + ' - ' + ui.item.day);
    $('#search-bar-input-selection').val(ui.item.id);
    return false;
  }

  function render(ul, item) {
    var display = [
      '<span class="activity-display activity-display-name">' + item.name + '</span>',
      '<span class="activity-display activity-display-type">' + item.type + '</span>',
      '<span class="activity-display activity-display-day">' + item.day + '</span>'
    ];

    return $('<li>')
        .append(display.join(''))
        .appendTo(ul);
  }

  $('#search-bar-input-display').click(function() {
    $.ajax({
      dataType: 'json',
      method: 'GET',
      url: window.location.pathname + '/autocomplete.json',
      success: function (response) {
        dataProvider(response.outcomes);
      },
      error: function (response) {
        console.log('Autocomplete malfunctioned.', response)
      }
    });
  });
});