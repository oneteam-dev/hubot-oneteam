Client = require 'oneteam-client'
{Robot, Adapter, User, EnterMessage, LeaveMessage, TopicMessage, TextMessage} = require 'hubot'

class OneteamAdapter extends Adapter
  constructor: (robot, @teamName, clientOptions) ->
    super robot
    @client = new Client clientOptions

  send: (envelope, strings...) ->
    {room} = envelope
    room.createMessage strings.join('\n'), (err, res, m) =>
      @robot.logger.info "Message created: #{m.key}"

  reply: (envelope, strings...) ->
    {user, room} = envelope
    text = strings.join '\n'
    text = "@#{user_name} #{text}" if user_name = user?.user_name
    room.createMessage text, (err, res, m) =>
      @robot.logger.info "Message created: #{m.key}"

  topic: (envelope, strings...) ->

  run: ->
    @client.team @teamName, (err, t) =>
      @team = t
      t.on 'message:created', (m) =>
        {createdBy} = m
        console.info m, createdBy
        user = new User createdBy.user_name, createdBy
        message = new TextMessage user, m.body, m.key
        message.rawMessage = m
        message.topic = m.topic
        message.room = m.topic
        @receive message
      t.subscribe =>
        @emit 'connected'

  close: ->

module.exports = OneteamAdapter
