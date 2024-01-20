import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'tree.dart';
import 'package:intl/intl.dart';

// add intl: ^0.19.0 under dependencies: in pubspec.yaml
// this is to get class DateFormat, see https://pub.dev/packages/intl
final DateFormat DATEFORMATTER = DateFormat('yyyy-MM-ddThh:mm');
// the format Webserver wants

const String BASE_URL = "http://localhost:8080";
Future<String> sendRequest(Uri uri) async {
  final response = await http.get(uri);
// response is NOT a Future because of await
  if (response.statusCode == 200) {
    // server returns an OK response
    print("statusCode=$response.statusCode");
    print(response.body);
    return response.body;
  } else {
    print("statusCode=$response.statusCode");
    throw Exception('failed to get answer to request $uri');
  }
}

Future<Tree> getTree(String areaId) async {
  Uri uri = Uri.parse("${BASE_URL}/get_children?$areaId");
  final String responseBody = await sendRequest(uri);
  Map<String, dynamic> decoded = convert.jsonDecode(responseBody);
  return Tree(decoded);
}

Future<void> lockArea(Area area) async {
  lockUnlockArea(area, 'lock');
}

Future<void> unlockShortly(Door door) async {
  unlockShortlyDoor(door, 'lock');
}

Future<void> unlockArea(Area area) async {
  lockUnlockArea(area, 'unlock');
}

Future<void> lockDoor(Door door) async {
  lockUnlockDoor(door, 'lock');
}

Future<void> unlockDoor(Door door) async {
  lockUnlockDoor(door, 'unlock');
}

Future<void> openDoor(Door door) async {
  openCloseDoor(door, 'open');
}

Future<void> closeDoor(Door door) async {
  openCloseDoor(door, 'close');
}

Future<void> unlockShortlyDoor(Door door, String action) async {
// From the simulator : when asking to lock door D1, of parking, the request is
// http://localhost:8080/reader?credential=11343&action=lock
// &datetime=2023-12-08T09:30&doorId=D1
  assert(action == 'unlock_shortly');
  String strNow = DATEFORMATTER.format(DateTime.now());
  print(strNow);
  Uri uri = Uri.parse("${BASE_URL}/reader?credential=11343&action=$action"
      "&datetime=$strNow&doorId=${door.id}");
// credential 11343 corresponds to user Ana of Administrator group
  print('lock ${door.id}, uri $uri');
  final String responseBody = await sendRequest(uri);
  print('requests.dart : door ${door.id} is ${door.state}');
}

Future<void> lockUnlockArea(Area area, String action) async {
// From the simulator : when asking to lock door D1, of parking, the request is
// http://localhost:8080/reader?credential=11343&action=lock
// &datetime=2023-12-08T09:30&doorId=D1
  assert((action == 'lock') | (action == 'unlock'));
  String strNow = DATEFORMATTER.format(DateTime.now());
  print(strNow);
  Uri uri = Uri.parse("${BASE_URL}/area?credential=11343&action=$action"
      "&datetime=$strNow&areaId=${area.id}");
// credential 11343 corresponds to user Ana of Administrator group
  print('lock ${area.id}, uri $uri');
  final String responseBody = await sendRequest(uri);
  print('requests.dart : area ${area.id} is ${action}');
}

Future<void> openCloseDoor(Door door, String action) async {
// From the simulator : when asking to lock door D1, of parking, the request is
// http://localhost:8080/reader?credential=11343&action=lock
// &datetime=2023-12-08T09:30&doorId=D1
  assert((action == 'open') | (action == 'close'));
  String strNow = DATEFORMATTER.format(DateTime.now());
  print(strNow);
  Uri uri = Uri.parse("${BASE_URL}/reader?credential=11343&action=$action"
      "&datetime=$strNow&doorId=${door.id}");
// credential 11343 corresponds to user Ana of Administrator group
  print('lock ${door.id}, uri $uri');
  final String responseBody = await sendRequest(uri);
  print('requests.dart : door ${door.id} is ${door.state}');
}

Future<void> lockUnlockDoor(Door door, String action) async {
// From the simulator : when asking to lock door D1, of parking, the request is
// http://localhost:8080/reader?credential=11343&action=lock
// &datetime=2023-12-08T09:30&doorId=D1
  assert((action == 'lock') | (action == 'unlock'));
  String strNow = DATEFORMATTER.format(DateTime.now());
  print(strNow);
  Uri uri = Uri.parse("${BASE_URL}/reader?credential=11343&action=$action"
      "&datetime=$strNow&doorId=${door.id}");
// credential 11343 corresponds to user Ana of Administrator group
  print('lock ${door.id}, uri $uri');
  final String responseBody = await sendRequest(uri);
  print('requests.dart : door ${door.id} is ${door.state}');
}
