# Description:
#   None
#
# Dependencies:
#   "date-utils": ">=1.2.5"
#   "githubot": "0.2.0"
# 
# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_USER
#   HUBOT_GITHUB_API
#
# Commands:
#   hubot current release - shows activity of release branches
#
# Notes:
#   HUBOT_GITHUB_API allows you to set a custom URL path (for Github enterprise users)
#
# Author:
#   vquaiato

require('date-utils')

module.exports = (robot) ->
  github = require("githubot")(robot)
  robot.respond /(current release)|(cr)$/i, (msg) ->
    msg.send "Getting Release branches data..."
    master_url = "https://api.github.com/repos/contikiholidays/contiki/commits?sha=master"
    github.get master_url, (master_commits) ->
      if master_commits.message
        msg.send "Achievement unlocked: [NEEDLE IN A HAYSTACK] repository #{last_commits.message}!"
      else if master_commits.length == 0
        msg.send "Achievement unlocked: [LIKE A BOSS] no commits found!"
      else
        github.branches "contikiholidays/contiki", (branches) ->
          for release_branch in branches when release_branch.name.indexOf("release-") isnt -1
            msg.send release_branch.name
            url = "https://api.github.com/repos/contikiholidays/contiki/commits?sha=#{release_branch.name}"
            github.get url, (commits) ->
              if commits.message
                msg.send "Achievement unlocked: [NEEDLE IN A HAYSTACK] repository #{commits.message}!"
              else if commits.length == 0
                msg.send "Achievement unlocked: [LIKE A BOSS] no commits found!"
              else
                for c in commits
                  if c.commit.message.indexOf("CW-") isnt -1 or c.commit.message.indexOf("cw-") isnt -1
                    unless c.sha in master_commits
                      msg.send "--> #{c.commit.message}"