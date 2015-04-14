fs = require('fs');
var data = fs.readFileSync("index1s.json","utf-8");

module.exports = {
  "[ALL]/index1s.json": data
};