Array.prototype.indexOfObject = function arrayObjectIndexOf(property, value) {
    for (var i = 0, len = this.length; i < len; i++) {
        if (this[i][property] === value) return i;
    }
    return -1;
}

function NoodlesWebSocket(url){
  this.url = url;
  this.webSocket = new WebSocket(url);

  this.send = function(message){
    if(message instanceof Object){
      message = JSON.stringify(message);
    }
    this.webSocket.send(message)
  }

  this.close = function(){
    this.webSocket.close();
  }

  this.onopen = null;
  this.onmessage = null;
  this.onclose = null;
  this.onerror = null;

  var noodlesWebSocketDelegator = this;

  this.webSocket.onopen = function(event){
    if(noodlesWebSocketDelegator.onopen !== null){
      noodlesWebSocketDelegator.onopen(event);
    }
  }

  this.webSocket.onmessage = function(event){
    if(noodlesWebSocketDelegator.onmessage !== null){
      noodlesWebSocketDelegator.onmessage(event);
    }
  }

  this.webSocket.onclose = function(event){
    if(noodlesWebSocketDelegator.onclose !== null){
      noodlesWebSocketDelegator.onclose(event);
    }
  }

  this.webSocket.onerror = function(event){
    if(noodlesWebSocketDelegator.onerror !== null){
      noodlesWebSocketDelegator.onerror(event);
    }
  }
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
  var SWITCH_PUBLIC_ROOM = 4;
  var SWITCH_PRIVATE_ROOM = 5;
  var ROOM_MESSAGES = 6;

  var dashboard = this;
  $conversation = $('.conversation');
  $conversationsIndex = $('.conversations-index');

  dashboard.onlineUsers = $conversationsIndex.data('online-users');
  dashboard.offlineUsers = $conversationsIndex.data('offline-users');

  dashboard.rooms = $conversationsIndex.data('rooms');
  dashboard.roomId = $conversation.data('room-id');

  dashboard.roomName = $conversation.data('room-name');
  dashboard.messages = $conversation.data('default-room-messages');

  dashboard.noodlesWebSocket = new NoodlesWebSocket('ws://' + location.host + '/chat');

  this.openConversation = function($event, userId){
    $event.preventDefault();
    var message = {
      action: SWITCH_PRIVATE_ROOM,
      user_id: userId
    };
    dashboard.noodlesWebSocket.send(message);
  }

  this.openRoom = function($event, roomId){
    $event.preventDefault();
    var message = {
      action: SWITCH_PUBLIC_ROOM,
      room_id: roomId
    };
    dashboard.noodlesWebSocket.send(message);
  }

  this.newMessage = {};
  this.sendNewMessage = function(message){
    var newMessage = {
      content: message,
      action: NEW_MESSAGE,
      room_id: dashboard.roomId
    };
    dashboard.noodlesWebSocket.send(newMessage);
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

  var changeConversation = function(response){
    dashboard.roomId = response.room_id;
    dashboard.roomName = response.room_name;
    $scope.$apply(function(){
      dashboard.messages.length = 0;
      for(key in response.messages){
        var message = response.messages[key];
        if(typeof message == "object") dashboard.messages.push(message);
      }
    });
  }

  var appendNewMessage = function(response){
    $scope.$apply(function(){
      if(response.room_id === dashboard.roomId){
        dashboard.messages.push(response);
      }else{
        // alert("OTHER_ROOM!");
      }
    });
  }

  dashboard.noodlesWebSocket.onmessage = function(e){
    var response = JSON.parse(e.data);
    switch(response.action){
      case USER_CONNECTED:
        addNewOnlineUser(response);
        break;
      case USER_DISCONNECTED:
        addNewOfflineUser(response);
        break;
      case ROOM_MESSAGES:
        changeConversation(response);
        break;
      case NEW_MESSAGE:
        appendNewMessage(response);
        break;
      default:
        alert("SUMTIN WEIRD");
    }
  }
};

app.controller('ChatDashboard', dashboardController);