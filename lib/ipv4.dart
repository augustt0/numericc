import 'dart:math';

import 'package:numericc/utils.dart';

class IPv4 {
  Future<Game> getRandomGame() async {
    List<String> games = [
      "Ask Mask",
      "Ask Broadcast",
      "Ask Network",
      "Ask Class",
      "Ask Host",
      "Ask Network Amount",
      "Ask Host Amount",
    ];

    int last = -1;
    int typeOfGame = 0;

    while (true) {
      do {
        await Future.delayed(const Duration(milliseconds: 1));
        typeOfGame =
            Random(DateTime.now().millisecondsSinceEpoch).nextInt(games.length);
      } while (typeOfGame == last);

      String selectedGame = games[typeOfGame];

      switch (selectedGame) {
        case "Ask Mask":
          return await askMask();
        case "Ask Broadcast":
          return await askBroadcast();
        case "Ask Network":
          return await askNetwork();
        case "Ask Class":
          return await askIpClass();
        case "Ask Host":
          return await askHost();
        case "Ask Network Amount":
          return await askNetworkAmount();
        case "Ask Host Amount":
          return await askHostAmount();
        default:
          return await askNetwork();
      }
    }
  }

  Future<int> getRandomClass() async {
    await Future.delayed(const Duration(milliseconds: 1));
    return Random(DateTime.now().millisecondsSinceEpoch).nextInt(3);
  }

  Future<Game> askHost() async {
    int c = await getRandomClass();
    String ip = await getIpFromClass(c);

    return Game(
        question: "El host de la ip $ip/${Utils.getMaskBits(c)}",
        answer: Utils.getHostOfIp(ip));
  }

  Future<Game> askMask() async {
    int c = await getRandomClass();
    return Game(
        question: "La máscara de la clase ${Utils.classNameFromInt(c)}",
        answer: Utils.getMaskOfClass(c));
  }

  Future<Game> askBroadcast() async {
    int c = await getRandomClass();
    String ip = await getIpFromClass(c);

    return Game(
        question: "El broadcast de la ip $ip",
        answer: Utils.getBroadcastOfIp(ip));
  }

  Future<Game> askNetwork() async {
    int c = await getRandomClass();
    String ip = await getIpFromClass(c);

    return Game(
        question: "La red de la ip $ip", answer: Utils.getNetworkOfIp(ip));
  }

  Future<Game> askNetworkAmount() async {
    int c = await getRandomClass();

    return Game(
        question:
            "Cantidad (x) de redes de la clase ${Utils.classNameFromInt(c)} (2^x)",
        answer: Utils.getClassNetworkAmount(c));
  }

  Future<Game> askHostAmount() async {
    int c = await getRandomClass();

    return Game(
        question:
            "Cantidad (x) de hosts de la clase ${Utils.classNameFromInt(c)} (2^x - 2)",
        answer: Utils.getClassHostsAmount(c));
  }

  Future<Game> askIpClass() async {
    int c = await getRandomClass();
    String ip = await getIpFromClass(c);

    return Game(
        question: "La clase de la ip $ip",
        answer: Utils.classNameFromInt(Utils.getClassOfIp(ip)));
  }

  Future<String> getIpFromClass(int classInt) async {
    List<int> randIp = [];

    for (int i = 0; i < 4; i++) {
      randIp.add(Random(DateTime.now().millisecondsSinceEpoch).nextInt(256));
      await Future.delayed(const Duration(milliseconds: 3));
    }

    switch (classInt) {
      case 0:
        randIp[0] = Random(DateTime.now().millisecondsSinceEpoch).nextInt(127);
      case 1:
        randIp[0] =
            Random(DateTime.now().millisecondsSinceEpoch).nextInt(63) + 128;
      case 2:
        randIp[0] =
            Random(DateTime.now().millisecondsSinceEpoch).nextInt(31) + 192;
    }

    return randIp.join('.');
  }
}

class Game {
  String question;
  String answer;

  Game({required this.question, required this.answer});

  bool verifyAnswer(String response) {
    return response.toUpperCase() == answer;
  }
}
