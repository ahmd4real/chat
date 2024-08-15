import 'package:chat/constants.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:chat/models/message_model.dart';

class SignalRService {
  late HubConnection hubConnection;
  Function(Message)? onMessageReceived;
  void Function()? onDeleteChat;
  void Function()? onTyping;
  Function(String)? isOnlineCallback;

  Future<void> setupSignalR(String token,
      {Function(String)? isOnlineCallback,Function()? onDeleteChat, Function(Message)? onMessageReceived,Function()? onTyping}) async {
    this.onMessageReceived = onMessageReceived;
    this.onDeleteChat = onDeleteChat;
    this.onTyping=onTyping;
    this.isOnlineCallback=isOnlineCallback;   

    hubConnection = HubConnectionBuilder()
        .withUrl(
          'https://chat-app.runasp.net/chat',
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token,
          ),
        )
        .build();

    await hubConnection.start();
    print('SignalR connection started');

    hubConnection.on('SendMessage', (parameters) {
      if (parameters != null && parameters.length == 3) {
        final id = parameters[0] as int;
        final message = parameters[1] as String;
        final timestamp = parameters[2] as String;

        if (onMessageReceived != null) {
          print('ID:$id,New message received: $message at $timestamp');
          typing = false;
          print('is Typing: $typing');
          onMessageReceived(Message(
              msg: message, sender: id.toString(), timestamp: timestamp));
        }
      }
    });

    //Example of another event handler
    hubConnection.on('DeleteChat', (message) {
      print('DeleteChat message received: $message');
      if (onDeleteChat != null) {
        print('DeleteChat not equal NULL:');
        onDeleteChat();
      }
    });

    hubConnection.on('IsTyping', (parameters) {
      if(onTyping!=null){
        onTyping();
      }
    });
  

  hubConnection.on('IsOnline', (response) {
    print('IsOnline message received: $response');
    if (isOnlineCallback != null) {
      isOnlineCallback(response.toString());
    }
    
  });
  


  }

  // Send a message to the server
  Future<void> sendMessage(String message, String chatId) async {
    if (hubConnection.state == HubConnectionState.Connected) {
      try {
        await hubConnection.invoke('SendMessage', args: [
          message,
          chatId,
        ]);
        print('Message sent: $message');
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  Future<void> isTyping(String chatId) async {
    if (hubConnection.state == HubConnectionState.Connected) {
      try {
        await hubConnection.invoke('IsTyping', args: [chatId]);
        print('IsTyping invoked successfully');
      } catch (e) {
        print('Error invoking IsTyping: $e');
      }
    } else {
      print('Connection not established');
    }
  }

  Future<void> deleteChat(String chatId) async {
    if (hubConnection.state == HubConnectionState.Connected) {
      try {
        await hubConnection.invoke('DeleteChat', args: [chatId]);
        print('DeleteChat invoked successfully');
      } catch (e) {
        print('Error invoking DeleteChat: $e');
      }
    } else {
      print('Connection not established');
    }
  }
  
  isOnline(String chatId) async{
    if (hubConnection.state == HubConnectionState.Connected) {
      try {
        await hubConnection.invoke('IsOnline', args: [chatId]);
        print('IsOnline invoked successfully');
      } catch (e) {
        print('Error invoking IsOnline: $e');
      }
    } else {
      print('Connection not established');
    }

  }

  @override
  void dispose() {
    print('Dispose method called, stopping SignalR connection...');
    hubConnection.stop().then((_) {
      print('SignalR connection stopped successfully.');
    }).catchError((error) {
      print('Error stopping SignalR connection: $error');
    });
  }
}