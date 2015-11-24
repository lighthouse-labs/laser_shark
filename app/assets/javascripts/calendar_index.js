(function($) {

  $.fn.gCalReader = function(options) {
    var $div = $(this);

    var defaults = $.extend({
        calendarId: 'en.canadian#holiday@group.v.calendar.google.com',
        apiKey: '',
        startDate: new Date().toISOString(),
        endDate: new Date().toISOString(),
        tag: ['#web']
      },
      options);

    var appendDetails = function(item) {
      var link = item.htmlLink;
      var location = item.location || '';
      var details = '<div class="icon icon-type"><i class="fa fa-calendar"></i></div>'
      if (item.description) {
        details += '<div class="event-block-with-description">' + '<div class="event-name">' + item.summary + '</div>' + 
        '<div class="event-location">' + location + '</div>' +
        '<a class="toggable-description-link"><small>View Description</small></a>' +
        '<div class="toggable-description" style="display: none;">' + item.description + '</div>'
        + '</div>';
      }
      else {
        details += '<div class="event-block-no-description">' + '<div class="event-name">' + item.summary + '</div>' + 
        '<div class="event-location">' + location + '</div>'
        + '</div>';
      }
      if (item.start.dateTime) {
        var startTime = item.start.dateTime.substring(11,16);
        var endTime = item.end.dateTime.substring(11,16);
        details += '<div class="time">' + startTime + '<br> to ' + endTime + '<br>' + '</div>';
      }
      calendarEvent = '<div class="calendar activity">' + details + '</div>';
      $($div).append(calendarEvent);
      $('.toggable-description-link').click(function(){
        $(this).siblings('.toggable-description').toggle();
      }) 

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
      var downcasedItemTags = [];
      if(itemTags) {
        for (var i = 0; i < itemTags.length; i++) {
            downcasedItemTags.push(itemTags[i].toLowerCase());
        }
        var intersection = downcasedItemTags.indexOf(defaults.tag.toLowerCase());
        // Only append the calendar event if the program's tag is part of the events tag
        if(intersection > -1) {
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
        // If there are events that day, show events section
        if (data.items.length > 0) {
          $.each(data.items, function(e, item){
            getDetails(item);
          });
        }
      }
    });

  };

}(jQuery));