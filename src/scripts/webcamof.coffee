# Description:
#   Show me various webcams
#
# Dependencies:
#   None
#
# Configuration:
#   WEBCAMS_API_TOKEN
#
# Commands:
#   hubot webcam of (query) - Returns the results of a query to http://api.webcams.travel/
#
# Author:
#   richarcher


module.exports = (robot) ->
  robot.respond /(webcam)( of)? (.*)/i, (msg) ->
    webcamOf msg, msg.match[3], (url) ->
      msg.send url

webcamOf = (msg, query, cb) ->
  auth_token = process.env.WEBCAMS_API_TOKEN
  if typeof auth_token == 'undefined'
    cb "Error: WEBCAMS_API_TOKEN is undefined"
  else
    url = "http://api.webcams.travel/rest?method=wct.search.webcams&devid=#{auth_token}&format=json&query=#{query}"
    msg.http(url)
      .get() (err, res, body) ->
        response = JSON.parse(body)
        previews = (webcam.preview_url for webcam in response.webcams.webcam)
        if previews.length > 0
          image = msg.random previews
          cb image
        else
          cb "Stop bugging me with searches for \"#{query}\"."
