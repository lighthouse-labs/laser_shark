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
      var location = item.location;

      // Create the event holder
      var holderDiv = getEventHolder();

      var activityDiv = document.createElement('div')
      activityDiv.className = "activity";
      
      // Add the icon to the holder
      activityDiv.appendChild(getEventIcon());

      // Add the location 
      activityDiv.appendChild(getEventLocation(item));

      if (item.start.dateTime) {
        activityDiv.appendChild(getStartTime(item));
      }

      // Append all the information before the description
      holderDiv.appendChild(activityDiv);

      if (item.description) {
        getDescription(holderDiv, activityDiv, item);
      }

      // Add the event to the event div
      $($div).append(holderDiv);
    }

    var feedUrl = 'https://www.googleapis.com/calendar/v3/calendars/' +
      encodeURIComponent(defaults.calendarId.trim()) +'/events?key=' + defaults.apiKey +
      '&orderBy=startTime&singleEvents=true' + '&timeMin=' + defaults.startDate + '&timeMax=' + defaults.endDate;

    var eventsHeader = $div.prev();
    eventsHeader.hide();
    eventsHeader.prev().hide();

    function getEventHolder() {
      var holderDiv = document.createElement('div')
      holderDiv.className = "calendar"

      return holderDiv;
    }

    function getEventIcon() {
      var iconDiv = document.createElement('div');
      iconDiv.className = "icon icon-type";

      var iEle = document.createElement('i');
      iEle.className = "fa fa-calendar";

      iconDiv.appendChild(iEle);
      return iconDiv;
    }

    function getEventLocation(eventData) {
      var locationDiv = document.createElement('div');
      var textNode = document.createTextNode(eventData.summary);
      locationDiv.appendChild(textNode);

      if (eventData.location) {
        locationDiv.className = "calendar-event-name-with-location";

        var innerLocationDiv = document.createElement('div');
        innerLocationDiv.className = "calendar-event-location";
        innerLocationDiv.innerHTML = eventData.location;

        locationDiv.appendChild(innerLocationDiv);
      }
      else
        locationDiv.className = "calendar-event-name";

      return locationDiv;
    }

    function getStartTime(eventData) {
      var startTime = eventData.start.dateTime.substring(11,16);
      var endTime = eventData.end.dateTime.substring(11,16);

      var timeDiv = document.createElement('div');
      timeDiv.className = "time"
      timeDiv.innerHTML = startTime + '<br> to ' + endTime + '<br>';

      return timeDiv;
    }

    function getDescription(eventHolder, activityDiv, eventData) {
      var showDescriptionDiv = document.createElement('div');
      showDescriptionDiv.className = "icon icon-calendar-description-button";

      var iEle = document.createElement('i');
      iEle.className = "fa fa-chevron-down";

      showDescriptionDiv.appendChild(iEle);
      activityDiv.appendChild(showDescriptionDiv);

      var descriptionHolder = document.createElement('div');
      descriptionHolder.className = "description-container";

      var descriptionContentDiv = document.createElement('div');
      descriptionContentDiv.className = "description-details";
      descriptionContentDiv.innerHTML = eventData.description;

      $(showDescriptionDiv).click(function() {
        $(descriptionHolder).toggle();
        $(activityDiv).toggleClass('description-open');
      })

      descriptionHolder.appendChild(descriptionContentDiv);
      eventHolder.appendChild(descriptionHolder);
    }

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