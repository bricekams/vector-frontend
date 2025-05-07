import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WSService {
  static final String baseUrl = dotenv.env['BASE_API_URL']!;

  static IO.Socket? socket;

  static void init() {
    socket = IO.io(
      baseUrl,
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    socket!.on("exception", (error) {
      if (kDebugMode) print(error);
    });

    socket!.onConnect((event) {
      if (kDebugMode) print("Connected");
    });
  }

  static void reconnect() {
    dispose();
    init();
  }

  static void dispose() {
    socket?.disconnect();
    socket?.dispose();
    socket = null;
  }
}
