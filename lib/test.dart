import 'package:numericc/utils.dart';

void main() async {
  String ip = "194.195.164.10";
  print(ip);
  print(Utils.getPossibleIps(ip, "255"));
  print(Utils.getPossibleIps(ip, "0"));
  print(Utils.getPossibleHosts(ip));
}
