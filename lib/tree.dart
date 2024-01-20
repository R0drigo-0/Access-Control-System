late int nLockedDoors;

abstract class Area {
  final String id;
  final List<Area> children;

  Area(this.id, this.children);
  getDoors() {}
  getNumberLockedDoors() {}
}

class Partition extends Area {
  Partition(String id, List<Area> children) : super(id, children);
  @override
  getDoors() {}
  @override
  int getNumberLockedDoors() {
    int nDoors = 0;
    for (Area a in children) {
      if (a is Space) {
        nDoors += a.getNumberLockedDoors();
      }
    }
    return nDoors;
  }
}

class Space extends Area {
  final List<Door> doors;

  Space(String id, this.doors) : super(id, []);
  getDoors() {
    return doors;
  }

  @override
  int getNumberLockedDoors() {
    int nLockedDoors = 0;
    print(doors.length);
    for (Door d in doors) {
      print(d.state);
      if (d.state == "locked") {
        nLockedDoors += 1;
      }
    }
    return nLockedDoors;
  }
}

class Door {
  final String id;
  String state;
  bool closed;

  Door({required this.id, required this.state, required this.closed});
}

class Tree {
  late Area root;

  Area getRoot() {
    return root;
  }

  Tree(Map<String, dynamic> dec) {
    // 1 level tree, root and children only, root is either Partition or Space.
    // If Partition children are Partition or Space, that is, Area. If root
    // is a Space, children are Door.
    // There is a JSON field 'class' that tells the type of Area.
    if (dec['class'] == "partition") {
      List<Area> children = <Area>[]; // is growable
      for (Map<String, dynamic> area in dec['areas']) {
        if (area['class'] == "partition") {
          children.add(Partition(area['id'], <Area>[]));
        } else if (area['class'] == "space") {
          children.add(Space(area['id'], <Door>[]));
        } else {
          assert(false);
        }
      }
      root = Partition(dec['id'], children);
    } else if (dec['class'] == "space") {
      List<Door> children = <Door>[];
      for (Map<String, dynamic> d in dec['access_doors']) {
        children.add(Door(id: d['id'], state: d['state'], closed: d['closed']));
      }
      root = Space(dec['id'], children);
    } else {
      assert(false);
    }
  }
}
