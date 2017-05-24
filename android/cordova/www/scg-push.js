var exec = require('cordova/exec');

var StatusBar = {
  registerToken: function (token) {
        exec(null, null, "ScgPush", "registerToken", [token]);
    },
}

module.exports = ScgClient;
