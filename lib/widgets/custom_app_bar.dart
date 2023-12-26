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
        // Existing actions
        if (actions != null) ...actions!,

        // Help button
        IconButton(
          icon: Icon(Icons.help_outline),
          onPressed: () {
            // Navigate to the Help page or show a dialog with help information
            Navigator.of(context).pushNamed('/help');
          },
        ),

        // Logout button
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
