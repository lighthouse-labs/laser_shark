(function($) {

  $.fn.gCalReader = function(options) {
    var $div = $(this);

    var defaults = $.extend({
        calendarId: 'en.canadian#holiday@group.v.calendar.google.com',
        apiKey: 'AIzaSyA0e9Ts3CSV9CQ-dOV-Pxwc2d5EszJBFLI',
        startDate: new Date().toISOString(),
        endDate: new Date().toISOString(),
        errorMsg: 'No events in calendar',
        sortDescending: true
      },
      options);

    var feedUrl = 'https://www.googleapis.com/calendar/v3/calendars/' +
      encodeURIComponent(defaults.calendarId.trim()) +'/events?key=' + defaults.apiKey +
      '&orderBy=startTime&singleEvents=true' + '&timeMin=' + defaults.startDate + '&timeMax=' + defaults.endDate;

    var eventsHeader = $div.prev();
    eventsHeader.hide();
    eventsHeader.prev().hide();
      
    $.ajax({
      url: feedUrl,
      dataType: 'json',
      success: function(data) {
        if(defaults.sortDescending){
          data.items = data.items.reverse();
        }
        // If no events on that day, don't show events section
        if (data.items.length != 0) {
          eventsHeader.show();
          eventsHeader.prev().show();
          $.each(data.items, function(e, item) {
            var summary = item.summary || '';
            var link = item.htmlLink;
            var location = item.location || '';
            var details = '<div class="icon icon-type"><i class="fa fa-calendar"></i></div>'
            details += '<a href=' + link + '><div class="name">' + summary + '<div class="location">' + location + '</div>' + '</div></a>';
            if (item.start.dateTime) {
              var startTime = item.start.dateTime.substring(11,16);
              var endTime = item.end.dateTime.substring(11,16);
              details += '<div class="time">' + startTime + '<br> to ' + endTime + '<br>' + '</div>';
            }
            calendarEvent = '<div class="calendar activity">' + details + '</div>';
            $($div).append(calendarEvent);
          });
        }
      },
      error: function(xhr, status) {
        $($div).append('<p>' + status +' : '+ defaults.errorMsg +'</p>');
      }
    });

  };

}(jQuery));