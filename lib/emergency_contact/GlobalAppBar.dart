import 'package:flutter/material.dart';

class GlobalAppBar {
  show(
    String title,
    String subTitle,
  ) {
    //IconData icon
    return AppBar(
      toolbarHeight: 50,
      backgroundColor: Color.fromARGB(100, 0, 0, 255),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            subTitle,
            style: const TextStyle(
              color: const Color.fromRGBO(0, 10, 56, 1),
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 30.0, right: 18.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.black.withOpacity(0.4),
            ),
            // child: IconButton(
            //   icon: Icon(
            //     icon,
            //     size: 28,
            //     color: Colors.white,
            //   ),
            //   onPressed: () {},
            // ),
          ),
        )
      ],
    );
  }
}
