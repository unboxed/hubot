# Description:
#   Show me Google street view locations
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot sv me (address) - Returns the results of a query to http://maps.googleapis.com/maps/api
#
# Author:
#   pawel2105

module.exports = (robot) ->
  robot.respond /(sv me )(.*)/i, (msg) ->
    views = [0,120,240]
    for i in [0...views.length]
      streetviewOf msg, msg.match[2], views[i], (url) ->
        msg.send url

streetviewOf = (msg, query, num, cb) ->
  cb "http://maps.googleapis.com/maps/api/streetview?size=640x640&location=#{query}&heading=#{num}&sensor=false"