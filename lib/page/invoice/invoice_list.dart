import 'package:feszora/layout/navigation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:feszora/layout/mode.dart';

class InvoiceListPage extends StatefulWidget {
  const InvoiceListPage({super.key});

  @override
  State<InvoiceListPage> createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final List<Invoice> _invoices = [
    Invoice(
      id: '1',
      number: 'INV-2024-001',
      clientName: 'James Peter',
      amount: 2300.00,
      dueDate: DateTime.now().add(const Duration(days: 15)),
      status: InvoiceStatus.paid,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      items: 3,
    ),
    Invoice(
      id: '2',
      number: 'INV-2024-002',
      clientName: 'Sarah Wilson',
      amount: 1500.00,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      status: InvoiceStatus.overdue,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      items: 2,
    ),
    Invoice(
      id: '3',
      number: 'INV-2024-003',
      clientName: 'Mike Johnson',
      amount: 3200.00,
      dueDate: DateTime.now().add(const Duration(days: 30)),
      status: InvoiceStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      items: 4,
    ),
    Invoice(
      id: '4',
      number: 'INV-2024-004',
      clientName: 'Lisa Brown',
      amount: 850.00,
      dueDate: DateTime.now().add(const Duration(days: 20)),
      status: InvoiceStatus.draft,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      items: 1,
    ),
    Invoice(
      id: '5',
      number: 'INV-2024-005',
      clientName: 'David Miller',
      amount: 4200.00,
      dueDate: DateTime.now().subtract(const Duration(days: 5)),
      status: InvoiceStatus.paid,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      items: 5,
    ),
  ];

  String _filterStatus = 'All';
  String _searchQuery = '';
  final List<String> _statusFilters = ['All', 'Paid', 'Pending', 'Overdue', 'Draft'];
  bool _isSearching = false;

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

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
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

  List<Invoice> get _filteredInvoices {
    var filtered = _invoices;

    // Apply status filter
    if (_filterStatus != 'All') {
      filtered = filtered.where((invoice) {
        switch (_filterStatus) {
          case 'Paid':
            return invoice.status == InvoiceStatus.paid;
          case 'Pending':
            return invoice.status == InvoiceStatus.pending;
          case 'Overdue':
            return invoice.status == InvoiceStatus.overdue;
          case 'Draft':
            return invoice.status == InvoiceStatus.draft;
          default:
            return true;
        }
      }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((invoice) =>
          invoice.number.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          invoice.clientName.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return filtered;
  }

  double get _totalRevenue {
    return _invoices
        .where((invoice) => invoice.status == InvoiceStatus.paid)
        .fold(0.0, (sum, invoice) => sum + invoice.amount);
  }

  int get _overdueInvoices {
    return _invoices.where((invoice) => invoice.status == InvoiceStatus.overdue).length;
  }

  int get _pendingInvoices {
    return _invoices.where((invoice) => invoice.status == InvoiceStatus.pending).length;
  }

  void _createNewInvoice() {
    // Navigate to create invoice page
    Navigator.pushNamed(context, '/create-invoice');
  }

  void _viewInvoiceDetails(Invoice invoice) {
    // Navigate to invoice details page
    Navigator.pushNamed(context, '/invoice-details', arguments: invoice);
  }

  void _editInvoice(Invoice invoice) {
    // Navigate to edit invoice page
    Navigator.pushNamed(context, '/edit-invoice', arguments: invoice);
  }

  void _deleteInvoice(String invoiceId) {
    setState(() {
      _invoices.removeWhere((invoice) => invoice.id == invoiceId);
    });
    _showSnackBar('Invoice deleted successfully');
  }

  void _sendInvoiceReminder(Invoice invoice) {
    _showConfirmationDialog(
      'Send Reminder',
      'Send payment reminder to ${invoice.clientName}?',
      () {
        _showSnackBar('Reminder sent to ${invoice.clientName}');
      },
    );
  }

  void _markAsPaid(Invoice invoice) {
    setState(() {
      final index = _invoices.indexWhere((inv) => inv.id == invoice.id);
      if (index != -1) {
        _invoices[index] = _invoices[index].copyWith(status: InvoiceStatus.paid);
      }
    });
    _showSnackBar('Invoice marked as paid');
  }

  void _duplicateInvoice(Invoice invoice) {
    final newInvoice = invoice.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      number: 'INV-${DateTime.now().year}-${_invoices.length + 1}',
      status: InvoiceStatus.draft,
      createdAt: DateTime.now(),
    );
    setState(() {
      _invoices.insert(0, newInvoice);
    });
    _showSnackBar('Invoice duplicated successfully');
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Invoices',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            ..._statusFilters.map((status) => ListTile(
                  title: Text(status),
                  trailing: _filterStatus == status
                      ? Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () {
                    setState(() => _filterStatus = status);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirm'),
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

  void _exportInvoices() {
    _showConfirmationDialog(
      'Export Invoices',
      'Export all invoices as CSV file?',
      () {
        _showSnackBar('Invoices exported successfully');
      },
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
      floatingActionButton: ScaleTransition(
        scale: _fadeAnimation,
        child: FloatingActionButton(
          onPressed: _createNewInvoice,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
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
              title: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Text(
                      'Invoices',
                      style: TextStyle(
                        color: onSurfaceColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
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
                              setState(() => _isSearching = !_isSearching);
                              if (!_isSearching) _searchQuery = '';
                            },
                            icon: Icon(_isSearching ? Icons.close_rounded : Icons.search_rounded, color: onSurfaceColor),
                          ),
                          IconButton(
                            onPressed: _showFilterDialog,
                            icon: Icon(Icons.filter_list_rounded, color: onSurfaceColor),
                          ),
                          IconButton(
                            onPressed: _exportInvoices,
                            icon: Icon(Icons.download_rounded, color: onSurfaceColor),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),

            // Search Bar
            if (_isSearching)
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDarkMode ? 0.1 : 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (value) => setState(() => _searchQuery = value),
                          decoration: InputDecoration(
                            hintText: 'Search invoices...',
                            border: InputBorder.none,
                            icon: Icon(Icons.search_rounded, color: onSurfaceVariant),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear_rounded, color: onSurfaceVariant),
                                    onPressed: () => setState(() => _searchQuery = ''),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Stats Overview
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
                              'Invoice Overview',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_invoices.length} Total Invoices',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${_totalRevenue.toStringAsFixed(2)} Revenue',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          _StatChip(
                            value: _pendingInvoices.toString(),
                            label: 'Pending',
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 8),
                          _StatChip(
                            value: _overdueInvoices.toString(),
                            label: 'Overdue',
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Filter Chip Bar
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.5),
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _statusFilters.map((status) {
                            final isSelected = _filterStatus == status;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(status),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() => _filterStatus = selected ? status : 'All');
                                },
                                backgroundColor: isSelected ? primaryColor.withOpacity(0.1) : surfaceColor,
                                selectedColor: primaryColor.withOpacity(0.2),
                                checkmarkColor: primaryColor,
                                labelStyle: TextStyle(
                                  color: isSelected ? primaryColor : onSurfaceColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isSelected ? primaryColor : onSurfaceVariant.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Invoices List
            if (_filteredInvoices.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final invoice = _filteredInvoices[index];
                    final delay = index * 100;
                    
                    return _AnimatedInvoiceCard(
                      invoice: invoice,
                      delay: delay,
                      onTap: () => _viewInvoiceDetails(invoice),
                      onEdit: () => _editInvoice(invoice),
                      onDelete: () => _deleteInvoice(invoice.id),
                      onSendReminder: () => _sendInvoiceReminder(invoice),
                      onMarkAsPaid: () => _markAsPaid(invoice),
                      onDuplicate: () => _duplicateInvoice(invoice),
                      isDarkMode: isDarkMode,
                    );
                  },
                  childCount: _filteredInvoices.length,
                ),
              )
            else
              SliverFillRemaining(
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_rounded,
                            size: 80,
                            color: onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Invoices Found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: onSurfaceColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Try adjusting your search terms'
                                : 'Create your first invoice to get started',
                            style: TextStyle(
                              color: onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          if (_searchQuery.isEmpty)
                            FilledButton(
                              onPressed: _createNewInvoice,
                              child: const Text('Create Invoice'),
                            ),
                        ],
                      ),
                    );
                  },
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
            currentIndex: 1, // Invoices index
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
}

// Supporting Widgets

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatChip({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$value $label',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedInvoiceCard extends StatefulWidget {
  final Invoice invoice;
  final int delay;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSendReminder;
  final VoidCallback onMarkAsPaid;
  final VoidCallback onDuplicate;
  final bool isDarkMode;

  const _AnimatedInvoiceCard({
    required this.invoice,
    required this.delay,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onSendReminder,
    required this.onMarkAsPaid,
    required this.onDuplicate,
    required this.isDarkMode,
  });

  @override
  State<_AnimatedInvoiceCard> createState() => _AnimatedInvoiceCardState();
}

class _AnimatedInvoiceCardState extends State<_AnimatedInvoiceCard> with SingleTickerProviderStateMixin {
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
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Card(
              elevation: 2,
              shadowColor: widget.isDarkMode ? Colors.black : Colors.black12,
              surfaceTintColor: Colors.transparent,
              color: surfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.invoice.number,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: onSurfaceColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.invoice.clientName,
                                  style: TextStyle(
                                    color: onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _StatusBadge(status: widget.invoice.status),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Details Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Amount',
                                style: TextStyle(
                                  color: onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '\$${widget.invoice.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: onSurfaceColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Due Date',
                                style: TextStyle(
                                  color: onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat('MMM dd, yyyy').format(widget.invoice.dueDate),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: onSurfaceColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Actions Row
                      Row(
                        children: [
                          _buildActionButton(
                            icon: Icons.visibility_rounded,
                            label: 'View',
                            onTap: widget.onTap,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 8),
                          _buildActionButton(
                            icon: Icons.edit_rounded,
                            label: 'Edit',
                            onTap: widget.onEdit,
                            color: Colors.blue,
                          ),
                          const Spacer(),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert_rounded, color: onSurfaceVariant),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'duplicate',
                                child: Row(
                                  children: [
                                    Icon(Icons.copy_rounded, size: 18, color: onSurfaceVariant),
                                    const SizedBox(width: 8),
                                    const Text('Duplicate'),
                                  ],
                                ),
                              ),
                              if (widget.invoice.status == InvoiceStatus.pending)
                                PopupMenuItem(
                                  value: 'mark_paid',
                                  child: Row(
                                    children: [
                                      Icon(Icons.check_circle_rounded, size: 18, color: Colors.green),
                                      const SizedBox(width: 8),
                                      const Text('Mark as Paid'),
                                    ],
                                  ),
                                ),
                              if (widget.invoice.status == InvoiceStatus.pending || widget.invoice.status == InvoiceStatus.overdue)
                                PopupMenuItem(
                                  value: 'send_reminder',
                                  child: Row(
                                    children: [
                                      Icon(Icons.notifications_rounded, size: 18, color: Colors.orange),
                                      const SizedBox(width: 8),
                                      const Text('Send Reminder'),
                                    ],
                                  ),
                                ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_rounded, size: 18, color: Colors.red),
                                    const SizedBox(width: 8),
                                    const Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              switch (value) {
                                case 'duplicate':
                                  widget.onDuplicate();
                                  break;
                                case 'mark_paid':
                                  widget.onMarkAsPaid();
                                  break;
                                case 'send_reminder':
                                  widget.onSendReminder();
                                  break;
                                case 'delete':
                                  widget.onDelete();
                                  break;
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final InvoiceStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, text) = _getStatusInfo(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  (Color, String) _getStatusInfo(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return (Colors.green, 'Paid');
      case InvoiceStatus.pending:
        return (Colors.orange, 'Pending');
      case InvoiceStatus.overdue:
        return (Colors.red, 'Overdue');
      case InvoiceStatus.draft:
        return (Colors.grey, 'Draft');
    }
  }
}

// Data Models
enum InvoiceStatus { paid, pending, overdue, draft }

class Invoice {
  final String id;
  final String number;
  final String clientName;
  final double amount;
  final DateTime dueDate;
  final InvoiceStatus status;
  final DateTime createdAt;
  final int items;

  const Invoice({
    required this.id,
    required this.number,
    required this.clientName,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  Invoice copyWith({
    String? id,
    String? number,
    String? clientName,
    double? amount,
    DateTime? dueDate,
    InvoiceStatus? status,
    DateTime? createdAt,
    int? items,
  }) {
    return Invoice(
      id: id ?? this.id,
      number: number ?? this.number,
      clientName: clientName ?? this.clientName,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }
}