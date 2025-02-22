import 'dart:io';

import 'package:fleetcarpooling/screens/map_functionality/udp_message_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef UdpMessageHandler = void Function(String message);

class UDPManager {
  late RawDatagramSocket _clientSocket;
  late InternetAddress destinationIPAddress;
  late int port;

  UDPManager(String destinationIP, int givenPort) {
    destinationIPAddress = InternetAddress(destinationIP);
    port = givenPort;
  }

  Future<void> connectUDP() async {
    _clientSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    messageListener();
  }

  void sendCommand(String command, MarkerId selectedMarkerId) {
    _clientSocket.send("$command ${selectedMarkerId.value}".codeUnits,
        destinationIPAddress, port);
  }

  void messageListener() {
    _clientSocket.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        Datagram dg = _clientSocket.receive()!;
        String message = String.fromCharCodes(dg.data);
        handleUdpMessage(message);
      }
    });
  }

  void handleUdpMessage(String message) {
    (message.toLowerCase()).contains("is currently at")
        ? ""
        : UDPMessageHandler().handle(message);
  }

  void dispose() {
    _clientSocket.close();
  }
}
