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
}
