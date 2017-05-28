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

os = require 'os'

computeDiceRoll = (dieType, dieNum, modifier, modifierVal, comment) ->
  response = "`#{dieNum}d#{dieType}"
  if !!modifier and !!modifierVal
    response += "#{modifier}#{modifierVal}"
  response += '`'
  if !!comment
    response += " #{comment}"
  response += ' = ('
  total = 0
  for i in [1..dieNum]
    roll = Math.floor(Math.random() * dieType) + 1
    if i==1
      response += roll
      total += roll
    else
      response += ' + ' + roll
      total += roll
  if !!modifier and !!modifierVal
    if modifier == '-'
      total -= modifierVal
    else
      total += modifierVal
    response += ' ' + modifier + ' ' + modifierVal
  response += ') = ' + total

rollDice = (dieType, dieNum, modifier, modifierVal, comment) ->
  roll = null
  if !dieNum
    dieNum = 1;
  if !dieType or dieType <=0 or dieNum <=0
    'How to roll: "roll <# of dice to roll>d<# of sides on die>")\nEx: roll 1d6\n    roll 3d20\n    roll d100'
  else
    computeDiceRoll dieType, dieNum, modifier, modifierVal, comment

module.exports = (robot) ->
  robot.hear /(roll|\/r) (\d*)d(\d*)(\W*(\+|-)\W*(\d))?(\W*#(.*))?/i, (res) ->
    dieType = parseInt(res.match[3])
    dieNum = parseInt(res.match[2])
    modifier = res.match[5]
    modifierVal = parseInt(res.match[6])
    comment = res.match[8]
    response = rollDice(dieType, dieNum, modifier, modifierVal, comment)
    res.reply response

  robot.hear /(roll|\/r) \$(\w*) (\d*)d(\d*)(\W*(\+|-)\W*(\d))?(\W*#(.*))?/i, (res) ->
    rollName = res.match[2]
    rollInfo =
      dieType: parseInt(res.match[4])
      dieNum: parseInt(res.match[3])
      modifier: res.match[6]
      modifierVal: parseInt(res.match[7])
      comment: res.match[9]
    robot.brain.set("roll_#{rollName}", rollInfo)
    res.reply rollDice(rollInfo.dieType, rollInfo.dieNum, rollInfo.modifier, rollInfo.modifierVal, rollInfo.comment) + os.EOL + "Roll saved."

  robot.hear /(roll|\/r) \$(\w*)$/i, (res) ->
    rollName = res.match[2]
    rollInfo = robot.brain.get("roll_#{rollName}")
    if !!rollInfo
      res.reply rollDice(rollInfo.dieType, rollInfo.dieNum, rollInfo.modifier, rollInfo.modifierVal, rollInfo.comment)
    else
      res.reply "no such saved roll: #{rollName}"
