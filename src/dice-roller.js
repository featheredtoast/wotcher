// Description
//   Dice roller
//
// Configuration:
//   LIST_OF_ENV_VARS_TO_SET
//
// Commands:
//   roll xdy - rolls y sided dice x times
//   roll xdy+z - rolls y sided dice x times and add z
//
// Notes:
//
// Author:
//   Jeff Wong <awole20@gmail.com>

const computeDiceRoll = function(
  dieType,
  dieNum,
  modifier,
  modifierVal,
  comment
) {
  let response = `\`${dieNum}d${dieType}`;
  if (!!modifier && !!modifierVal) {
    response += `${modifier}${modifierVal}`;
  }
  response += "`";
  if (!!comment) {
    response += ` ${comment}`;
  }
  response += " = (";
  let total = 0;
  for (let i = 0; i < dieNum; i++) {
    const roll = Math.floor(Math.random() * dieType) + 1;
    if (i === 0) {
      response += roll;
      total += roll;
    } else {
      response += " + " + roll;
      total += roll;
    }
  }
  if (!!modifier && !!modifierVal) {
    if (modifier === "-") {
      total -= modifierVal;
    } else {
      total += modifierVal;
    }
    response += " " + modifier + " " + modifierVal;
  }
  return (response += ") = " + total);
};

const rollDice = function(dieType, dieNum, modifier, modifierVal, comment) {
  const roll = null;
  if (!dieNum) {
    dieNum = 1;
  }
  if (!dieType || dieType <= 0 || dieNum <= 0) {
    return 'How to roll: "roll <# of dice to roll>d<# of sides on die>")\nEx: roll 1d6\n    roll 3d20\n    roll d100';
  } else {
    return computeDiceRoll(dieType, dieNum, modifier, modifierVal, comment);
  }
};

module.exports = function(robot) {
  robot.hear(/(roll|\/r) (\d*)d(\d*)(\W*(\+|-)\W*(\d))?(\W*#(.*))?/i, function(
    res
  ) {
    const dieType = parseInt(res.match[3]);
    const dieNum = parseInt(res.match[2]);
    const modifier = res.match[5];
    const modifierVal = parseInt(res.match[6]);
    const comment = res.match[8];
    const response = rollDice(dieType, dieNum, modifier, modifierVal, comment);
    return res.reply(response);
  });

  robot.hear(
    /(roll|\/r) \$(\w*) (\d*)d(\d*)(\W*(\+|-)\W*(\d))?(\W*#(.*))?/i,
    function(res) {
      const rollName = res.match[2];
      const rollInfo = {
        dieType: parseInt(res.match[4]),
        dieNum: parseInt(res.match[3]),
        modifier: res.match[6],
        modifierVal: parseInt(res.match[7]),
        comment: res.match[9]
      };
      robot.brain.set(`roll_${rollName}`, rollInfo);
      return res.reply(
        rollDice(
          rollInfo.dieType,
          rollInfo.dieNum,
          rollInfo.modifier,
          rollInfo.modifierVal,
          rollInfo.comment
        ),
        "Roll saved."
      );
    }
  );

  return robot.hear(/(roll|\/r) \$(\w*)$/i, function(res) {
    const rollName = res.match[2];
    const rollInfo = robot.brain.get(`roll_${rollName}`);
    if (!!rollInfo) {
      return res.reply(
        rollDice(
          rollInfo.dieType,
          rollInfo.dieNum,
          rollInfo.modifier,
          rollInfo.modifierVal,
          rollInfo.comment
        )
      );
    } else {
      return res.reply(`no such saved roll: ${rollName}`);
    }
  });
};
