Array.prototype.indexOfObject = function arrayObjectIndexOf(property, value) {
    for (var i = 0, len = this.length; i < len; i++) {
        if (this[i][property] === value) return i;
    }
    return -1;
}

var scrollDown = function(){
  var messageBox = document.getElementById("message-box");
  messageBox.scrollTop = messageBox.scrollHeight;
}

var app = angular.module('chat', []);

app.directive('messageScrollTopDirective', function() {
  return function(scope, element, attrs) { if (scope.$last) scrollDown() };
});

dashboardController = function($scope){
  var USER_CONNECTED = 1;
  var USER_DISCONNECTED = 2;
  var NEW_MESSAGE = 3;
  var SWITCH_ROOM = 4

  var dashboard = this;
  $conversation = $('.conversation');
  $allUsers = $('.all-users');
  $allRooms = $('.all-rooms');

  dashboard.onlineUsers = $allUsers.data('online-users');
  dashboard.offlineUsers = $allUsers.data('offline-users');

  dashboard.rooms = $allRooms.data('rooms');
  dashboard.defaultRoomId = $conversation.data('default-room-id');

  dashboard.messages = $conversation.data('default-room-messages');

  dashboard.websocket = new WebSocket('ws://' + location.host + '/chat');

  this.newMessage = {};
  this.sendNewMessage = function(message){
    var newMessage = {
      content: message,
      action: NEW_MESSAGE
    };
    dashboard.websocket.send(JSON.stringify(newMessage));
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
    switch(response.action){
      case USER_CONNECTED:
        addNewOnlineUser(response);
        break;
      case USER_DISCONNECTED:
        addNewOfflineUser(response);
        break;
      default:
        $scope.$apply(function(){
          dashboard.messages.push(response);
        });
    }
  }
};

app.controller('OnlineUserDashboard', dashboardController);