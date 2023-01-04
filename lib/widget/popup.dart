import 'package:flutter/material.dart';


SnackBar connectionPopup(status_color, msg1, msg2) {
  return SnackBar(
    content: Container(
      padding: EdgeInsets.all(16),
      height: 90,
      decoration: BoxDecoration(
        color: status_color,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 48),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg1,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  msg2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ]
            ),
          ),
        ]
      ),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}