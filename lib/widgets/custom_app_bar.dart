import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;

  CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onBackButtonPressed ??
                  () {
                    Navigator.of(context).pop();
                  },
            )
          : null,
      actions: <Widget>[
        // Check if actions is not null before spreading it
        if (actions != null) ...actions!,
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            await Provider.of<AuthService>(context, listen: false).logout();
            Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
