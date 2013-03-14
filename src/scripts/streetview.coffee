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
  robot.respond /(sv me ) (.*)/i, (msg) ->
    streetviewOf msg, msg.match[2] (url) ->
      msg.send url

streetviewOf = (msg, query, cb) ->    
    msg.http("http://maps.googleapis.com/maps/api/streetview?size=640x640&location=#{query}&heading=0&sensor=false")
      .get() (err, res, body) ->
        cb body
        
    msg.http("http://maps.googleapis.com/maps/api/streetview?size=640x640&location=#{query}&heading=120&sensor=false")
      .get() (err, res, body) ->
        cb body

    msg.http("http://maps.googleapis.com/maps/api/streetview?size=640x640&location=#{query}&heading=240&sensor=false")
      .get() (err, res, body) ->
          cb body