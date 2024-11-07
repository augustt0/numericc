import 'dart:math';

class Utils {
  static String classNameFromInt(int classInt) {
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

  static int getClassOfIp(String ip) {
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

  static Future<String> getIpFromClass(int classInt) async {
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

  static String getMaskOfClass(int classInt) {
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

  static String getMaskBits(int classInt) {
    return "${8 * classInt + 8}";
  }

  static String getClassNetworkAmount(int classInt) {
    return "${7 * classInt + 7}";
  }

  static String getClassHostsAmount(int classInt) {
    return "${24 - 8 * classInt}";
  }

  static String getNetworkOfIp(String ip) {
    int c = getClassOfIp(ip);
    List<int> myIp = ip.split(".").map((e) => int.parse(e)).toList();

    for (int i = 3; i > c; i--) {
      myIp[i] = 0;
    }
    return myIp.join(".");
  }

  static String getBroadcastOfIp(String ip) {
    int c = getClassOfIp(ip);
    List<int> myIp = ip.split(".").map((e) => int.parse(e)).toList();

    for (int i = 3; i > c; i--) {
      myIp[i] = 255;
    }
    return myIp.join(".");
  }

  static String getHostOfIp(String ip) {
    int c = getClassOfIp(ip);
    List<int> myIp = ip.split(".").map((e) => int.parse(e)).toList();

    return myIp.sublist(c + 1, myIp.length).join(".");
  }

  static List<String> getListOfClasses() {
    List<String> cl = ["A", "B", "C"];
    cl.shuffle();
    return cl;
  }

  static List<String> getPossibleMasks() {
    List<String> cl = ["255.0.0.0", "255.255.0.0", "255.255.255.0"];
    cl.shuffle();
    return cl;
  }

  static List<String> getPossibleIps(String ip, String fill) {
    List<String> myIp = ip.split(".");
    List<String> sl = [];

    for (int i = 1; i < 4; i++) {
      String x = myIp.sublist(0, i).join(".");
      for (var y = 0; y < 4 - i; y++) {
        x = "$x.$fill";
      }
      sl.add(x);
    }

    sl.shuffle();
    return sl;
  }

  static List<String> getPossibleHosts(String ip) {
    List<String> myIp = ip.split(".");
    List<String> sl = [];

    for (var i = 3; i > 0; i--) {
      sl.add(myIp.sublist(i, myIp.length).join("."));
    }

    sl.shuffle();

    return sl;
  }

  static List<String> getPossibleNetworks(String ip) {
    List<String> myIp = ip.split(".");
    List<String> sl = [];

    for (var i = 3; i > 0; i--) {
      sl.add(myIp.sublist(i, myIp.length).join("."));
    }

    sl.shuffle();

    return sl;
  }

  static List<String> getPossibleNetworkAmount() {
    List<String> sl = [];

    for (var i = 1; i < 4; i++) {
      sl.add("${7 * i}");
    }

    sl.shuffle();

    return sl;
  }

  static List<String> getPossibleHostAmount() {
    List<String> sl = [];

    for (var i = 0; i < 3; i++) {
      sl.add("${24 - 8 * i}");
    }

    sl.shuffle();

    return sl;
  }
}
