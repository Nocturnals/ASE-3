import 'package:flutter/material.dart';
import 'package:pet_app/petService/model/user.dart';
import 'package:pet_app/petService/services/chat/chat_service.dart';
import 'package:pet_app/petService/services/services.dart';
import 'package:pet_app/petService/widgets/empty_chat_overview.dart';
import 'package:pet_app/widgets/loader.dart';

import 'chat_list_view.dart';

class ChatsOverviewPage extends StatefulWidget {
  @override
  _ChatsOverviewPageState createState() => _ChatsOverviewPageState();
}

class _ChatsOverviewPageState extends State<ChatsOverviewPage> {
  ChatService _chatService = services.get<ChatService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Chats"),
      ),
      body: FutureBuilder(
        future: _chatService.getChattedUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<User> users = snapshot.data;
            if (users.isNotEmpty)
              return Flex(
                direction: Axis.vertical,
                children: [
                  ChatListView(
                    userList: users,
                  ),
                ],
              );
            else
              return EmptyChatOverview();
          }
          return Center(
            child: Loader(),
          );
        },
      ),
    );
  }
}
