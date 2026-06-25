import 'package:flutter/material.dart';

const Color kBgTopColor = Color(0xFFE5DDD9);
const Color kMutedMauve = Color(0xFFAC928B);
const Color kDeepEspresso = Color(0xFF4A1A24);

class AppDrawer extends StatelessWidget {
  final VoidCallback? onOrderHistory;
  final VoidCallback? onAbout;
  final VoidCallback? onLogout;

  const AppDrawer({
    super.key,
    this.onOrderHistory,
    this.onAbout,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    // 1. ADD THIS LINE TO CHECK THE CURRENT LANGUAGE
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return Drawer(
      backgroundColor: kBgTopColor,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: kDeepEspresso,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Fiker",
                  style: TextStyle(
                    color: kDeepEspresso,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // 2. UPDATED TO TOGGLE BETWEEN AMHARIC AND ENGLISH TEXTS
          _drawerItem(
            context,
            Icons.history,
            isAmharic ? "የትዕዛዝ ታሪክ" : "Order History",
            onOrderHistory,
          ),

          _drawerItem(
            context,
            Icons.info_outline,
            isAmharic ? "ስለ መተግበሪያው" : "About App",
            onAbout,
          ),

          const Spacer(),

          _drawerItem(
            context,
            Icons.logout,
            isAmharic ? "ውጣ" : "Logout",
            onLogout,
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  static Widget _drawerItem(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback? onTap,
      ) {
    return ListTile(
      leading: Icon(icon, color: kMutedMauve),
      title: Text(
        title,
        style: const TextStyle(
          color: kDeepEspresso,
          letterSpacing: 1,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
    );
  }
}