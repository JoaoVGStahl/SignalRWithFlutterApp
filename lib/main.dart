// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final connection = HubConnectionBuilder()
      .withUrl(
          'http://localhost:8282/printer',
          HttpConnectionOptions(
            skipNegotiation: true,
            transport: HttpTransportType.webSockets,
            logging: (level, message) => print(message),
          ))
      .build();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("SignalR Demo App"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _messageConnectionState(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                    onPressed: _buttonTapped, child: const Text("Send Teste")),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(connection.state == HubConnectionState.connected
              ? Icons.wifi
              : Icons.wifi_off),
          onPressed: () async {
            if (connection.state == HubConnectionState.connected) {
              print("Connection ID: ${connection.connectionId}");
            } else {
              await connection.start();
            }
          },
        ),
      ),
    );
  }

  String _messageConnectionState() {
    var state = connection.state == HubConnectionState.connected
        ? 'Conectado'
        : 'Desconectado';
    return "Connection Status: $state\n";
  }

  void _buttonTapped() async {
    try {
      final result =
          await connection.invoke("SendTeste", args: ["Mensagem enviada!"]);
      print(result);
    } catch (e) {
      print(e);
    }
  }
}
