$ ->
  new AutoComplete(
    input: '.activity-outcomes-autocomplete-field'
    source: '/activities'
    render: (ul, item) ->
      markup = [
        '<span>',
        item.name
        '</span>'
      ]

      $('<li>').append(markup.join('')).appendTo(ul)
  )

