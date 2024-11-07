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
    String ip = await Utils.getIpFromClass(c);
    List<String> answers = Utils.getPossibleHosts(ip);
    int correctAnswer = answers.indexOf(Utils.getHostOfIp(ip));

    return Game(
        question: "El host de la ip $ip/${Utils.getMaskBits(c)}",
        answers: answers,
        correctAnswer: correctAnswer);
  }

  Future<Game> askMask() async {
    int c = await getRandomClass();
    List<String> answers = Utils.getPossibleMasks();
    int correctAnswer = answers.indexOf(Utils.getMaskOfClass(c));
    return Game(
        question: "La máscara de la clase ${Utils.classNameFromInt(c)}",
        answers: answers,
        correctAnswer: correctAnswer);
  }

  Future<Game> askBroadcast() async {
    int c = await getRandomClass();
    String ip = await Utils.getIpFromClass(c);
    List<String> answers = Utils.getPossibleIps(ip, "255");
    int correctAnswer = answers.indexOf(Utils.getBroadcastOfIp(ip));

    return Game(
        question: "El broadcast de la ip $ip",
        answers: answers,
        correctAnswer: correctAnswer);
  }

  Future<Game> askNetwork() async {
    int c = await getRandomClass();
    String ip = await Utils.getIpFromClass(c);
    List<String> answers = Utils.getPossibleIps(ip, "0");
    int correctAnswer = answers.indexOf(Utils.getNetworkOfIp(ip));

    return Game(
        question: "La red de la ip $ip",
        answers: answers,
        correctAnswer: correctAnswer);
  }

  Future<Game> askNetworkAmount() async {
    int c = await getRandomClass();
    List<String> answers = Utils.getPossibleNetworkAmount();
    int correctAnswer = answers.indexOf(Utils.getClassNetworkAmount(c));

    return Game(
        question:
            "Cantidad (x) de redes de la clase ${Utils.classNameFromInt(c)} (2^x)",
        answers: answers,
        correctAnswer: correctAnswer);
  }

  Future<Game> askHostAmount() async {
    int c = await getRandomClass();
    List<String> answers = Utils.getPossibleHostAmount();
    int correctAnswer = answers.indexOf(Utils.getClassHostsAmount(c));

    return Game(
        question:
            "Cantidad (x) de hosts de la clase ${Utils.classNameFromInt(c)} (2^x - 2)",
        answers: answers,
        correctAnswer: correctAnswer);
  }

  Future<Game> askIpClass() async {
    int c = await getRandomClass();
    String ip = await Utils.getIpFromClass(c);
    List<String> answers = Utils.getListOfClasses();
    int correctAnswer =
        answers.indexOf(Utils.classNameFromInt(Utils.getClassOfIp(ip)));

    return Game(
        question: "La clase de la ip $ip",
        answers: answers,
        correctAnswer: correctAnswer);
  }
}

class Game {
  String question;
  List<String> answers;
  int correctAnswer;

  Game(
      {required this.question,
      required this.answers,
      required this.correctAnswer});

  bool verifyAnswer(int response) {
    return response == correctAnswer;
  }
}
