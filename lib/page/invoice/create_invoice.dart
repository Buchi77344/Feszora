import 'package:feszora/layout/navigation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:feszora/layout/mode.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  int _currentIndex = 0;
  final PageController _pageController = PageController();

  // Invoice State
  final List<InvoiceItem> _invoiceItems = [
    InvoiceItem(description: 'Web Development', quantity: 1, price: 1200.00),
    InvoiceItem(description: 'UI/UX Design', quantity: 1, price: 800.00),
  ];
  
  double _taxRate = 10.0;
  double _discount = 0.0;
  String _selectedClient = 'James Peter';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));
  String _status = 'Draft';
  String _invoiceNumber = 'INV-${DateTime.now().year}-001';
  String _notes = 'Thank you for your business!';
  String _paymentTerms = 'Net 30';

  // Form Controllers
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _invoiceNumberController = TextEditingController();

  // Sample client data
  final List<String> _clients = [
    'James Peter',
    'Sarah Wilson',
    'Mike Johnson',
    'Lisa Brown',
    'David Miller'
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

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    // Initialize controllers
    _clientController.text = _selectedClient;
    _notesController.text = _notes;
    _invoiceNumberController.text = _invoiceNumber;

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _clientController.dispose();
    _notesController.dispose();
    _invoiceNumberController.dispose();
    super.dispose();
  }

  double get _subtotal {
    return _invoiceItems.fold(0.0, (sum, item) => sum + (item.quantity * item.price));
  }

  double get _taxAmount {
    return _subtotal * (_taxRate / 100);
  }

  double get _total {
    return _subtotal + _taxAmount - _discount;
  }

  void _addNewItem() {
    setState(() {
      _invoiceItems.add(InvoiceItem(description: 'New Item', quantity: 1, price: 0.0));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _invoiceItems.removeAt(index);
    });
  }

  void _updateItem(int index, InvoiceItem newItem) {
    setState(() {
      _invoiceItems[index] = newItem;
    });
  }

  void _saveInvoice() {
    if (_validateInvoice()) {
      _showSuccessDialog('Invoice Saved', 'Your invoice has been saved successfully.');
    }
  }

  void _sendInvoice() {
    if (_validateInvoice()) {
      _showSendDialog();
    }
  }

  void _duplicateInvoice() {
    setState(() {
      _invoiceNumber = 'INV-${DateTime.now().year}-${_generateInvoiceNumber()}';
      _invoiceNumberController.text = _invoiceNumber;
      _status = 'Draft';
    });
    _showSuccessDialog('Invoice Duplicated', 'A copy of this invoice has been created.');
  }

  void _previewInvoice() {
    if (_validateInvoice()) {
      _showPreviewDialog();
    }
  }

  bool _validateInvoice() {
    if (_invoiceItems.isEmpty) {
      _showErrorDialog('Add Items', 'Please add at least one item to the invoice.');
      return false;
    }

    for (var item in _invoiceItems) {
      if (item.description.isEmpty) {
        _showErrorDialog('Invalid Item', 'Please provide a description for all items.');
        return false;
      }
      if (item.price <= 0) {
        _showErrorDialog('Invalid Price', 'Please set a valid price for all items.');
        return false;
      }
    }

    return true;
  }

  String _generateInvoiceNumber() {
    final now = DateTime.now();
    return '${now.millisecondsSinceEpoch.toString().substring(7)}';
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSendDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Invoice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.email_rounded, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            const Text('Send this invoice to your client via email?'),
            const SizedBox(height: 8),
            Text(
              _selectedClient,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
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
              _showSentConfirmation();
            },
            child: const Text('Send Invoice'),
          ),
        ],
      ),
    );
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Invoice Preview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              // Preview content would go here
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text('INV-2024-001', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Client: $_selectedClient'),
                    Text('Total: \$${_total.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _sendInvoice();
                      },
                      child: const Text('Send'),
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

  void _showSentConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Invoice sent successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _showClientSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Client',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            ..._clients.map((client) => ListTile(
                  title: Text(client),
                  trailing: _selectedClient == client 
                      ? Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedClient = client;
                      _clientController.text = client;
                    });
                    Navigator.pop(context);
                  },
                )),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _showAddClientDialog();
              },
              icon: const Icon(Icons.person_add_rounded),
              label: const Text('Add New Client'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddClientDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Client'),
        content: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Client Name',
            hintText: 'Enter client name',
          ),
          onChanged: (value) {
            // Handle client name input
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // Add client logic
              Navigator.pop(context);
            },
            child: const Text('Add Client'),
          ),
        ],
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
            // Enhanced App Bar with Animation
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
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: onSurfaceColor,
                        size: 24,
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
                      'Create Invoice',
                      style: TextStyle(
                        color: onSurfaceColor, 
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _previewInvoice,
                              icon: Icon(Icons.visibility_rounded, color: onSurfaceColor, size: 22),
                              tooltip: 'Preview',
                            ),
                            IconButton(
                              onPressed: _duplicateInvoice,
                              icon: Icon(Icons.copy_rounded, color: onSurfaceColor, size: 22),
                              tooltip: 'Duplicate',
                            ),
                            IconButton(
                              onPressed: _saveInvoice,
                              icon: Icon(Icons.save_outlined, color: onSurfaceColor, size: 22),
                              tooltip: 'Save',
                            ),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: _sendInvoice,
                              icon: const Icon(Icons.send_rounded, size: 18),
                              label: const Text('Send'),
                              style: FilledButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),

            // Invoice Header Section
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
                            TextFormField(
                              controller: _invoiceNumberController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'INV-2024-001',
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) => setState(() => _invoiceNumber = value),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total: \$${_total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Due: ${DateFormat('MMM dd, yyyy').format(_dueDate)}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Client & Details Section
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
                            child: _AnimatedInfoCard(
                              title: 'Bill To',
                              content: _selectedClient,
                              subtitle: 'Client',
                              icon: Icons.business_rounded,
                              color: Colors.blue,
                              delay: 0,
                              isDarkMode: isDarkMode,
                              onTap: _showClientSelector,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _AnimatedInfoCard(
                              title: 'Due Date',
                              content: DateFormat('MMM dd, yyyy').format(_dueDate),
                              subtitle: 'Payment Terms',
                              icon: Icons.calendar_today_rounded,
                              color: Colors.green,
                              delay: 100,
                              isDarkMode: isDarkMode,
                              onTap: _selectDueDate,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _AnimatedNotesField(
                        controller: _notesController,
                        delay: 200,
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Invoice Items Header
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
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Invoice Items',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Amount',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Invoice Items List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _AnimatedInvoiceItemRow(
                    item: _invoiceItems[index],
                    index: index,
                    onUpdate: _updateItem,
                    onRemove: _removeItem,
                    delay: index * 100,
                    isDarkMode: isDarkMode,
                  );
                },
                childCount: _invoiceItems.length,
              ),
            ),

            // Add Item Button
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.1),
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: OutlinedButton.icon(
                    onPressed: _addNewItem,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add Item'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Summary Section
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
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(
                        label: 'Subtotal',
                        value: '\$${_subtotal.toStringAsFixed(2)}',
                        isTotal: false,
                      ),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: 'Tax (${_taxRate.toStringAsFixed(1)}%)',
                        value: '\$${_taxAmount.toStringAsFixed(2)}',
                        isTotal: false,
                      ),
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: 'Discount',
                        value: '-\$${_discount.toStringAsFixed(2)}',
                        isTotal: false,
                      ),
                      const Divider(height: 24),
                      _SummaryRow(
                        label: 'Total',
                        value: '\$${_total.toStringAsFixed(2)}',
                        isTotal: true,
                        primaryColor: primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Settings Section
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.1),
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Invoice Settings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _AnimatedSettingField(
                              label: 'Tax Rate (%)',
                              value: _taxRate,
                              onChanged: (value) => setState(() => _taxRate = value),
                              delay: 0,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _AnimatedSettingField(
                              label: 'Discount (\$)',
                              value: _discount,
                              onChanged: (value) => setState(() => _discount = value),
                              delay: 100,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _AnimatedSettingField(
                        label: 'Payment Terms',
                        value: 30, // Using as example
                        onChanged: (value) {}, // Would implement terms logic
                        delay: 200,
                        isDarkMode: isDarkMode,
                        isTerms: true,
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
}

// Enhanced Supporting Widgets

class _AnimatedInfoCard extends StatefulWidget {
  final String title;
  final String content;
  final String subtitle;
  final IconData icon;
  final Color color;
  final int delay;
  final bool isDarkMode;
  final VoidCallback? onTap;

  const _AnimatedInfoCard({
    required this.title,
    required this.content,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.delay,
    required this.isDarkMode,
    this.onTap,
  });

  @override
  State<_AnimatedInfoCard> createState() => _AnimatedInfoCardState();
}

class _AnimatedInfoCardState extends State<_AnimatedInfoCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(widget.icon, color: widget.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.content,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.onTap != null)
                Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedNotesField extends StatefulWidget {
  final TextEditingController controller;
  final int delay;
  final bool isDarkMode;

  const _AnimatedNotesField({
    required this.controller,
    required this.delay,
    required this.isDarkMode,
  });

  @override
  State<_AnimatedNotesField> createState() => _AnimatedNotesFieldState();
}

class _AnimatedNotesFieldState extends State<_AnimatedNotesField> with SingleTickerProviderStateMixin {
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
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notes',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: widget.controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add notes or terms for the client...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedInvoiceItemRow extends StatefulWidget {
  final InvoiceItem item;
  final int index;
  final Function(int, InvoiceItem) onUpdate;
  final Function(int) onRemove;
  final int delay;
  final bool isDarkMode;

  const _AnimatedInvoiceItemRow({
    required this.item,
    required this.index,
    required this.onUpdate,
    required this.onRemove,
    required this.delay,
    required this.isDarkMode,
  });

  @override
  State<_AnimatedInvoiceItemRow> createState() => _AnimatedInvoiceItemRowState();
}

class _AnimatedInvoiceItemRowState extends State<_AnimatedInvoiceItemRow> with SingleTickerProviderStateMixin {
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

    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
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
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    initialValue: widget.item.description,
                    onChanged: (value) => widget.onUpdate(
                      widget.index,
                      widget.item.copyWith(description: value),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Item description',
                      hintStyle: TextStyle(color: onSurfaceVariant),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(fontSize: 14, color: onSurfaceColor),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: widget.item.quantity.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final quantity = int.tryParse(value) ?? 1;
                      widget.onUpdate(
                        widget.index,
                        widget.item.copyWith(quantity: quantity),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: 'Qty',
                      hintStyle: TextStyle(color: onSurfaceVariant),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: onSurfaceColor),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: widget.item.price.toStringAsFixed(2),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final price = double.tryParse(value) ?? 0.0;
                      widget.onUpdate(
                        widget.index,
                        widget.item.copyWith(price: price),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: 'Price',
                      hintStyle: TextStyle(color: onSurfaceVariant),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 14, color: onSurfaceColor),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 80,
                  child: Text(
                    '\$${(widget.item.quantity * widget.item.price).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: onSurfaceColor,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => widget.onRemove(widget.index),
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final Color? primaryColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isTotal,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final themePrimaryColor = primaryColor ?? Theme.of(context).colorScheme.primary;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? onSurfaceColor : onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.w700,
            color: isTotal ? themePrimaryColor : onSurfaceColor,
          ),
        ),
      ],
    );
  }
}

class _AnimatedSettingField extends StatefulWidget {
  final String label;
  final double value;
  final Function(double) onChanged;
  final int delay;
  final bool isDarkMode;
  final bool isTerms;

  const _AnimatedSettingField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.delay,
    required this.isDarkMode,
    this.isTerms = false,
  });

  @override
  State<_AnimatedSettingField> createState() => _AnimatedSettingFieldState();
}

class _AnimatedSettingFieldState extends State<_AnimatedSettingField> with SingleTickerProviderStateMixin {
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
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                color: onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            widget.isTerms
                ? DropdownButtonFormField<String>(
                    value: 'Net 30',
                    items: ['Net 15', 'Net 30', 'Net 45', 'Net 60']
                        .map((term) => DropdownMenuItem(
                              value: term,
                              child: Text(term),
                            ))
                        .toList(),
                    onChanged: (value) {
                      // Handle terms change
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: onSurfaceVariant.withOpacity(0.3)),
                      ),
                      filled: true,
                      fillColor: surfaceColor,
                    ),
                  )
                : TextFormField(
                    initialValue: widget.value.toStringAsFixed(2),
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      final newValue = double.tryParse(text) ?? 0.0;
                      widget.onChanged(newValue);
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: onSurfaceVariant.withOpacity(0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: onSurfaceVariant.withOpacity(0.3)),
                      ),
                      filled: true,
                      fillColor: surfaceColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// Data Models
class InvoiceItem {
  String description;
  int quantity;
  double price;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.price,
  });

  InvoiceItem copyWith({
    String? description,
    int? quantity,
    double? price,
  }) {
    return InvoiceItem(
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}