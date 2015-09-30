(function($) {

  $.fn.gCalReader = function(options) {
    var $div = $(this);

    var defaults = $.extend({
        calendarId: 'en.usa#holiday@group.v.calendar.google.com',
        apiKey: 'Public_API_Key',
        dateFormat: 'LongDate',
        errorMsg: 'No events in calendar',
        maxEvents: 50,
        futureEventsOnly: true,
        sortDescending: true
      },
      options);

    var feedUrl = 'https://www.googleapis.com/calendar/v3/calendars/' +
      encodeURIComponent(defaults.calendarId.trim()) +'/events?key=' + defaults.apiKey +
      '&orderBy=startTime&singleEvents=true';
      if(defaults.futureEventsOnly) {
        feedUrl+='&timeMin='+ new Date().toISOString();
      }

    $.ajax({
      url: feedUrl,
      dataType: 'json',
      success: function(data) {
        if(defaults.sortDescending){
          data.items = data.items.reverse();
        }
        data.items = data.items.slice(0, defaults.maxEvents);

        $.each(data.items, function(e, item) {
          var startTime = item.start.dateTime.substring(11,16);
          var endTime = item.end.dateTime.substring(11,16);
          var summary = item.summary || '';
          var link = item.htmlLink;
          var location = item.location || '';
          var details = '<div class="icon icon-type"><i class="fa fa-calendar"></i></div>'
          details += '<a href=' + link + '><div class="name">' + summary + '<div class="location">' + location + '</div>' + '</div></a>';
          details += '<div class="time">' + startTime + '<br> to ' + endTime + '<br>' + '</div>';
          s = '<div class="calendar activity">' + details + '</div>';
          $($div).append(s);
        });
      },
      error: function(xhr, status) {
        $($div).append('<p>' + status +' : '+ defaults.errorMsg +'</p>');
      }
    });

  };

}(jQuery));