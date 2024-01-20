import 'package:flutter/material.dart';
import 'package:flutter_ds/request.dart';
import 'package:flutter_ds/tree.dart';
import 'package:material_symbols_icons/symbols.dart';

class IconChangeButton extends StatefulWidget {
  final Door door;
  final Icon originalIcon;

  IconChangeButton({
    required this.door,
    required this.originalIcon,
  });

  @override
  _IconChangeButtonState createState() => _IconChangeButtonState();
}

class _IconChangeButtonState extends State<IconChangeButton> {
  Icon currentIcon = Icon(Icons.lock_clock_outlined, color: Colors.blue);
  bool iconChanged = false;

  @override
  Widget build(BuildContext context) {
    const dynamic counterSymbols = [
      Symbols.counter_9_rounded,
      Symbols.counter_8_rounded,
      Symbols.counter_7_rounded,
      Symbols.counter_6_rounded,
      Symbols.counter_5_rounded,
      Symbols.counter_4_rounded,
      Symbols.counter_3_rounded,
      Symbols.counter_2_rounded,
      Symbols.counter_1_rounded,
    ];
    int i = 0;
    return IconButton(
        icon: currentIcon,
        onPressed: () async {
          if (!iconChanged && widget.door.state == "locked") {
            if (!iconChanged) {
              unlockShortlyDoor(widget.door, "unlock_shortly");
              setState(() {
                iconChanged = true;
                widget.door.state = "unlocked_shortly";
                widget.door.closed = true;
              });
            }
            while (i < 10) {
              setState(() {
                if (i < 9) {
                  currentIcon = Icon(counterSymbols[i]);
                  widget.door.state = "unlocked_shortly";
                } else {
                  setState(() {
                    iconChanged = false;
                    currentIcon = widget.originalIcon;
                    widget.door.state = "locked";
                  });
                }
              });
              await Future.delayed(Duration(seconds: 1), () => ++i);
            }
          }
        });
  }
}
