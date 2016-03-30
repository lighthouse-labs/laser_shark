$ ->
  $('.outcome-skills-form').on 'click', '.remove_fields', (event) ->
    event.preventDefault()

    $(this).parent().prev().find('input[type=hidden]').val('true')
    $(this).closest('.row').hide()

  $('.add_fields').on 'click', (event) ->
    event.preventDefault()
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')

    $elements = $($(this).data('fields').replace(regexp, time))
    $autoCompleteElements = $elements.find('.autocomplete')
    
    if $autoCompleteElements.length > 0
      new AutoComplete(
        selector: $autoCompleteElements
        url: '/activities'
        render: (ul, item) ->
          if (item.day)
            markup = [
              '<span class="activity-display activity-display-name">' + item.name + '</span>',
              '<span class="activity-display activity-display-type">' + item.type + '</span>',
              '<span class="activity-display activity-display-day">' + item.day + '</span>'
            ];
          else
            markup = ['<span class="activity-display activity-display-name">' + item.text + '</span>']

          $('<li>').append(markup.join('')).appendTo(ul)
      )

    $(this).before($elements)

