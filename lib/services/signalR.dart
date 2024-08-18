import 'package:signalr_netcore/signalr_client.dart';
import 'package:chat/models/message_model.dart';
 late HubConnection hubConnection;
class SignalRService {
 
  Function(Message)? onMessageReceived;
  void Function()? onDeleteChat;
  void Function()? onTyping;
  void Function()? onOnline;
  void Function()? onOffline;
  Function(bool isOnline)? onUserOnlineStatus;

  Future<void> startHubConnection(String token) async {
  hubConnection = HubConnectionBuilder()
      .withUrl(
        'https://chat-app.runasp.net/chat',
        options: HttpConnectionOptions(
          accessTokenFactory: () async => token,
          // Increase timeout settings if necessary
  
        ),
      )
      .build();

  try {
    await hubConnection.start();
    print('SignalR connection started');
  } catch (e) {
    print('Error starting SignalR connection: $e');
  }
}

  Future<void> setupSignalR(
      {Function()? onDeleteChat,
      Function(Message)? onMessageReceived,
      void Function()? onOnline,
      void Function()? onOffline,
      Function()? onTyping,
      Function(
        bool isOnline,
      )? onUserOnlineStatus}) async {
    this.onMessageReceived = onMessageReceived;
    this.onDeleteChat = onDeleteChat;
    this.onTyping = onTyping;
    this.onOffline = onOffline;
    this.onOnline = onOnline;
    this.onUserOnlineStatus = onUserOnlineStatus;

    hubConnection.on('SendMessage', (parameters) {
      if (parameters != null && parameters.length == 3) {
        final id = parameters[0] as int;
        final message = parameters[1] as String;
        final timestamp = parameters[2] as String;

        if (onMessageReceived != null) {
          onMessageReceived(Message(
              msg: message, sender: id.toString(), timestamp: timestamp));
        }
      }
    });

    hubConnection.on('DeleteChat', (message) {
      if (onDeleteChat != null) {
        onDeleteChat();
      }
    });

    hubConnection.on('IsTyping', (parameters) {
      if (onTyping != null) {
        onTyping();
      }
    });

    hubConnection.on('IsOnline', (parameters) {
      if (parameters != null && parameters.length == 1) {
        final isOnline = parameters[0] as bool;

        if (onUserOnlineStatus != null) {
          onUserOnlineStatus(isOnline);
        }
      }
    });
  }

  Future<void> sendMessage(String message, String chatId) async {
    if (hubConnection.state == HubConnectionState.Connected) {
      try {
        await hubConnection.invoke('SendMessage', args: [message, chatId]);
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

  Future<void> isOnline(String chatId) async {
    try {
      await hubConnection.invoke('IsOnline', args: [chatId]);
      print('IsOnline invoked successfully');
    } catch (e) {
      print('Error invoking IsOnline: $e');
    }
  }

  void dispose() {
    //hubConnection.stop().then((_) {}).catchError((error) {});
  }
}
