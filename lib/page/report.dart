import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feszora/layout/mode.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';


class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  String _selectedPeriod = 'Last 30 Days';
  final List<String> _periods = ['Last 7 Days', 'Last 30 Days', 'Last 3 Months', 'Last 6 Months', 'This Year'];
  
  final List<ChartData> _revenueData = [
    ChartData('Jan', 4500),
    ChartData('Feb', 5200),
    ChartData('Mar', 4800),
    ChartData('Apr', 6100),
    ChartData('May', 7300),
    ChartData('Jun', 6800),
  ];

  final List<ChartData> _expenseData = [
    ChartData('Jan', 3200),
    ChartData('Feb', 3800),
    ChartData('Mar', 3500),
    ChartData('Apr', 4200),
    ChartData('May', 3900),
    ChartData('Jun', 4100),
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _exportReport() {
    // Implement export functionality
    _showExportDialog();
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Report'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.file_download_rounded, size: 48, color: Colors.blue),
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
              _showSnackBar('Report exported as CSV');
            },
            child: const Text('CSV'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Report exported as PDF');
            },
            child: const Text('PDF'),
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurface.withOpacity(0.7);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Enhanced Header Section
            SliverAppBar(
              backgroundColor: surfaceColor,
              surfaceTintColor: Colors.transparent,
              elevation: 2,
              shadowColor: isDarkMode ? Colors.black : Colors.black12,
              floating: true,
              snap: true,
              pinned: true,
              leading: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: onSurfaceColor,
                          size: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
              title: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Text(
                      'Analytics Report',
                      style: TextStyle(
                        color: onSurfaceColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  );
                },
              ),
              centerTitle: false,
              actions: [
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _showFilterDialog();
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.filter_list_rounded,
                                color: onSurfaceColor,
                                size: 20,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _exportReport,
                            icon: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.download_rounded,
                                color: onSurfaceColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),

            // Date Range Selector with Animation
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDarkMode ? 0.1 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
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
                              'Reporting Period',
                              style: TextStyle(
                                color: onSurfaceVariant,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedPeriod,
                              style: TextStyle(
                                color: onSurfaceColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _showPeriodSelector,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                color: primaryColor,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Change',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Summary Cards with Staggered Animation
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _AnimatedSummaryCard(
                              title: 'Total Revenue',
                              amount: '\$12,450',
                              change: '+12.5%',
                              isPositive: true,
                              color: Colors.green,
                              icon: Icons.trending_up_rounded,
                              delay: 0,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _AnimatedSummaryCard(
                              title: 'Total Expenses',
                              amount: '\$8,230',
                              change: '+5.2%',
                              isPositive: false,
                              color: Colors.orange,
                              icon: Icons.trending_up_rounded,
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
                            child: _AnimatedSummaryCard(
                              title: 'Profit',
                              amount: '\$4,220',
                              change: '+18.3%',
                              isPositive: true,
                              color: Colors.blue,
                              icon: Icons.attach_money_rounded,
                              delay: 200,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _AnimatedSummaryCard(
                              title: 'Invoices Paid',
                              amount: '38/45',
                              change: '84.4%',
                              isPositive: true,
                              color: Colors.purple,
                              icon: Icons.receipt_rounded,
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

            // Interactive Chart Section
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
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDarkMode ? 0.1 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Revenue vs Expenses',
                            style: TextStyle(
                              color: onSurfaceColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '6 Months',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Monthly comparison overview',
                        style: TextStyle(
                          color: onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 250,
                        child: SfCartesianChart(
                          plotAreaBackgroundColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          primaryXAxis: CategoryAxis(
                            axisLine: AxisLine(color: onSurfaceVariant.withOpacity(0.3)),
                            labelStyle: TextStyle(color: onSurfaceVariant, fontSize: 10),
                          ),
                          primaryYAxis: NumericAxis(
                            numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
                            axisLine: AxisLine(color: onSurfaceVariant.withOpacity(0.3)),
                            labelStyle: TextStyle(color: onSurfaceVariant, fontSize: 10),
                          ),
                          series: <CartesianSeries>[
                            ColumnSeries<ChartData, String>(
                              dataSource: _revenueData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              name: 'Revenue',
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            ColumnSeries<ChartData, String>(
                              dataSource: _expenseData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              name: 'Expenses',
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            header: '',
                            canShowMarker: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Recent Activity Section
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
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDarkMode ? 0.1 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Transactions',
                            style: TextStyle(
                              color: onSurfaceColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'View All',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _AnimatedActivityItem(
                        icon: Icons.receipt_rounded,
                        iconColor: Colors.green,
                        title: 'Invoice #INV-0012',
                        subtitle: 'Client: John Doe • Completed',
                        amount: '\$1,200',
                        time: '2 hours ago',
                        delay: 0,
                        isDarkMode: isDarkMode,
                      ),
                      _AnimatedActivityItem(
                        icon: Icons.description_rounded,
                        iconColor: Colors.blue,
                        title: 'Quotation #QUO-0045',
                        subtitle: 'Client: Sarah Wilson • Sent',
                        amount: '\$850',
                        time: '5 hours ago',
                        delay: 100,
                        isDarkMode: isDarkMode,
                      ),
                      _AnimatedActivityItem(
                        icon: Icons.money_off_rounded,
                        iconColor: Colors.orange,
                        title: 'Office Supplies',
                        subtitle: 'Category: Office • Completed',
                        amount: '-\$120',
                        time: '1 day ago',
                        delay: 200,
                        isDarkMode: isDarkMode,
                      ),
                      _AnimatedActivityItem(
                        icon: Icons.receipt_rounded,
                        iconColor: Colors.green,
                        title: 'Invoice #INV-0011',
                        subtitle: 'Client: Mike Johnson • Paid',
                        amount: '\$2,500',
                        time: '2 days ago',
                        delay: 300,
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
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

  void _showPeriodSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
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
                'Select Period',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              ..._periods.map((period) => ListTile(
                title: Text(period),
                trailing: _selectedPeriod == period 
                    ? Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary)
                    : null,
                onTap: () {
                  setState(() => _selectedPeriod = period);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Reports'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Advanced filter options would go here...'),
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
              _showSnackBar('Filters applied');
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

// Animated Summary Card
class _AnimatedSummaryCard extends StatefulWidget {
  final String title;
  final String amount;
  final String change;
  final bool isPositive;
  final Color color;
  final IconData icon;
  final int delay;
  final bool isDarkMode;

  const _AnimatedSummaryCard({
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
  State<_AnimatedSummaryCard> createState() => _AnimatedSummaryCardState();
}

class _AnimatedSummaryCardState extends State<_AnimatedSummaryCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500 + widget.delay),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
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

    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(widget.isDarkMode ? 0.1 : 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
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
                          widget.isPositive
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
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
              const SizedBox(height: 12),
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
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Animated Activity Item
class _AnimatedActivityItem extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final String time;
  final int delay;
  final bool isDarkMode;

  const _AnimatedActivityItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.delay,
    required this.isDarkMode,
  });

  @override
  State<_AnimatedActivityItem> createState() => _AnimatedActivityItemState();
}

class _AnimatedActivityItemState extends State<_AnimatedActivityItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + widget.delay),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
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
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: onSurfaceColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
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
                    widget.amount,
                    style: TextStyle(
                      color: widget.amount.startsWith('-')
                          ? Colors.red
                          : Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.time,
                    style: TextStyle(
                      color: onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data Models
class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}