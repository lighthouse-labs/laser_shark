class window.AutoComplete

  constructor: (args) ->
    @input = $(args.selector)
    @args = args
    @initAutoComplete()

  render: (ul, item) =>
    markup = @args.render(item)
    $('<li>').append(markup).appendTo(ul)

  initAutoComplete: ->
    @input.autocomplete(
      source: @args.url,
      select: @args.select
    )

    @input.autocomplete('instance')._renderItem = @render