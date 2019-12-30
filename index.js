const fs = require("fs");
const path = require("path");

module.exports = function(robot, scripts) {
  const scriptsPath = path.resolve(__dirname, "src");
  if (fs.existsSync(scriptsPath)) {
    for (let script of fs.readdirSync(scriptsPath).sort()) {
      if (scripts && !scripts.includes("*")) {
        if (scripts.includes(script)) {
          robot.loadFile(scriptsPath, script);
        }
      } else {
        robot.loadFile(scriptsPath, script);
      }
    }
  }
};
