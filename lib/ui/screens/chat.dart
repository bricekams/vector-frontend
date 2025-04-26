import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.20833,
            height: MediaQuery.of(context).size.height,
            color: Colors.red,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
