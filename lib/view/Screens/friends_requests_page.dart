import 'package:chat/core/utils/constants.dart';
import 'package:chat/models/request_model.dart';
import 'package:chat/services/services.dart';
import 'package:chat/view/Widgets/request_widget.dart';
import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';

class FriendsRequests extends StatefulWidget {
  const FriendsRequests({super.key});

  @override
  State<FriendsRequests> createState() => _FriendsRequestsState();
}

class _FriendsRequestsState extends State<FriendsRequests> {
  List<Request> requests = [];
  bool isLoading = true;
  late HubConnection hubConnection;

  void removeRequestById(int requestId) {
    setState(() {
      final initialLength = requests.length;
      requests.removeWhere((request) => request.id == requestId);
      final removed = requests.length < initialLength;
      print('Friend request cancelled: $requestId, removed: $removed');
    });
  }

  Future<void> fetchRequests() async {
    try {
      List<Request> fetchedRequests = await getRequests(kToken);
      setState(() {
        requests = fetchedRequests;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  void setupSignalR() async {
    hubConnection = HubConnectionBuilder()
        .withUrl(
          'https://chat-app.runasp.net/chat',
          options: HttpConnectionOptions(
            accessTokenFactory: () async => kToken,
          ),
        )
        .build();

    hubConnection.on('friendRequest', (parameters) {
      if (parameters != null && parameters.length == 4) {
        final id = parameters[0] as int;
        final fullName = parameters[1] as String;
        final profilePicture = parameters[2] as String?;
        final biography = parameters[3] as String?;
        final newRequest =
            Request.fromSignalR(id, fullName, profilePicture, biography);
        setState(() {
          requests.add(newRequest);
        });
        print('New friend request added: $newRequest');
      }
    });
    hubConnection.on('friendRequestCancelled', (parameters) {
      if (parameters != null && parameters.isNotEmpty) {
        final cancelledRequestId = parameters[0] as int;
        print(
            'Received friendRequestCancelled event for ID: $cancelledRequestId');
        removeRequestById(cancelledRequestId);
      }
    });
    await hubConnection.start();
    print('SignalR connection started');
  }

  @override
  void initState() {
    super.initState();
    fetchRequests();
    setupSignalR();
  }

  @override
  void dispose() {
    hubConnection.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: mainColor,
            ))
          : requests.isEmpty
              ? const Center(child: Text('No friend requests'))
              : ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return RequestWidget(
                      fullName:
                          '${request.firstName ?? 'Unknown'} ${request.lastName ?? ''}',
                      bio: request.biography ?? 'No bio available',
                      onAccept: () {
                        removeRequestById(request.id);
                        friendRequestResponse(true, request.id);
                      },
                      onCancel: () {
                        removeRequestById(request.id);
                        friendRequestResponse(false, request.id);
                      },
                      profilePicture: request.profilePicture ?? '',
                    );
                  },
                ),
    );
  }
}
