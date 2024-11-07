import 'dart:math';

class IPv4 {
  Future<Game> getRandomGame() async {
    List<String> games = [
      "Ask Mask",
      "Ask Broadcast",
      "Ask Network",
      "Ask Class"
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
      }
    }
  }

  Future<int> getRandomClass() async {
    await Future.delayed(const Duration(milliseconds: 1));
    return Random(DateTime.now().millisecondsSinceEpoch).nextInt(3);
  }

  String classNameFromInt(int classInt) {
    switch (classInt) {
      case 0:
        return "A";
      case 1:
        return "B";
      case 2:
        return "C";
      default:
        throw Exception("Class does not exist");
    }
  }

  Future<Game> askMask() async {
    int c = await getRandomClass();
    return Game(
        question: "La máscara de la clase ${classNameFromInt(c)}",
        answer: getMaskOfClass(c));
  }

  Future<Game> askBroadcast() async {
    int c = await getRandomClass();
    String ip = await getIpFromClass(c);

    return Game(
        question: "El broadcast de la ip $ip", answer: getBroadcastOfIp(ip));
  }

  Future<Game> askNetwork() async {
    int c = await getRandomClass();
    String ip = await getIpFromClass(c);

    return Game(question: "La red de la ip $ip", answer: getNetworkOfIp(ip));
  }

  Future<Game> askIpClass() async {
    int c = await getRandomClass();
    String ip = await getIpFromClass(c);

    return Game(
        question: "La clase de la ip $ip",
        answer: classNameFromInt(getClassOfIp(ip)));
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

  int getClassOfIp(String ip) {
    int myIp = int.parse(ip.split(".").first);

    if (myIp > 223) {
      throw Exception("Invalid IP address");
    }

    if (myIp >= 192) {
      return 2;
    } else if (myIp >= 128) {
      return 1;
    } else {
      return 0;
    }
  }

  String getMaskOfClass(int classInt) {
    switch (classInt) {
      case 0:
        return "255.0.0.0";
      case 1:
        return "255.255.0.0";
      case 2:
        return "255.255.255.0";
      default:
        throw Exception("Class does not exist");
    }
  }

  String getNetworkOfIp(String ip) {
    int c = getClassOfIp(ip);
    List<int> myIp = ip.split(".").map((e) => int.parse(e)).toList();

    for (int i = 3; i > c; i--) {
      myIp[i] = 0;
    }
    return myIp.join(".");
  }

  String getBroadcastOfIp(String ip) {
    int c = getClassOfIp(ip);
    List<int> myIp = ip.split(".").map((e) => int.parse(e)).toList();

    for (int i = 3; i > c; i--) {
      myIp[i] = 255;
    }
    return myIp.join(".");
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
