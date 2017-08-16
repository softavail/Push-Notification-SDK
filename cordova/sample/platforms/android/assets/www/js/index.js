/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        this.receivedEvent('deviceready');

        console.log('device ready');

        scg.push.start("ttNs7etXXqvJd4VLiLHrp2", "3438755246859", "http://95.158.130.102:8080/scg-dra/proxy/", function() {
            console.log('ok start');
        }, function(error) {
            console.error('error start ' + error);
        });

        scg.push.getToken(function(token) {
            // save this server-side and use it to push notifications to this device
            scg.push.registerPushToken(token, function(result) {
              console.log('ok registerPushToken ' + JSON.stringify(result));
            }, function(error) {
              console.error('error registerPushToken ' + error);
            });
            console.log('ok getToken ' + token);
        },  function(error) {
            console.error('error getToken ' + error);
        });

        scg.push.onTokenRefresh(function(newToken) {
            console.log('ok onNewToken ' + newToken);
        }, function() {});

        scg.push.onNotification(function(scgMessage) {
            console.log('ok onNotification ' + JSON.stringify(scgMessage));
        }, function (error) {});

        scg.push.getInboxMessageAtIndex(0, function(data) {
            console.log('ok getInboxMessageAtIndex[0] ' + JSON.stringify(data));
        }, function (error) {});

    },

    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};

app.initialize();
