fs = require('fs');
var filelist = fs.readdirSync("./");
var data = {};
for (var i=0; i<filelist.length; i++) {
	var file = filelist[i];
	if (file.match(/.*\.json/)) {
		data["[ALL]/" + file] = fs.readFileSync(file, "utf-8");
	}
}

module.exports = data;