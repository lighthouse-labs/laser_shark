$.fn.raty.defaults.path = "/assets"

$ ->

  # Make viewer raty divs
  $('div.raty-viewer').raty
    readOnly: true,
    score: ->
      $(@).data('score')

  # Make editable raty divs
  $('div.raty-editor').raty
    score: ->
      $(@).data('score')
    click: (score, evt) ->
      # TODO: Set a hidden field value
      console.log score