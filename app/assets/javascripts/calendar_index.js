(function($) {

  $.fn.gCalReader = function(options) {
    var $div = $(this);

    var defaults = $.extend({
        calendarId: 'en.canadian#holiday@group.v.calendar.google.com',
        apiKey: 'AIzaSyA0e9Ts3CSV9CQ-dOV-Pxwc2d5EszJBFLI',
        startDate: new Date().toISOString(),
        endDate: new Date().toISOString(),
        errorMsg: 'No events in calendar',
        tags: ['#web'],
        sortDescending: true
      },
      options);

    var intersect = function(a, b) {
      var t;
      if (b.length > a.length) t = b, b = a, a = t; // indexOf to loop over shorter
      return a.filter(function (e) {
          if (b.indexOf(e) !== -1) return true;
      });
    }

    var appendDetails = function(item) {
      var link = item.htmlLink;
      var location = item.location || '';
      var details = '<div class="icon icon-type"><i class="fa fa-calendar"></i></div>'
      details += '<a href=' + link + '><div class="name">' + item.summary + '<div class="location">' + location + '</div>' + '</div></a>';
      if (item.start.dateTime) {
        var startTime = item.start.dateTime.substring(11,16);
        var endTime = item.end.dateTime.substring(11,16);
        details += '<div class="time">' + startTime + '<br> to ' + endTime + '<br>' + '</div>';
      }
      calendarEvent = '<div class="calendar activity">' + details + '</div>';
      $($div).append(calendarEvent);
    }

    var feedUrl = 'https://www.googleapis.com/calendar/v3/calendars/' +
      encodeURIComponent(defaults.calendarId.trim()) +'/events?key=' + defaults.apiKey +
      '&orderBy=startTime&singleEvents=true' + '&timeMin=' + defaults.startDate + '&timeMax=' + defaults.endDate;

    var eventsHeader = $div.prev();
    eventsHeader.hide();
    eventsHeader.prev().hide();

    var getDetails = function(item) {
      var summary = item.summary || '';
      var itemTags = summary.match(/#\w+/g);
      if(itemTags) {
        var intersection = intersect(defaults.tags, itemTags)
        // Only append the calendar event if it has 1 or more tags that the Program has
        if(intersection.length > 0) {
          eventsHeader.show();
          eventsHeader.prev().show();
          appendDetails(item);
        }
      }
      // If it doesn't have hashtags, assume it is event for all
      else {
        eventsHeader.show();
        eventsHeader.prev().show();
        appendDetails(item);
      }
    }
      
    $.ajax({
      url: feedUrl,
      dataType: 'json',
      success: function(data) {
        if(defaults.sortDescending){
          data.items = data.items.reverse();
        }
        // If there are events that day, show events section
        if (data.items.length > 0) {
          $.each(data.items, function(e, item){
            getDetails(item);
          });
        }
      },
      error: function(xhr, status) {
        $($div).append('<p>' + status +' : '+ defaults.errorMsg +'</p>');
      }
    });

  };

}(jQuery));