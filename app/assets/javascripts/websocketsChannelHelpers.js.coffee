$ ->
  format_channel_name = (channel, id='')
    [ APP_NAME, channel, id.toString() ].join('-')