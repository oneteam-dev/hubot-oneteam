{PusherClient} = require 'pusher-node-client'

DEFAULT_PUSHER_CLIENT_KEY = 'd62fcfd64facee71a178':
DEFAULT_API_BASE_URL = 'https://api.one-team.io'

class OneteamAdapter extends Adapter
  constructor: (robot) ->
    super @robot
    @pusherClient = new PusherClient
      key: process.env.HUBOT_ONETEAM_PUSHER_CLIENT_KEY || DEFAULT_PUSHER_CLIENT_KEY
      authEndpoint: process.env.HUBOT_ONETEAM_PUSHER_AUTH_ENDPOINT || "#{DEFAULT_API_BASE_URL}/pusher/auth"

  send: (envelope, strings...) ->

  reply: (envelope, strings...) ->

  topic: (envelope, strings...) ->

  run: ->
    @pusherClient.on 'connect', =>
      @emit 'connected'

  close: ->

