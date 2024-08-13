import 'package:signalr_netcore/signalr_client.dart';
import 'package:chat/models/message_model.dart';

class SignalRService {
  late HubConnection hubConnection;
  Function(Message)? onMessageReceived;

  Future<void> setupSignalR(String token,
      {Function(Message)? onMessageReceived}) async {
    this.onMessageReceived = onMessageReceived;

    hubConnection = HubConnectionBuilder()
        .withUrl(
          'https://chat-app.runasp.net/chat',
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token,
          ),
        )
        .build();

    hubConnection.on('SendMessage', (parameters) {
      print("A7A");
      if (parameters != null && parameters.length == 3) {
        final name = parameters[0] as String;
        final message = parameters[1] as String;
        final timestamp = parameters[2] as String;

        print('New message received: $name: $message at $timestamp');
        if (onMessageReceived != null) {
          onMessageReceived(
              Message(msg: message, sender: name, timestamp: timestamp));
        }
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
  }}

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

  void dispose() {
    hubConnection.stop();
  }
}
