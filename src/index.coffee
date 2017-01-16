OneteamAdapter = require './oneteam'

module.exports.use = (robot) ->
  new OneteamAdapter robot, process.env.TEAM_NAME, if process.env.ACCESS_TOKEN
      accessToken: process.env.ACCESS_TOKEN
    else
      clientKey: process.env.CLIENT_KEY
      clientSecret: process.env.CLIENT_SECRET
