$(function() {

  if (!$('body').hasClass('teacher-stats')) return;

  var mapData = function(data) {
    return(data.map( function(row) {
      return [ new Date(row[0]).getTime(), row[1] ];
    }));
  }

  // Feedback Charts
  var mentorFeedbackContainer  = $('#mentor-feedback-chart');
  var lectureFeedbackContainer = $('#lecture-feedback-chart');
  
  $.getJSON($('#feedback-charts').data('url'), function (data) {

    $('#overall-mentor-feedback').text(data.mentor.average + ' (' + data.mentor.total + ' total)');
    $('#overall-lecture-feedback').text(data.lecture.average + ' (' + data.lecture.total + ' total)');
    $('#overall-direct-feedback').text(data.direct.average + ' (' + data.direct.total + ' total)');

    mentorFeedbackContainer.highcharts({
      chart: {
        zoomType: 'x',
        type: 'spline'
      },
      title: {
        text: 'Mentor Feedback (Daily)'
      },
      subtitle: {
        text: document.ontouchstart === undefined ? 'Click and drag in the plot area to zoom in' : 'Pinch the chart to zoom in'
      },
      xAxis: {
        type: 'datetime',
        dateTimeLabelFormats: { // don't display the dummy year
          day: '%e. %b',
          week: '%e. %b',
          month: '%b \'%y',
          year: '%Y'
        },
        title: {
          text: 'Date'
        }
      },
      yAxis: {
        title: {
          text: 'Average Feedback Score'
        }
      },
      legend: {
        enabled: false
      },
      plotOptions: {
        area: {
          fillColor: {
            linearGradient: {
                x1: 0,
                y1: 0,
                x2: 0,
                y2: 1
            },
            stops: [
              [0, Highcharts.getOptions().colors[0]],
              [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
            ]
          },
          marker: {
            radius: 2
          },
          lineWidth: 1,
          states: {
            hover: {
              lineWidth: 3
            }
          },
          threshold: null
        }
      },

      series: [
        {
          name: 'Teacher Mentor Feedback',
          data: mapData(data.mentor.teacher),
          color: 'green'
        },
        {
          name: 'Overall Mentor Feedback',
          data: mapData(data.mentor.everyone),
          dashStyle: 'LongDash',
          lineWidth: 1,
          color: 'gray'
        }
      ],
    });

    lectureFeedbackContainer.highcharts({
      chart: {
        zoomType: 'x',
        type: 'spline'
      },
      title: {
        text: 'Lecture Feedback (Daily)'
      },
      subtitle: {
        text: document.ontouchstart === undefined ? 'Click and drag in the plot area to zoom in' : 'Pinch the chart to zoom in'
      },
      xAxis: {
        type: 'datetime',
        dateTimeLabelFormats: { // don't display the dummy year
          day: '%e. %b',
          week: '%e. %b',
          month: '%b \'%y',
          year: '%Y'
        },
        title: {
          text: 'Date'
        }
      },
      yAxis: {
        title: {
          text: 'Average Feedback Score'
        }
      },
      legend: {
        enabled: false
      },
      plotOptions: {
        area: {
          fillColor: {
            linearGradient: {
                x1: 0,
                y1: 0,
                x2: 0,
                y2: 1
            },
            stops: [
              [0, Highcharts.getOptions().colors[0]],
              [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
            ]
          },
          marker: {
            radius: 2
          },
          lineWidth: 1,
          states: {
            hover: {
              lineWidth: 3
            }
          },
          threshold: null
        }
      },

      series: [
        {
          name: 'Teacher Lecture Feedback',
          data: mapData(data.lecture.teacher),
          color: 'red'
        },
        {
          name: 'Overall Lecture Feedback',
          data: mapData(data.lecture.everyone),
          dashStyle: 'LongDash',
          lineWidth: 1,
          color: 'gray'
        }
      ],
    });

  });

      
  // Assistances Chart
  var assistanceContainer = $('#assistances-chart');
  $.getJSON(assistanceContainer.data('url'), function (data) {

    $('#total-assistance-count').text(data.overall_stats.total_count);
    $('#average-l-score').text(data.overall_stats.average_l_score);

    assistanceContainer.highcharts({
      chart: {
        zoomType: 'x',
        type: 'areaspline'
      },
      title: {
        text: '# Assistances (By Week)'
      },
      subtitle: {
        text: document.ontouchstart === undefined ? 'Click and drag in the plot area to zoom in' : 'Pinch the chart to zoom in'
      },
      xAxis: {
        type: 'datetime',
        dateTimeLabelFormats: { // don't display the dummy year
          day: '%e. %b',
          week: '%e. %b',
          month: '%b \'%y',
          year: '%Y'
        },
        title: {
          text: 'Date'
        }
      },
      yAxis: {
        title: {
          text: 'Number of Assistances'
        }
      },
      legend: {
        enabled: false
      },
      plotOptions: {
        area: {
          fillColor: {
            linearGradient: {
                x1: 0,
                y1: 0,
                x2: 0,
                y2: 1
            },
            stops: [
              [0, Highcharts.getOptions().colors[0]],
              [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
            ]
          },
          marker: {
            radius: 2
          },
          lineWidth: 1,
          states: {
            hover: {
                lineWidth: 1
            }
          },
          threshold: null
        }
      },

      series: [
        {
          name: 'Assistances',
          data: mapData(data.daily_stats)
        }
      ]
    });
  });
});