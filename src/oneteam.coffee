Client = require 'oneteam-client'
{AllHtmlEntities} = require 'html-entities'
{Robot, Adapter, User, EnterMessage, LeaveMessage, TopicMessage, TextMessage} = require 'hubot'

encodeHTML = (strings) ->
  return html if html = strings?[0]?.html
  html = strings.join '\n'
  new AllHtmlEntities().encode(html).replace /&lt;(\/)?web-card([^(?:&gt;)]+)&gt;/g, '<$1web-card$2>'

class OneteamAdapter extends Adapter
  constructor: (robot, @teamName, clientOptions) ->
    super robot
    @client = new Client clientOptions
    @robot.createTopic = (topic, callback) =>
      @team.createTopic topic, callback

  send: (envelope, strings...) ->
    text = encodeHTML strings
    room.createMessage text, (err, res, m) =>
      @robot.logger.info "Message created: #{m.key}"

  reply: (envelope, strings...) ->
    {user, room} = envelope
    text = "@#{user_name} #{encodeHTML strings}" if user_name = user?.user_name
    room.createMessage text, (err, res, m) =>
      @robot.logger.info "Message created: #{m.key}"

  topic: (envelope, strings...) ->
    {user, room} = envelope
    body = strings.join '\n'
    room.update {body}, (err, t) =>
      if err
        console.error err
        return
      @robot.logger.info "Topic updated: #{t.key}"

  run: ->
    @client.team @teamName, (err, t) =>
      @team = t
      @robot.team = t
      t.on 'message:created', (m) =>
        {createdBy} = m
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
