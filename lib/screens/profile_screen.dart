
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const SizedBox(height: 15),

          // Profile information
          Center(
            child: Column(
              children: [
                Container(
                  width: 105,
                  height: 105,
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.butterYellow,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person_rounded,
                          size: 60,
                          color: AppTheme.navy,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Amanda Damayanti',
                  style: TextStyle(
                    color: AppTheme.navy,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'amanda@email.com',
                  style: TextStyle(
                    color: AppTheme.muted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 35),

          const Text(
            'Account',
            style: TextStyle(
              color: AppTheme.navy,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          _profileMenu(
            icon: Icons.person_outline_rounded,
            title: 'Personal Information',
            subtitle: 'Manage your profile details',
            onTap: () {
              _showMessage(context, 'Personal Information');
            },
          ),

          _profileMenu(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            subtitle: 'Manage your notifications',
            onTap: () {
              _showMessage(context, 'Notifications');
            },
          ),

          _profileMenu(
            icon: Icons.lock_outline_rounded,
            title: 'Privacy & Security',
            subtitle: 'Keep your account secure',
            onTap: () {
              _showMessage(context, 'Privacy & Security');
            },
          ),

          const SizedBox(height: 25),

          const Text(
            'About',
            style: TextStyle(
              color: AppTheme.navy,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          _profileMenu(
            icon: Icons.info_outline_rounded,
            title: 'About Amaraga',
            subtitle: 'Your personal finance companion',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Amaraga',
                applicationVersion: '1.0.0',
                applicationLegalese: 'Personal Finance Management App',
              );
            },
          ),

          const SizedBox(height: 25),

          Center(
            child: Text(
              'AMARAGA • VERSION 1.0.0',
              style: TextStyle(
                color: AppTheme.muted,
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileMenu({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppTheme.butterYellow.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: AppTheme.navy,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppTheme.navy,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppTheme.muted,
            fontSize: 11,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppTheme.muted,
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title feature is coming soon.'),
      ),
    );
  }
}
