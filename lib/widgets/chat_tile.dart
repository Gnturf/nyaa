import 'package:flutter/material.dart';
import 'package:nyaa/models/user_profile.dart';

class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  final Function() onTap;

  const ChatTile({
    super.key,
    required this.userProfile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: false,
      leading: CircleAvatar(
        backgroundImage: Image.network(
          userProfile.pfpURL!,
        ).image,
      ),
      title: Text(userProfile.name!),
    );
  }
}
