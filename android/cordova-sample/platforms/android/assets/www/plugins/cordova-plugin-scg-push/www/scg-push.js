cordova.define("cordova-plugin-scg-push.ScgPush", function(require, exports, module) {
var exec = require('cordova/exec');

var StatusBar = {
  registerToken: function (token) {
        exec(null, null, "ScgPush", "registerToken", [token]);
    },
}

module.exports = ScgClient;

});
