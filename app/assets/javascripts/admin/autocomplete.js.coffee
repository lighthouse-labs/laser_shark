class window.AutoComplete

  constructor: (args) ->
    @input = $(args.selector)
    @url = args.url
    @render = args.render

    @initAutoComplete()

  initAutoComplete: ->
    @input.autocomplete(
      source: @url
    )

    @input.autocomplete('instance')._renderItem = @render

  select: (e, ui) ->

  response: (e, ui) ->
  







