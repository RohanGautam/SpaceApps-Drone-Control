import 'dart:core';
import 'dart:io';

class ClientWebSocket {
  final HOST =
      "10.0.1.136"; // # The SERVER's hostname/IP - find from machine, should not be the public IP
  final PORT =
      65432; //Port to listen on (non-privileged ports are > 1023), should be same for client and server

  String dataRecieved = "0.0";
  String getDataFromServer() {
    Socket.connect(HOST, PORT).then((socket) {
      print('Connected to: '
          '${socket.remoteAddress.address}:${socket.remotePort}');
      // socket.write(datatoSend);
      socket.listen((data) {
        // print(data);
        dataRecieved = (String.fromCharCodes(data).trim());
        print(dataRecieved);
        if(dataRecieved!=""){
          socket.destroy();
          return dataRecieved;
        }
      }, onDone: () {
        socket.destroy();
      });
    });
    return dataRecieved;
  }
}
