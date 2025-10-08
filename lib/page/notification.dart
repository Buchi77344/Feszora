import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feszora/layout/mode.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Payment Received',
      message: 'Payment of \$1,300.00 has been received from James Peter',
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      type: NotificationType.payment,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Invoice Overdue',
      message: 'INV-2024-015 is 3 days overdue. Send a reminder to Sarah Wilson',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.overdue,
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'New Client Added',
      message: 'Mike Johnson has been added to your client list',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      type: NotificationType.client,
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Expense Alert',
      message: 'Your monthly expenses have increased by 15% compared to last month',
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.expense,
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Quotation Accepted',
      message: 'Your quotation QUO-2024-028 has been accepted by Lisa Brown',
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.quotation,
      isRead: true,
    ),
    NotificationItem(
      id: '6',
      title: 'Backup Completed',
      message: 'Your data has been successfully backed up to the cloud',
      time: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.system,
      isRead: true,
    ),
    NotificationItem(
      id: '7',
      title: 'Weekly Report',
      message: 'Your weekly business performance report is ready',
      time: DateTime.now().subtract(const Duration(days: 3)),
      type: NotificationType.report,
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _backgroundColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.blue.withOpacity(0.1),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        if (!_notifications[i].isRead) {
          _notifications[i] = _notifications[i].copyWith(isRead: true);
        }
      }
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurface.withOpacity(0.7);

    final unreadNotifications = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Enhanced App Bar
            SliverAppBar(
              backgroundColor: surfaceColor,
              surfaceTintColor: Colors.transparent,
              elevation: 2,
              shadowColor: isDarkMode ? Colors.black : Colors.black12,
              floating: true,
              snap: true,
              pinned: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: onSurfaceColor,
                  size: 24,
                ),
              ),
              title: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        color: onSurfaceColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  );
                },
              ),
              actions: [
                if (unreadNotifications > 0)
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: TextButton.icon(
                      onPressed: _markAllAsRead,
                      icon: const Icon(Icons.mark_email_read_rounded, size: 18),
                      label: const Text('Mark all read'),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
              ],
              expandedHeight: 80,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1.2,
                title: AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: child,
                    );
                  },
                  
                ),
              ),
            ),

            // Header Stats
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'You have $unreadNotifications unread notifications',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Stay updated with your business',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Notifications List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final notification = _notifications[index];
                  final delay = index * 100;
                  
                  return AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(_slideAnimation.value * 0.5, 0),
                          child: child,
                        ),
                      );
                    },
                    child: _NotificationItem(
                      notification: notification,
                      delay: delay,
                      onTap: () => _markAsRead(notification.id),
                      onDelete: () => _deleteNotification(notification.id),
                      isDarkMode: isDarkMode,
                    ),
                  );
                },
                childCount: _notifications.length,
              ),
            ),

            // Empty State
            if (_notifications.isEmpty)
              SliverFillRemaining(
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: child,
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_rounded,
                        size: 80,
                        color: onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: onSurfaceColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You\'re all caught up!',
                        style: TextStyle(
                          color: onSurfaceVariant,
                        ),
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
    );
  }
}

// Notification Item Widget
class _NotificationItem extends StatefulWidget {
  final NotificationItem notification;
  final int delay;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isDarkMode;

  const _NotificationItem({
    required this.notification,
    required this.delay,
    required this.onTap,
    required this.onDelete,
    required this.isDarkMode,
  });

  @override
  State<_NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<_NotificationItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500 + widget.delay),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Dismissible(
              key: Key(widget.notification.id),
              direction: DismissDirection.endToStart,
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(
                  Icons.delete_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              onDismissed: (direction) => widget.onDelete(),
              child: Card(
                elevation: 2,
                shadowColor: widget.isDarkMode ? Colors.black : Colors.black12,
                surfaceTintColor: Colors.transparent,
                color: widget.notification.isRead 
                    ? surfaceColor 
                    : Theme.of(context).colorScheme.primary.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: widget.notification.isRead
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Notification Icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getNotificationColor(widget.notification.type)
                                .withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getNotificationIcon(widget.notification.type),
                            color: _getNotificationColor(widget.notification.type),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.notification.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: onSurfaceColor,
                                      ),
                                    ),
                                  ),
                                  if (!widget.notification.isRead)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.notification.message,
                                style: TextStyle(
                                  color: onSurfaceVariant,
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatTime(widget.notification.time),
                                style: TextStyle(
                                  color: onSurfaceVariant,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        
                        // Action Icon
                        Icon(
                          Icons.chevron_right_rounded,
                          color: onSurfaceVariant,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.payment:
        return Icons.payment_rounded;
      case NotificationType.overdue:
        return Icons.schedule_rounded;
      case NotificationType.client:
        return Icons.person_add_rounded;
      case NotificationType.expense:
        return Icons.money_off_rounded;
      case NotificationType.quotation:
        return Icons.description_rounded;
      case NotificationType.system:
        return Icons.settings_rounded;
      case NotificationType.report:
        return Icons.analytics_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.payment:
        return Colors.green;
      case NotificationType.overdue:
        return Colors.orange;
      case NotificationType.client:
        return Colors.blue;
      case NotificationType.expense:
        return Colors.red;
      case NotificationType.quotation:
        return Colors.purple;
      case NotificationType.system:
        return Colors.grey;
      case NotificationType.report:
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}

// Data Models
enum NotificationType {
  payment,
  overdue,
  client,
  expense,
  quotation,
  system,
  report,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final NotificationType type;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? time,
    NotificationType? type,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}