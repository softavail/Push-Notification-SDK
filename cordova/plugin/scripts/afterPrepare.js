#!/usr/bin/env node
'use strict';

var fs = require('fs');

var checkPath = function(path, checkFile) {
    try  {
        if (checkFile) {
            return fs.statSync(path).isFile();
        } else {
            return fs.statSync(path).isDirectory();
        }
    } catch (e) {
        return false;
    }
}

if (checkPath("platforms/android") && checkPath("google-services.json", true)) {
    //copy the file
    fs.writeFileSync("platforms/android/google-services.json", fs.readFileSync("google-services.json").toString());
}
