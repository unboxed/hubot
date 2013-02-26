# Description:
#   Allows things that have made you mad, glad, or sad to be added to Hubot for a (mini-)retrospective
#
# Dependencies:
#
# Configuration:
#
# Commands:
#   hubot mad <mad thing> - Add something that made you mad
#   hubot glad <bad thing> - Add something that made you glad
#   hubot sad <sad thing> - Add something that made you sad
#   hubot madlist - List all things that made people mad
#   hubot gladlist - List all things that made people glad
#   hubot sadlist - List all things that made people sad
#   hubot maddel - Delete all things that made people mad
#   hubot gladdel - Delete all things that made people glad
#   hubot madlist - List all things that made people sad
#
# Author:
#   SteveBarnett

class MadGladSad
  constructor: (@robot) ->
    @madcache = []
    @sadcache = []
    @gladcache = []

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.mad
        @madcache = @robot.brain.data.mad
      if @robot.brain.data.sad
        @sadcache = @robot.brain.data.sad
      if @robot.brain.data.glad
        @gladcache = @robot.brain.data.glad

  nextMadNum: ->
    maxMadNum = if @madcache.length then Math.max.apply(Math,@madcache.map (n) -> n.num) else 0
    maxMadNum++
    maxMadNum
  nextSadNum: ->
    maxSadNum = if @sadcache.length then Math.max.apply(Math,@sadcache.map (n) -> n.num) else 0
    maxSadNum++
    maxSadNum
  nextGladNum: ->
    maxGladNum = if @gladcache.length then Math.max.apply(Math,@gladcache.map (n) -> n.num) else 0
    maxGladNum++
    maxGladNum

  madlist: -> @madcache
  sadlist: -> @sadcache
  gladlist: -> @gladcache

  mad: (madString) ->
    madthing = {num: @nextMadNum(), mad: madString}
    @madcache.push madthing
    @robot.brain.data.mad = @madcache
    madthing
  sad: (sadString) ->
    sadthing = {num: @nextSadNum(), sad: sadString}
    @sadcache.push sadthing
    @robot.brain.data.sad = @sadcache
    sadthing
  glad: (gladString) ->
    gladthing = {num: @nextGladNum(), glad: gladString}
    @gladcache.push gladthing
    @robot.brain.data.glad = @gladcache
    gladthing

  maddel: ->
    @madcache = []
    @robot.brain.data.mad = @madcache
  saddel: ->
    @sadcache = []
    @robot.brain.data.sad = @sadcache
  gladdel: ->
    @gladcache = []
    @robot.brain.data.glad = @gladcache

module.exports = (robot) ->
  madgladsad = new MadGladSad robot

  robot.respond /(mad) (.+?)$/i, (msg) ->
    message = "#{msg.message.user.name}: #{msg.match[2]}"
    mad = madgladsad.mad message
    msg.send "Logged your mad. >:("

  robot.respond /(sad) (.+?)$/i, (msg) ->
    message = "#{msg.message.user.name}: #{msg.match[2]}"
    sad = madgladsad.sad message
    msg.send "Logged your sad. :("

  robot.respond /(glad) (.+?)$/i, (msg) ->
    message = "#{msg.message.user.name}: #{msg.match[2]}"
    glad = madgladsad.glad message
    msg.send "Logged your glad. :D"

  robot.respond /(madlist)/i, (msg) ->
    if madgladsad.madlist().length > 0
      response = ""
      for mad, num in madgladsad.madlist()
        response += "##{mad.num} - #{mad.mad}\n"
      msg.send response
    else
      msg.send "Nothing made anyone mad yet."

  robot.respond /(gladlist)/i, (msg) ->
    if madgladsad.gladlist().length > 0
      response = ""
      for glad, num in madgladsad.gladlist()
        response += "##{glad.num} - #{glad.glad}\n"
      msg.send response
    else
      msg.send "Nothing mad anyone glad yet."

  robot.respond /(sadlist)/i, (msg) ->
    if madgladsad.sadlist().length > 0
      response = ""
      for sad, num in madgladsad.sadlist()
        response += "##{sad.num} - #{sad.sad}\n"
      msg.send response
    else
      msg.send "Nothing made anyone sad yet."

  robot.respond /(maddel)/i, (msg) ->
    madgladsad.maddel()
    msg.send "Mad-making things deleted."

  robot.respond /(gladdel)/i, (msg) ->
    madgladsad.gladdel()
    msg.send "Glad-making things deleted."

  robot.respond /(saddel)/i, (msg) ->
    madgladsad.saddel()
    msg.send "Sad-making things deleted."