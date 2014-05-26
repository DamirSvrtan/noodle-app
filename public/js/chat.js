Array.prototype.indexOfObject = function arrayObjectIndexOf(property, value) {
    for (var i = 0, len = this.length; i < len; i++) {
        if (this[i][property] === value) return i;
    }
    return -1;
}

var app = angular.module('chat', [ ]);

dashboardController = function($scope){
  dashboard = this;
  dashboard.users = $('.all-users').data('users');
  dashboard.websocket = new WebSocket('ws://' + location.host + '/chat');

  dashboard.websocket.onmessage = function(e){
    var response = JSON.parse(e.data);
    if(response.message == "connected"){
      $scope.$apply(function(){
        dashboard.users.push({name: response.username, id: response.user_id});
      });
    };
    if(response.message == "disconnected"){
      $scope.$apply(function(){
        var index = dashboard.users.indexOfObject("id", response.user_id)
        if (index > -1) {
            dashboard.users.splice(index, 1);
        }
      });
    };
    // appendToMessageBox(response.username, response.message);
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
//     appendToMessageBox(response.username, response.message);
//   }

  document.forms["new-message-form"].onsubmit = function(){
      var messageText = document.getElementById("new-message");
      if(messageText.value != ''){
        // connection.send(messageText.value);
        messageText.value ='';
      }
      return false;
  }



});