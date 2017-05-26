cordova.define("cordova-plugin-scg-push.ScgPush", function(require, exports, module) {
var exec = require('cordova/exec');

var PLUGIN_NAME = "ScgPush";

var ScgPush = {

    authenticate: function(authToken, success, failure) {
      exec(success, failure, PLUGIN_NAME, "cdv_authenticate", [authToken])
    }

    registerPushToken: function(token, success, failure) {
      exec(success, failure, PLUGIN_NAME, "cdv_registerPushToken", [token]);
    }

    unregisterPushToken: function(token, success, failure) {
      exec(success, failure, PLUGIN_NAME, "cdv_unregisterPushToken", [token]);
    }

    reportStatus: function(messageID, messageState, success, failure) {
      exec(success, failure, PLUGIN_NAME, "cdv_reportStatus", [messageID, messageState]);
    }

    resolveTrackedLink: function(link, success, failure) {
      exec(success, failure, PLUGIN_NAME, "cdv_resolveTrackedLink", [link]);
    }

    loadAttachment: function(messageId, attachmentId, success, failure) {
      exec(success, failure, PLUGIN_NAME, "cdv_loadAttachment", [messageId, attachmentId]);
    }

    resetBadge: function(token, success, failure) {
      exec(success, failure, PLUGIN_NAME, "cdv_resetBadge", [token]);
    }

    deleteAllInboxMessages: function() {
      exec(null, null, PLUGIN_NAME, "cdv_deleteAllInboxMessagese", []);
    }

    deleteInboxMessage: function(messageId) {
      exec(null, null, PLUGIN_NAME, "cdv_deleteAllInboxMessagese", [messageId]);
    }

    deleteInboxMessageAtIndex: function(messageIndex) {
      exec(null, null, PLUGIN_NAME, "cdv_deleteInboxMessageAtIndex", [messageIndex]);
    }

    getAllInboxMessages: function(result) {
      exec(result, null, PLUGIN_NAME "cdv_getAllInboxMessages", []);
    }

    getInboxMessageAtIndex: function(result) {
      exec(result, null, PLUGIN_NAME "cdv_getInboxMessageAtIndex", []);
    }

    getInboxMessagesCount: function(result) {
      exec(result, null, PLUGIN_NAME "cdv_getInboxMessagesCount", []);
    }
};

module.exports = ScgPush;

});
