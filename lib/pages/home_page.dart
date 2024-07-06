import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nyaa/models/user_profile.dart';
import 'package:nyaa/pages/chat_page.dart';
import 'package:nyaa/services/alert_service.dart';
import 'package:nyaa/services/auth_service.dart';
import 'package:nyaa/services/database_service.dart';
import 'package:nyaa/services/navigation_service.dart';
import 'package:nyaa/widgets/chat_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await _authService.logout();
              if (result) {
                _alertService.showToast(
                  text: "Successfully LogOut",
                  icon: Icons.check_circle_rounded,
                );
                _navigationService.pushReplacementNamed("/login");
              } else {
                _alertService.showToast(
                  text: "Log Out Failed, Please Try Again",
                  icon: Icons.error,
                );
              }
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: _chatList(),
      ),
    );
  }

  Widget _chatList() {
    return StreamBuilder(
      stream: _databaseService.getUserProfile(),
      builder: (context, snapshot) {
        print("---------- ${snapshot.data} ----------");
        if (snapshot.hasError) {
          return const Center(
            child: Text("Unable To Load Data"),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserProfile user = users[index].data();
              return ChatTile(
                userProfile: user,
                onTap: () async {
                  final chatExist = await _databaseService.checkChatExist(
                    _authService.user!.uid,
                    user.uid!,
                  );

                  if (!chatExist) {
                    await _databaseService.createNewChat(
                      _authService.user!.uid,
                      user.uid!,
                    );
                  }

                  _navigationService.push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ChatPage(chatuser: user);
                      },
                    ),
                  );
                },
              );
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
