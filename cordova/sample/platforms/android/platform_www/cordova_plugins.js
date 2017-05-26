cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "id": "cordova-plugin-scg-push.ScgPush",
        "file": "plugins/cordova-plugin-scg-push/www/scg-push.js",
        "pluginId": "cordova-plugin-scg-push",
        "clobbers": [
            "scg.push"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-whitelist": "1.3.2",
    "cordova-plugin-scg-push": "1.4.0"
};
// BOTTOM OF METADATA
});