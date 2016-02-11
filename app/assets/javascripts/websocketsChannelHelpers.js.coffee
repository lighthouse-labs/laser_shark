
formatChannelName = (channel, id='') ->
  [ APP_NAME, channel, id.toString() ].join('-')