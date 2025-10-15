// ignore_for_file: library_prefixes, avoid_print
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../view/theme/constants.dart';

class SocketService {
  late IO.Socket socket;
  Function
      onMessageReceived; // Callback function to handle the received message

  SocketService(this.onMessageReceived);

  void connect() {
    // Set up the socket options and connection URL
    socket = IO.io(StringConstants.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false, // Disable auto-connect to control manually
    });

    // Connect to the socket server
    socket.connect();

    // Define event listeners
    socket.onConnect((_) {
      print('Socket connected');
      // Perform additional actions when connected
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket.on('message', (data) {
      onMessageReceived(data); // Pass the received message to the callback
    });

    socket.onError((error) {
      print('Error occurred: $error');
    });
  }

  void getMessage(data) {
    socket.emit('getmessage', data); // Emit the message event to the server
  }

  void sentMessage(data) {
    socket.emit('newMessage', data); // Emit the message event to the server
  }

  void disconnect() {
    socket.disconnect();
  }
}
