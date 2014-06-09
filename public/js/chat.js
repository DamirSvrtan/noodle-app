Array.prototype.indexOfObject = function arrayObjectIndexOf(property, value) {
    for (var i = 0, len = this.length; i < len; i++) {
        if (this[i][property] === value) return i;
    }
    return -1;
}

var app = angular.module('chat', []);

dashboardController = function($scope){
  var dashboard = this;
  $conversation = $('.conversation');
  $allUsers = $('.all-users');
  $allRooms = $('.all-rooms');

  dashboard.onlineUsers = $allUsers.data('online-users');
  dashboard.offlineUsers = $allUsers.data('offline-users');

  dashboard.rooms = $allRooms.data('rooms');
  dashboard.defaultRoomId = $conversation.data('default-room-id');

  dashboard.websocket = new WebSocket('ws://' + location.host + '/chat');

  this.newMessage = {};
  this.pushMessage = function(message){
    dashboard.websocket.send(message);
    this.newMessage = {};
  };

  var addNewOnlineUser = function(response){
    $scope.$apply(function(){
      var userInfo = { name: response.user_name, id: response.user_id };
      dashboard.onlineUsers.push(userInfo);

      var index = dashboard.offlineUsers.indexOfObject("id", response.user_id);
      if (index > -1) dashboard.offlineUsers.splice(index, 1);
    });
  };

  var addNewOfflineUser = function(response){
    $scope.$apply(function(){
      var index = dashboard.onlineUsers.indexOfObject("id", response.user_id);
      if (index > -1) dashboard.onlineUsers.splice(index, 1);

      var userInfo = { name: response.user_name, id: response.user_id };
      dashboard.offlineUsers.push(userInfo);
    });    
  };

  dashboard.websocket.onmessage = function(e){
    var response = JSON.parse(e.data);
    if(response.message == "connected"){
      addNewOnlineUser(response);
    }else if(response.message == "disconnected"){
      addNewOfflineUser(response);
    }else{
      appendToMessageBox(response.user_name, response.message);
    }
    // appendToMessageBox(response.user_name, response.message);
  }
};

app.controller('OnlineUserDashboard', dashboardController);

    function appendToMessageBox(name, message){
        var newContent = document.createElement('h4');
        var nameLabel = document.createElement('span');
        var labelClass = 'label label-';

        if(message == "connected"){
          labelClass += 'success';
        }else if(message == "disconnected"){
          labelClass += 'important';
        }else{
          labelClass += 'primary';
        }

        nameLabel.className = labelClass;
        nameLabel.innerHTML = name;

        var messageContent = document.createElement('span');
        messageContent.className = "submited-message"
        messageContent.innerHTML = message;

        newContent.appendChild(nameLabel)
        newContent.appendChild(messageContent)

        var messageBox = document.getElementById("message-box");
        messageBox.appendChild(newContent);
        messageBox.scrollTop = messageBox.scrollHeight;
    }




$(document).ready(function(){
//   var connection = new WebSocket('ws://' + location.host + '/chat');

//   connection.onmessage = function(e){
//     var response = JSON.parse(e.data);
//     appendToMessageBox(response.user_name, response.message);
//   }

  // document.forms["new-message-form"].onsubmit = function(){
  //     var messageText = document.getElementById("new-message");
  //     if(messageText.value != ''){
  //       // connection.send(messageText.value);
  //       messageText.value ='';
  //     }
  //     return false;
  // }



});