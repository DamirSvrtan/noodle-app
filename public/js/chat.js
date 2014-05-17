var username = "User_" + Math.floor((Math.random()*1000)+1);
var connection = new WebSocket('ws://'+ location.host + '/chat?username=' + username);

connection.onmessage = function(e){
  var response = JSON.parse(e.data);
  appendToMessageBox(response.username, response.message);
}

document.forms["new-message"].onsubmit = function(){
    var messageText = document.getElementById("new-message-content");
    if(messageText.value != ''){
      var newMessage = {
        'username': username,
        'message': messageText.value
      };
      connection.send(JSON.stringify(newMessage));
      messageText.value ='';
    }
    return false;
}

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