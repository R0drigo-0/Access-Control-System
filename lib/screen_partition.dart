import 'package:flutter/material.dart';
import 'package:flutter_ds/request.dart';
import 'package:flutter_ds/screen_space.dart';
import 'package:flutter_ds/tree.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreenPartition extends StatefulWidget {
  final String id;

  const ScreenPartition({super.key, required this.id});

  @override
  State<ScreenPartition> createState() => _ScreenPartitionState();
}

class _ScreenPartitionState extends State<ScreenPartition> {
  late Future<Tree> futureTree;

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
                    icon: const Icon(
                      Icons.home,
                      color: Colors.orange,
                      size: 22,
                    ),
                    onPressed: () {
                      while (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    }),
                //TODO other actions
              ],
            ),
            body: ListView.separated(
              // it's like ListView.builder() but better because it includes a separator between items
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.root.children.length,
              itemBuilder: (BuildContext context, int i) =>
                  _buildRow(snapshot.data!.root.children[i], i),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
            persistentFooterButtons: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                FloatingActionButton.extended(
                  backgroundColor: Theme.of(context).bottomAppBarTheme.color,
                  onPressed: () {
                    setState(() {
                      nLockedDoors = 9;
                    });
                    for (Area a in snapshot.data!.root.children) {
                      lockArea(a);
                    }
                  },
                  label: Container(
                      alignment: Alignment.center,
                      width: 120,
                      child: Text(AppLocalizations.of(context)!.lock_all,
                          style: TextStyle(fontWeight: FontWeight.w700))),
                ),
                FloatingActionButton.extended(
                  backgroundColor: Theme.of(context).bottomAppBarTheme.color,
                  onPressed: () {
                    setState(() {
                      nLockedDoors = 0;
                    });

                    for (Area a in snapshot.data!.root.children) {
                      unlockArea(a);
                    }
                  },
                  label: Container(
                      alignment: Alignment.center,
                      width: 120,
                      child: Text(AppLocalizations.of(context)!.unlock_all,
                          style: TextStyle(fontWeight: FontWeight.w700))),
                ),
              ])
            ],
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

  int getNumberLockedDoors(Area area, int tmpLockedDoors) {
    int tmp = tmpLockedDoors;
    for (Area area in area.children) {
      if (area is Space) {
        if (area.children.length != 0) {
          return getNumberLockedDoors(area, tmp);
        } else {
          for (Door door in area.doors) {
            if (door.state == "locked") tmp++;
          }
        }
      }
      return tmp;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    futureTree = getTree(widget.id);
  }

  Widget _buildRow(Area area, int index) {
    IconButton IconLockArea = IconButton(
      onPressed: () {
        lockArea(area);
        Future.delayed(const Duration(milliseconds: 150), () {
          futureTree = getTree(widget.id);
          setState(() {});
        });
      },
      icon: Icon(
        Icons.lock_outline_rounded,
        color: Colors.red,
      ),
    );

    IconButton IconUnlockArea = IconButton(
      onPressed: () {
        unlockArea(area);
        Future.delayed(const Duration(milliseconds: 150), () {
          futureTree = getTree(widget.id);
          setState(() {});
        });
      },
      icon: Icon(
        Icons.lock_open_rounded,
        color: Colors.green,
      ),
    );

    if (area is Partition) {
      return ListTile(
        title: Text(
          'P ${area.id}',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
            AppLocalizations.of(context)!.locked_doors + "${nLockedDoors}"),
        onTap: () => _navigateDownPartition(area.id),
        trailing: Wrap(
          spacing: 12,
          children: <Widget>[IconLockArea, IconUnlockArea],
        ),
        // TODO, navigate down to show children areas
      );
    } else {
      return ListTile(
        title: Text('S ${area.id}'),
        subtitle: Text(
            AppLocalizations.of(context)!.locked_doors + "${nLockedDoors}"),
        onTap: () => _navigateDownSpace(area.id),
        trailing: Wrap(
          spacing: 12,
          children: <Widget>[IconLockArea, IconUnlockArea],
        ),
        // TODO, navigate down to show children doors
      );
    }
  }

  void _navigateDownPartition(String childId) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (context) => ScreenPartition(
              id: childId,
            )));
  }

  void _navigateDownSpace(String childId) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (context) => ScreenSpace(
              id: childId,
            )));
  }
}
