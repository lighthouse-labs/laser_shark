class window.AutoComplete

  constructor: (args) ->
    @input = $(args.selector)
    @args = args
    @initAutoComplete()

  initAutoComplete: ->
    @input.autocomplete(
      source: @args.url,
      select: @args.select
    )

    @input.autocomplete('instance')._renderItem = @args.render