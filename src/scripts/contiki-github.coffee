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
  githubrepo = "contikiholidays/contiki"
  githuburl = "https://api.github.com/repos/#{githubrepo}/commits?sha="

  robot.respond /(current release)|(cr)$/i, (msg) ->
    msg.send "Getting Release branches data..."
    master_url = "#{githuburl}master"
    github.get master_url, (master_commits) ->

      github.branches githubrepo, (branches) ->
        release_branches = (branch.name for branch in branches).filter (x) -> x.toLowerCase().indexOf("release-") isnt -1
        msg.send "No release branches found." unless release_branches.length
        msg.send "1 release branch found." if release_branches.length == 1
        msg.send "#{release_branches.length} release branches found." if release_branches.length > 1

        for release_branch in release_branches
          do (release_branch) ->
            github.get "#{githuburl}#{release_branch}", (commits) ->

              messagestr = "Branch: #{release_branch} \n"
              for c in commits
                if c.commit.message.toLowerCase().indexOf("cw-") isnt -1
                  unless c.sha in master_commits
                    messagestr += "--> #{c.commit.message} \n"
              msg.send messagestr