import 'package:flutter/material.dart';
import 'package:flutter_ds/request.dart';
import 'package:flutter_ds/tree.dart';
import 'package:flutter_ds/unlock_shortly_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreenSpace extends StatefulWidget {
  final String id;

  const ScreenSpace({super.key, required this.id});

  @override
  State<ScreenSpace> createState() => _StateScreenSpace();
}

class _StateScreenSpace extends State<ScreenSpace> {
  late Future<Tree> futureTree;

  @override
  void initState() {
    super.initState();
    futureTree = getTree(widget.id);
    futureTree.then((tree) {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tree>(
      future: futureTree,
      builder: (context, snapshot) {
        // anonymous function
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.orange),
              backgroundColor: Colors.transparent,
              bottom: PreferredSize(
                  child: Container(
                    color: Colors.orange,
                    height: 3.5,
                  ),
                  preferredSize: Size.fromHeight(4.0)),
              title: Text(
                snapshot.data!.root.id,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.orange,
                    fontSize: 18),
              ),
              actions: <Widget>[
                IconButton(
                    icon:
                        const Icon(Icons.home, color: Colors.orange, size: 22),
                    onPressed: () {
                      while (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    }),
              ],
            ),
            body: ListView.separated(
              // it's like ListView.builder() but better because it includes a separator between items
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.root.getDoors().length,
              itemBuilder: (BuildContext context, int i) =>
                  _buildRow(snapshot.data!.root.getDoors()[i], i),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a progress indicator
        return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
  }

  Widget _buildRow(Door door, int index) {
    IconButton lock_unlock = door.state == "locked"
        ? IconButton(
            onPressed: () {
              unlockDoor(door);
              Future.delayed(const Duration(milliseconds: 150), () {
                futureTree = getTree(widget.id);
                setState(() {});
              });
            },
            icon: Icon(
              Icons.lock_outline_rounded,
              color: Colors.red,
            ),
          )
        : IconButton(
            onPressed: () {
              if (door.closed == false) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                          AppLocalizations.of(context)!.popup_door_lock_title),
                      content: Text(AppLocalizations.of(context)!
                          .popup_door_lock_content),
                    );
                  },
                );
              } else {
                lockDoor(door);
                Future.delayed(const Duration(milliseconds: 150), () {
                  futureTree = getTree(widget.id);
                  setState(() {});
                });
              }
            },
            icon: Icon(
              Icons.lock_open_rounded,
              color: Colors.green,
            ),
          );

    IconButton open_close = door.closed == false
        ? IconButton(
            onPressed: () {
              closeDoor(door);
              Future.delayed(const Duration(milliseconds: 150), () {
                futureTree = getTree(widget.id);
                setState(() {});
              });
            },
            icon: Icon(
              Icons.meeting_room_outlined,
              color: Colors.green,
            ),
          )
        : IconButton(
            onPressed: () {
              if (door.state == "locked") {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                          AppLocalizations.of(context)!.popup_door_open_title),
                      content: Text(AppLocalizations.of(context)!
                          .popup_door_open_content),
                    );
                  },
                );
              } else {
                openDoor(door);
                Future.delayed(const Duration(milliseconds: 150), () {
                  futureTree = getTree(widget.id);
                  setState(() {});
                });
              }
            },
            icon: Icon(
              Icons.door_front_door_outlined,
              color: Colors.red,
            ),
          );

    IconButton unlockShortly = IconButton(
        onPressed: () {
          if (door.state != "locked") {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!
                        .popup_door_unlock_shortly_title),
                    content: Text(AppLocalizations.of(context)!
                        .popup_door_unlock_shortly_content),
                  );
                });
          } else {
            unlockShortlyDoor(door, "unlock_shortly");
            Future.delayed(const Duration(milliseconds: 150), () {
              futureTree = getTree(widget.id);
              setState(() {});
            });

            Future.delayed(const Duration(milliseconds: 10100), () {
              futureTree = getTree(widget.id);
              setState(() {});
            });
          }
        },
        icon: Icon(Icons.lock_clock_outlined, color: Colors.blue));

    return ListTile(
        title: Text('${door.id}'),
        trailing: Wrap(
          spacing: 12,
          children: <Widget>[
            open_close,
            lock_unlock,
            IconChangeButton(
              door: door,
              originalIcon: Icon(Icons.lock_clock_outlined, color: Colors.blue),
            )
          ],
        ));
  }
}
