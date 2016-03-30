window.setupActivityAutoComplete = (input) -> 
  new AutoComplete(
    selector: input
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
    select: (e, ui) ->
      $(@).val(ui.item.name)
      $(@).next('.hidden-activity-field').val(ui.item.id)
      false
  )

$ ->
  window.setupActivityAutoComplete('.activity-outcomes-autocomplete-field')