var exec = require('cordoca/exec');

var PLUGIN_NAME = "SCGPush";

var SCGPush = {
    registerPushToken: function(token, completionBlock, failureBlock){
      exec(success, error, PLUGIN_NAME, "cdv_registerPushToken", [token]);
    }

    unregisterPushToken: function(token, completionBlock, failureBlock){
      exec(success, error, PLUGIN_NAME, "cdv_unregisterPushToken", [token]);
    }

    reportStatus: function(messageID, messageState, completionBlock, failureBlock){
      exec(success, error, PLUGIN_NAME, "cdv_reportStatus", [messageID, messageState]);
    }

    resolveTrackedLink: function(link, completionBlock, failureBlock){
      exec(success, error, PLUGIN_NAME, "cdv_resolveTrackedLink", [link]);
    }

    resetBadge: function(token, completionBlock, failureBlock){
      exec(success, error, PLUGIN_NAME, "cdv_resetBadge", [token]);
    }

    cdv_loadAttachment: function(messageId, attachmentId, completionBlock, failureBlock){
      exec(success, error, PLUGIN_NAME, "cdv_registerPushToken", [messageId, attachmentId]);
    }
};
