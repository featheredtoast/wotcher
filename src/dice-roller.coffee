# Description
#   Dice roller
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   roll xdy - rolls y sided dice x times
#   roll xdy+z - rolls y sided dice x times and add z
#
# Notes:
#
# Author:
#   Jeff Wong <awole20@gmail.com>

module.exports = (robot) ->
  d6s = [
    '\u2680',
    '\u2681',
    '\u2682',
    '\u2683',
    '\u2684',
    '\u2685'
    ]
  robot.respond /roll (\d*)d(\d*)(\W*(\+|-)\W*(\d))?/, (res) ->
    dieType = parseInt(res.match[2])
    dieNum = parseInt(res.match[1])
    modifier = res.match[4]
    modifierVal = parseInt(res.match[5])
    roll = null
    if !dieNum
      dieNum = 1;
    if !dieType or dieType <=0 or dieNum <=0
      res.send 'How to roll: "roll <# of dice to roll>d<# of sides on die>")\nEx: roll 1d6\n    roll 3d20\n    roll d100'
    else if (!dieNum or dieNum == 1) and modifierVal == null
      roll = Math.floor(Math.random() * dieType) + 1
      if dieType == 20 && roll == 20
        res.reply 'Rolled a 20 (CRIT!)'
      else
        res.reply 'Rolled ' + displayRoll(roll, dieType)
    else
      response = 'rolled '
      total = 0
      for i in [0..dieNum]
        roll = Math.floor(Math.random() * dieType) + 1
        if i==1
          response += displayRoll(roll, dieType)
          total += roll
        else
          response += ' + ' + displayRoll(roll, dieType)
          total += roll
      if modifier != null and modifierVal != null
        if modifier == '-'
          total -= modifierVal
        else
          total += modifierVal
        response += ' ' + modifier + ' ' + modifierVal
      response += ' = ' + total
      res.reply response

  displayRoll = (roll, dieType) ->
    if dieType == 6 then d6s[roll - 1] + ' (' + roll + ')' else roll
