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

        // Use the lines below in order to test the implentation.
        // Make the coresponding changes.
/*
        scg.push.authenticate('bwbkz5Kd9yBApIkSxbRav6', function(token) {
            console.log('ok authenticate ' + token);
        }, function(error) {
            console.error('error authenticate ' + error);
        });

        scg.push.getToken(function(token) {
            // save this server-side and use it to push notifications to this device
            console.log('ok getToken ' + token);
        }, function(error) {
            console.error('error getToken ' + error);
        });

        scg.push.registerPushToken('eMpHyTGifK4:APA91bFcIpTy8OAR2OQs1D_qGoqBCAfnFeH_bl1_mqrUOSZ9TFCakwAHZGG5poNL4URQuTJq4ITcQxdjtrRkIzV4F5hriLE56tM_Y_jIwVWoE5e3jQELfq_5OD7GaZmdTzPuRIYcd0UC', function(token) {
            console.log('ok registerPushToken ' + token);
        }, function(error) {
            console.error('error registerPushToken ' + error);
        });
*/
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