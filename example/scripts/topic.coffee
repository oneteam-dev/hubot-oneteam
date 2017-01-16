module.exports = (robot) ->

  robot.hear /badger/i, (res) ->
    res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"

  robot.respond /create\s+topic\s+(.*)/im, (res) ->
    body = res.message.text.replace(new RegExp("^#{robot.name}\\s+create\\s+topic\\s+", 'im'), '')
    title = body.split('\n')[0]
    robot.createTopic {title, body}, (err, req, topic) ->
      url = "https://#{topic.team.team_name}.#{process.env.ONETEAM_BASE_URL || 'one-team.io'}/topics/#{topic.number}"
      res.reply "Created topic #{url}\n<web-card url=\"#{url}\"></web-card>"

  robot.respond /update\s+topic\s+(.*)/im, (res) ->
    body = res.message.text.replace(new RegExp("^#{robot.name}\\s+update\\s+topic\\s+", 'im'), '')
    res.topic body
