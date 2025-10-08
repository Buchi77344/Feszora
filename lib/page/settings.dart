import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feszora/layout/mode.dart';
import 'package:feszora/layout/navigation.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // Settings state
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _autoBackupEnabled = true;
  String _currency = 'USD';
  String _language = 'English';
  String _dateFormat = 'MM/dd/yyyy';

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD'];
  final List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Japanese'];
  final List<String> _dateFormats = ['MM/dd/yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd', 'MMMM dd, yyyy'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup Data'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_upload_rounded, size: 48, color: Colors.blue),
            SizedBox(height: 16),
            Text('Your data will be backed up securely to the cloud.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Backup completed successfully!');
            },
            child: const Text('Backup Now'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.file_download_rounded, size: 48, color: Colors.green),
            SizedBox(height: 16),
            Text('Choose export format:'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Data exported as CSV');
            },
            child: const Text('CSV'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Data exported as PDF');
            },
            child: const Text('PDF'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              surfaceTintColor: Colors.transparent,
              elevation: 2,
              shadowColor: isDarkMode ? Colors.black : Colors.black12,
              pinned: true,
              title: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: const Text(
                      'Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  );
                },
              ),
              centerTitle: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.help_outline_rounded),
                  ),
                ),
              ],
            ),

            // Profile Section
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDarkMode
                          ? [Colors.blue[800]!, Colors.purple[800]!]
                          : [Colors.blue[700]!, Colors.purple[700]!],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'John Doe',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'john.doe@example.com',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Premium Plan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_rounded, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Appearance Section
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.5),
                      child: child,
                    ),
                  );
                },
                child: _SettingsSection(
                  title: 'Appearance',
                  icon: Icons.palette_rounded,
                  children: [
                    _SettingTile(
                      icon: Icons.light_mode_rounded,
                      title: 'Theme Mode',
                      subtitle: isDarkMode ? 'Dark' : 'Light',
                      trailing: Switch.adaptive(
                        value: isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                      ),
                      onTap: () {
                        themeProvider.toggleTheme();
                      },
                    ),
                    _SettingTile(
                      icon: Icons.language_rounded,
                      title: 'Language',
                      subtitle: _language,
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        _showLanguagePicker();
                      },
                    ),
                    _SettingTile(
                      icon: Icons.date_range_rounded,
                      title: 'Date Format',
                      subtitle: _dateFormat,
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        _showDateFormatPicker();
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Preferences Section
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.4),
                      child: child,
                    ),
                  );
                },
                child: _SettingsSection(
                  title: 'Preferences',
                  icon: Icons.settings_rounded,
                  children: [
                    _SettingTile(
                      icon: Icons.currency_exchange_rounded,
                      title: 'Currency',
                      subtitle: _currency,
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        _showCurrencyPicker();
                      },
                    ),
                    _SettingTile(
                      icon: Icons.notifications_rounded,
                      title: 'Push Notifications',
                      subtitle: 'Receive important updates',
                      trailing: Switch.adaptive(
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() => _notificationsEnabled = value);
                          _showSnackBar(value ? 'Notifications enabled' : 'Notifications disabled');
                        },
                      ),
                    ),
                    _SettingTile(
                      icon: Icons.fingerprint_rounded,
                      title: 'Biometric Login',
                      subtitle: 'Use fingerprint or face ID',
                      trailing: Switch.adaptive(
                        value: _biometricEnabled,
                        onChanged: (value) {
                          setState(() => _biometricEnabled = value);
                          _showSnackBar(value ? 'Biometric login enabled' : 'Biometric login disabled');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Data Management Section
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.3),
                      child: child,
                    ),
                  );
                },
                child: _SettingsSection(
                  title: 'Data Management',
                  icon: Icons.storage_rounded,
                  children: [
                    _SettingTile(
                      icon: Icons.backup_rounded,
                      title: 'Auto Backup',
                      subtitle: 'Backup data automatically',
                      trailing: Switch.adaptive(
                        value: _autoBackupEnabled,
                        onChanged: (value) {
                          setState(() => _autoBackupEnabled = value);
                        },
                      ),
                    ),
                    _SettingTile(
                      icon: Icons.cloud_upload_rounded,
                      title: 'Backup Now',
                      subtitle: 'Create manual backup',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _showBackupDialog,
                    ),
                    _SettingTile(
                      icon: Icons.file_download_rounded,
                      title: 'Export Data',
                      subtitle: 'Export as CSV or PDF',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _showExportDialog,
                    ),
                    _SettingTile(
                      icon: Icons.delete_outline_rounded,
                      title: 'Clear Cache',
                      subtitle: 'Free up storage space',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        _showSnackBar('Cache cleared successfully');
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Support Section
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.2),
                      child: child,
                    ),
                  );
                },
                child: _SettingsSection(
                  title: 'Support',
                  icon: Icons.help_rounded,
                  children: [
                    _SettingTile(
                      icon: Icons.help_center_rounded,
                      title: 'Help Center',
                      subtitle: 'Get help and documentation',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {},
                    ),
                    _SettingTile(
                      icon: Icons.feedback_rounded,
                      title: 'Send Feedback',
                      subtitle: 'Share your thoughts with us',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {},
                    ),
                    _SettingTile(
                      icon: Icons.security_rounded,
                      title: 'Privacy Policy',
                      subtitle: 'Learn about our privacy practices',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {},
                    ),
                    _SettingTile(
                      icon: Icons.description_rounded,
                      title: 'Terms of Service',
                      subtitle: 'Read our terms and conditions',
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // Account Section
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: child,
                  );
                },
                child: _SettingsSection(
                  title: 'Account',
                  icon: Icons.person_rounded,
                  children: [
                    _SettingTile(
                      icon: Icons.logout_rounded,
                      title: 'Sign Out',
                      subtitle: 'Sign out of your account',
                      titleColor: Colors.red,
                      trailing: Icon(Icons.chevron_right_rounded, color: Colors.red.withOpacity(0.7)),
                      onTap: () {
                        _showSignOutDialog();
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return AnimatedBottomNav(
            currentIndex: 3, // Settings index
            onTap: (index) {
              // Handle navigation
            },
            items: const [
              NavItem(
                icon: Icons.dashboard_rounded,
                label: 'Home',
                routeName: '/dashboard',
              ),
              NavItem(
                icon: Icons.receipt_long_rounded,
                label: 'Invoices',
                routeName: '/invoices',
              ),
              NavItem(
                icon: Icons.people_alt_rounded,
                label: 'Clients',
                routeName: '/clients',
              ),
              NavItem(
                icon: Icons.settings_rounded,
                label: 'Settings',
                routeName: '/settings',
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Language',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ..._languages.map((language) => ListTile(
                    title: Text(language),
                    trailing: _language == language ? const Icon(Icons.check_rounded, color: Colors.blue) : null,
                    onTap: () {
                      setState(() => _language = language);
                      Navigator.pop(context);
                      _showSnackBar('Language changed to $language');
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Currency',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ..._currencies.map((currency) => ListTile(
                    title: Text(currency),
                    trailing: _currency == currency ? const Icon(Icons.check_rounded, color: Colors.blue) : null,
                    onTap: () {
                      setState(() => _currency = currency);
                      Navigator.pop(context);
                      _showSnackBar('Currency changed to $currency');
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  void _showDateFormatPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Date Format',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ..._dateFormats.map((format) => ListTile(
                    title: Text(format),
                    trailing: _dateFormat == format ? const Icon(Icons.check_rounded, color: Colors.blue) : null,
                    onTap: () {
                      setState(() => _dateFormat = format);
                      Navigator.pop(context);
                      _showSnackBar('Date format changed');
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Signed out successfully');
              // Add your sign out logic here
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

// Supporting Widgets

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 8),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: children),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: titleColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          fontSize: 12,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}