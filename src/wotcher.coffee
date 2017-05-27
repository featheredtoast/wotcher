# Description
#   Wotcher has the deals
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   the deals - respond with the deals
#
# Notes:
#   Wotcher has all the deals
#
# Author:
#   Jeff Wong <awole20@gmail.com>

module.exports = (robot) ->

  robot.hear /the deals/i, (res) ->
    res.send "Wotcher got the deals!"
