import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {
  Bubble({this.message, this.time,});

  final String message, time;
  final delivered = true, isMe = false;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.white : Colors.blue.shade100;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
      topRight: Radius.circular(5.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(5.0),
    )
        : BorderRadius.only(
      topLeft: Radius.circular(5.0),
      bottomLeft: Radius.circular(5.0),
      bottomRight: Radius.circular(10.0),
    );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 1.0,
                    color: Colors.black.withOpacity(.12))
              ],
              color: bg,
              borderRadius: radius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 48.0),
                  child: Text(message),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(child: SizedBox(width: 1,),),
                    Text(time,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 10.0,
                        )),
                    SizedBox(width: 3.0),
                    Icon(
                      icon,
                      size: 12.0,
                      color: Colors.black38,
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}