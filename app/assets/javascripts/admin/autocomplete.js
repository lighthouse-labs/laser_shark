$(function() {

  function dataProvider(data) {
    $('#search-bar-input-display').autocomplete({
      source: data,
      autoFocus: true,
      select: select
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

  $('#search-bar-input-display').on('keyup', function(event){
    $.ajax({
      dataType: 'json',
      method: 'GET',
      url: window.location.pathname + '/autocomplete.json?search_term=' + event.target.value,
      success: function (response) {
        console.log(response)
        dataProvider(response.outcomes);
      },
      error: function (response) {
        console.log('Autocomplete malfunctioned.', response)
      }
    });
  });

  // //setup before functions
  // var typingTimer;                //timer identifier
  // var doneTypingInterval = 2500;  //time in ms, 5 second for example
  // var $input = $('#search-bar-input-display');

  // //on keyup, start the countdown
  // $input.on('keyup', function (event) {
  //   clearTimeout(typingTimer);
  //   typingTimer = setTimeout(doneTyping(event.target.value), doneTypingInterval);
  // });

  // //on keydown, clear the countdown 
  // $input.on('keydown', function () {
  //   clearTimeout(typingTimer);
  // });

  // //user is "finished typing," do something
  // function doneTyping (value) {
  //   $.ajax({
  //     dataType: 'json',
  //     method: 'GET',
  //     url: window.location.pathname + '/autocomplete.json?search_term=' + value,
  //     success: function (response) {
  //       // console.log(response)
  //       dataProvider(response.outcomes);
  //     },
  //     error: function (response) {
  //       console.log('Autocomplete malfunctioned.', response)
  //     }
  //   });
  // }

});