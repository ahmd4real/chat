import 'package:signalr_netcore/signalr_client.dart';
import 'package:chat/models/message_model.dart';

class SignalRService {
  late HubConnection hubConnection;
  Function(Message)? onMessageReceived;

  // Setup SignalR with an optional callback function for receiving messages
  Future<void> setupSignalR(String token, {Function(Message)? onMessageReceived}) async {
    this.onMessageReceived = onMessageReceived;

    hubConnection = HubConnectionBuilder()
        .withUrl(
          'https://chat-app.runasp.net/chat',
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token,
          ),
        )
        .build();

    // Listen to incoming messages
    // hubConnection.on('SendMessage', (parameters) {
    //   if (parameters != null && parameters.length == 3) {
    //     final name = parameters[0] as String;
    //     final message = parameters[1] as String;
    //     final timestamp = DateTime.parse(parameters[2] as String);

    //     // Handle incoming message, e.g., update UI
    //     print('New message received: $name: $message at $timestamp');
    //         if (onMessageReceived != null) {
    //           onMessageReceived(Message(msg: message, sender: name, timestamp: timestamp));
    //         }
    //   }
    //});
    hubConnection.on('SendMessage', (parameters) {
      if (parameters != null && parameters.length == 3) {
        final name = parameters[0] as String;
        final message = parameters[1] as String;
        final timestamp = DateTime.parse(parameters[2] as String);

        // Handle incoming message, e.g., update UI
        print('New message received: $name: $message at $timestamp');
        if (onMessageReceived != null)
         onMessageReceived(Message(msg: message, sender: name, timestamp: timestamp));
      }
    });

    // Example of another event handler
    hubConnection.on('DeleteChat', (message) {
      print('DeleteChat message received: $message');
    });

    // Start the SignalR connection
    await hubConnection.start();
    print('SignalR connection started');
  }

  // Send a message to the server
   Future<void> sendMessage(String chatId, String message) async {
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

  // Delete a chat by chat ID
  Future<void> deleteChat(String chatId) async {
    if (hubConnection.state == HubConnectionState.Connected) {
      try {
        // Invoke the DeleteChat method on the server
        await hubConnection.invoke('DeleteChat', args: [chatId]);
        print('DeleteChat invoked successfully');
      } catch (e) {
        print('Error invoking DeleteChat: $e');
      }
    } else {
      print('Connection not established');
    }
  }

  // Dispose of the SignalR connection
  void dispose() {
    hubConnection.stop();
  }
}
