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
#   hubot repo show <repo> - shows activity of repository
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
    master_url = "https://api.github.com/repos/contikiholidays/contiki/commits?sha=master&per_page=1"
    github.get master_url, (last_commits) ->
      if last_commits.message
        msg.send "Achievement unlocked: [NEEDLE IN A HAYSTACK] repository #{last_commits.message}!"
      else if last_commits.length == 0
        msg.send "Achievement unlocked: [LIKE A BOSS] no commits found!"
      else
        for last_commit in last_commits
#          d = new Date(Date.parse(last_commit.commit.committer.date)).toFormat("DD/MM HH24:MI")
#          msg.send "[#{last_commit.commit.committer.name}] #{last_commit.commit.message}"
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
                    if last_commit.sha is c.sha
                      break
                    d = new Date(Date.parse(c.commit.committer.date)).toFormat("DD/MM HH24:MI")
                    msg.send "[#{d} -> #{c.commit.committer.name}] #{c.commit.message}"

#    msg.send "Getting Release branches..."
#    github.branches "contikiholidays/contiki", (branches) ->
#      for release_branch in branches when release_branch.name.indexOf("release-") isnt -1
#        msg.send release_branch.name
#        url = "https://api.github.com/repos/contikiholidays/contiki/commits?sha=#{release_branch.name}"
##        github.commits url, (commits) ->
#        github.get url, (commits) ->
#          if commits.message
#            msg.send "Achievement unlocked: [NEEDLE IN A HAYSTACK] repository #{commits.message}!"
#          else if commits.length == 0
#            msg.send "Achievement unlocked: [LIKE A BOSS] no commits found!"
#          else
#            send = 5
#            for c in commits when c.commit.message.indexOf("erge") is -1
#              if send
#                d = new Date(Date.parse(c.commit.committer.date)).toFormat("DD/MM HH24:MI")
#                msg.send "[#{d} -> #{c.commit.committer.name}] #{c.commit.message}"
#                send -= 1