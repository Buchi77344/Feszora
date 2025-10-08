import 'package:feszora/layout/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feszora/layout/mode.dart';

class DashPage extends StatefulWidget {
  const DashPage({super.key});

  @override
  State<DashPage> createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  int _currentIndex = 0;
  final PageController _pageController = PageController();

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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    
    // Theme-aware colors
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.grey[50];
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurface.withOpacity(0.7);
    final shadowColor = isDarkMode ? Colors.black : Colors.black12;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Enhanced App Bar with Animation
            SliverAppBar(
              backgroundColor: surfaceColor,
              surfaceTintColor: Colors.transparent,
              elevation: 2,
              shadowColor: shadowColor,
              floating: true,
              snap: true,
              pinned: true,
              title: Text(
                'Feszora', 
                style: TextStyle(
                  color: onSurfaceColor, 
                  fontWeight: FontWeight.bold
                ),
              ),
              centerTitle: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/notified');
                        }, 
                        icon: Icon(
                          Icons.notifications_outlined, 
                          color: onSurfaceColor,
                          size: 22,
                        )
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/notified');
                        }, 
                        icon: Icon(
                          Icons.search_outlined, 
                          color: onSurfaceColor,
                          size: 22,
                        )
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/report');
                        }, 
                        icon: Icon(
                          Icons.equalizer_outlined, 
                          color: onSurfaceColor,
                          size: 22,
                        )
                      ),
                    ],
                  ),
                )
              ],
              expandedHeight: 50,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
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

            // Welcome Section
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
                              'Welcome Back!',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Manage your business',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Here\'s your business overview',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
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
                          Icons.rocket_launch_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Quick Stats Section
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              title: 'Total Revenue',
                              amount: '\$15,240',
                              change: '+12.5%',
                              isPositive: true,
                              color: Colors.green,
                              icon: Icons.arrow_upward_rounded,
                              delay: 0,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              title: 'Pending',
                              amount: '\$1,240',
                              change: '+5.2%',
                              isPositive: false,
                              color: Colors.orange,
                              icon: Icons.pending_actions_rounded,
                              delay: 100,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              title: 'Expenses',
                              amount: '\$8,430',
                              change: '+3.1%',
                              isPositive: false,
                              color: Colors.red,
                              icon: Icons.trending_down_rounded,
                              delay: 200,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              title: 'Profit',
                              amount: '\$6,810',
                              change: '+15.7%',
                              isPositive: true,
                              color: Colors.blue,
                              icon: Icons.attach_money_rounded,
                              delay: 300,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Quick Actions Section
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Determine column count based on available width
                      int crossAxisCount;
                      double width = constraints.maxWidth;

                      if (width < 400) {
                        crossAxisCount = 2; // phones
                      } else if (width < 700) {
                        crossAxisCount = 3; // small tablets
                      } else {
                        crossAxisCount = 4; // large screens
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              'Quick Actions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: onSurfaceColor,
                              ),
                            ),
                          ),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.1,
                            children: [
                              _QuickActionButton(
                                icon: Icons.receipt_long_rounded,
                                label: 'Invoice',
                                color: Colors.green,
                                onTap: () => Navigator.pushNamed(context, '/invoice'),
                                delay: 0,
                                isDarkMode: isDarkMode,
                              ),
                              _QuickActionButton(
                                icon: Icons.description_rounded,
                                label: 'Quotation',
                                color: Colors.blue,
                                onTap: () => Navigator.pushNamed(context, '/settings'),
                                delay: 100,
                                isDarkMode: isDarkMode,
                              ),
                              _QuickActionButton(
                                icon: Icons.people_rounded,
                                label: 'Clients',
                                color: Colors.purple,
                                onTap: () => Navigator.pushNamed(context, '/invoice-list'),
                                delay: 200,
                                isDarkMode: isDarkMode,
                              ),
                              _QuickActionButton(
                                icon: Icons.money_off_rounded,
                                label: 'Expenses',
                                color: Colors.orange,
                                onTap: () => Navigator.pushNamed(context, '/expenses'),
                                delay: 300,
                                isDarkMode: isDarkMode,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

            // Recent Activity Header
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: onSurfaceColor,
                        ),
                      ),
                      Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Recent Transactions List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(_slideAnimation.value * 0.1, 0),
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: _TransactionItem(
                        transaction: _recentTransactions[index],
                        delay: index * 100,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  );
                },
                childCount: _recentTransactions.length,
              ),
            ),

            // Bottom Padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),

      // Floating Action Button for Quick Create
      floatingActionButton: ScaleTransition(
        scale: _fadeAnimation,
        child: FloatingActionButton(
          onPressed: () {
            _showCreateMenu(context, isDarkMode);
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return AnimatedBottomNav(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
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

  void _showCreateMenu(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create New',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _CreateOption(
                    icon: Icons.receipt_long_rounded,
                    label: 'New Invoice',
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/create-invoice');
                    },
                    isDarkMode: isDarkMode,
                  ),
                  _CreateOption(
                    icon: Icons.description_rounded,
                    label: 'New Quotation',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/create-quotation');
                    },
                    isDarkMode: isDarkMode,
                  ),
                  _CreateOption(
                    icon: Icons.person_add_rounded,
                    label: 'Add Client',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/add-client');
                    },
                    isDarkMode: isDarkMode,
                  ),
                  _CreateOption(
                    icon: Icons.money_off_rounded,
                    label: 'Add Expense',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/add-expense');
                    },
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

// Supporting Widgets

class _StatCard extends StatefulWidget {
  final String title;
  final String amount;
  final String change;
  final bool isPositive;
  final Color color;
  final IconData icon;
  final int delay;
  final bool isDarkMode;

  const _StatCard({
    required this.title,
    required this.amount,
    required this.change,
    required this.isPositive,
    required this.color,
    required this.icon,
    required this.delay,
    required this.isDarkMode,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500 + widget.delay),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
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

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(widget.isDarkMode ? 0.1 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.color,
                    size: 18,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.isPositive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        color: widget.isPositive ? Colors.green : Colors.red,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        widget.change,
                        style: TextStyle(
                          color: widget.isPositive ? Colors.green : Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              widget.title,
              style: TextStyle(
                color: onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.amount,
              style: TextStyle(
                color: onSurfaceColor,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final int delay;
  final bool isDarkMode;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.delay,
    required this.isDarkMode,
  });

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + widget.delay),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
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
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurface.withOpacity(0.7);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(widget.isDarkMode ? 0.1 : 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: widget.color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionItem extends StatefulWidget {
  final Transaction transaction;
  final int delay;
  final bool isDarkMode;

  const _TransactionItem({
    required this.transaction,
    required this.delay,
    required this.isDarkMode,
  });

  @override
  State<_TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<_TransactionItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + widget.delay),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
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

    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(widget.isDarkMode ? 0.05 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.transaction.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.transaction.icon,
                color: widget.transaction.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.transaction.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: onSurfaceColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.transaction.subtitle,
                    style: TextStyle(
                      color: onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.transaction.amount,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: widget.transaction.amount.startsWith('-')
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.transaction.time,
                  style: TextStyle(
                    color: onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isDarkMode;

  const _CreateOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[200]!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: onSurfaceColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Data Models
class Transaction {
  final String title;
  final String subtitle;
  final String amount;
  final String time;
  final Color color;
  final IconData icon;

  Transaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.color,
    required this.icon,
  });
}

// Sample Data
final List<Transaction> _recentTransactions = [
  Transaction(
    title: 'James Peter',
    subtitle: 'INV-2025-041 • Completed',
    amount: '\$1,300.00',
    time: '11:45 PM',
    color: Colors.green,
    icon: Icons.receipt_long_rounded,
  ),
  Transaction(
    title: 'Sarah Wilson',
    subtitle: 'QUO-2025-023 • Pending',
    amount: '\$850.00',
    time: '09:30 AM',
    color: Colors.blue,
    icon: Icons.description_rounded,
  ),
  Transaction(
    title: 'Office Supplies',
    subtitle: 'Expense • Stationery',
    amount: '-\$120.50',
    time: 'Yesterday',
    color: Colors.orange,
    icon: Icons.money_off_rounded,
  ),
  Transaction(
    title: 'Mike Johnson',
    subtitle: 'INV-2025-040 • Paid',
    amount: '\$2,500.00',
    time: '2 days ago',
    color: Colors.green,
    icon: Icons.receipt_long_rounded,
  ),
];