import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/book_model.dart';
import '../../data/models/order_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/admin_service.dart';
import '../../data/services/auth_service.dart';
import '../auth/login_screen.dart';
import 'dialogs/book_form_dialog.dart';
import 'dialogs/delete_confirm_dialog.dart';

class AdminDashboardScreen extends StatefulWidget {
  final UserModel currentUser;

  const AdminDashboardScreen({super.key, required this.currentUser});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final AdminService _adminService = AdminService();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _adminService.addListener(_onServiceUpdate);
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _adminService.removeListener(_onServiceUpdate);
    _tabController.dispose();
    super.dispose();
  }

  void _showAddBookDialog() async {
    final newBook = await BookFormDialog.show(context);
    if (newBook != null) {
      _adminService.addBook(newBook);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added "${newBook.title}" to catalog'),
            backgroundColor: AppColors.surfaceElevated,
          ),
        );
      }
    }
  }

  void _showEditBookDialog(BookModel book) async {
    final updated = await BookFormDialog.show(context, bookToEdit: book);
    if (updated != null) {
      _adminService.updateBook(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Updated "${updated.title}"'),
            backgroundColor: AppColors.surfaceElevated,
          ),
        );
      }
    }
  }

  void _confirmDeleteBook(BookModel book) async {
    final confirmed = await DeleteConfirmDialog.show(
      context,
      title: 'Remove Book',
      message:
          'Are you sure you want to delete "${book.title}"? This cannot be undone.',
    );
    if (confirmed && book.id != null) {
      _adminService.deleteBook(book.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed "${book.title}" from catalog'),
            backgroundColor: AppColors.surfaceElevated,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = _adminService.books.where((b) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return b.title.toLowerCase().contains(q) ||
          b.author.toLowerCase().contains(q) ||
          b.genreName.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                tooltip: 'Back to Store',
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderDefault, width: 1),
              ),
              child: const Icon(
                Icons.admin_panel_settings_rounded,
                color: AppColors.primaryRedLight,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'APTECH BOOKS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRedMuted,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.primaryRedDark,
                          width: 0.8,
                        ),
                      ),
                      child: const Text(
                        'ADMIN',
                        style: TextStyle(
                          color: AppColors.primaryRedLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Management Console',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            onPressed: () async {
              await AuthService().logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryRed,
          indicatorWeight: 3,
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.menu_book_rounded, size: 18), text: 'Catalog'),
            Tab(
              icon: Icon(Icons.local_shipping_outlined, size: 18),
              text: 'Orders',
            ),
            Tab(icon: Icon(Icons.people_alt_outlined, size: 18), text: 'Users'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top KPI Metrics Ribbon
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _KpiCard(
                      title: 'TOTAL REVENUE',
                      value:
                          '\$${_adminService.totalRevenue.toStringAsFixed(2)}',
                      subtitle: 'Simulated Dormant Sales',
                      icon: Icons.payments_outlined,
                      accentColor: AppColors.success,
                    ),
                    const SizedBox(width: 12),
                    _KpiCard(
                      title: 'CATALOG BOOKS',
                      value: '${_adminService.totalBooksCount}',
                      subtitle:
                          '${_adminService.lowStockCount} Low stock alerts',
                      icon: Icons.auto_stories_rounded,
                      accentColor: AppColors.primaryRedLight,
                    ),
                    const SizedBox(width: 12),
                    _KpiCard(
                      title: 'CUSTOMER ORDERS',
                      value: '${_adminService.totalOrdersCount}',
                      subtitle: 'Live Tracking Active',
                      icon: Icons.shopping_bag_outlined,
                      accentColor: AppColors.warning,
                    ),
                    const SizedBox(width: 12),
                    _KpiCard(
                      title: 'REGISTERED USERS',
                      value: '${_adminService.totalUsersCount}',
                      subtitle: 'Accounts Managed',
                      icon: Icons.people_outline_rounded,
                      accentColor: AppColors.info,
                    ),
                  ],
                ),
              ),
            ),

            // Main Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Catalog Manager
                  _buildCatalogTab(filteredBooks),

                  // Tab 2: Orders Manager
                  _buildOrdersTab(),

                  // Tab 3: Users Manager
                  _buildUsersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Book',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        onPressed: _showAddBookDialog,
      ),
    );
  }

  // TAB 1: Catalog Management
  Widget _buildCatalogTab(List<BookModel> books) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderSubtle, width: 1),
            ),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
              decoration: const InputDecoration(
                hintText: 'Search catalog by title, author, or genre...',
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: AppColors.textMuted,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),

        // List
        Expanded(
          child: books.isEmpty
              ? const Center(
                  child: Text(
                    'No books found matching criteria.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                  itemCount: books.length,
                  itemBuilder: (ctx, i) {
                    final book = books[i];
                    return _BookAdminCard(
                      book: book,
                      onEdit: () => _showEditBookDialog(book),
                      onDelete: () => _confirmDeleteBook(book),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // TAB 2: Orders Management
  Widget _buildOrdersTab() {
    final orders = _adminService.orders;

    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'No customer orders placed yet.\nOrders from app checkouts will appear here.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted, height: 1.5),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: orders.length,
      itemBuilder: (ctx, i) {
        final order = orders[i];
        return _OrderAdminCard(
          order: order,
          onStatusChanged: (newStatus) {
            _adminService.updateOrderStatus(order.orderNumber, newStatus);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Order \${order.orderNumber} updated to \$newStatus',
                ),
                backgroundColor: AppColors.surfaceElevated,
              ),
            );
          },
        );
      },
    );
  }

  // TAB 3: Users Management
  Widget _buildUsersTab() {
    final users = _adminService.users;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: users.length,
      itemBuilder: (ctx, i) {
        final u = users[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderSubtle, width: 1),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: u.isAdmin
                    ? AppColors.primaryRedMuted
                    : AppColors.surfaceHighlight,
                child: Text(
                  u.fullName.isNotEmpty ? u.fullName[0].toUpperCase() : 'U',
                  style: TextStyle(
                    color: u.isAdmin
                        ? AppColors.primaryRedLight
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      u.fullName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      u.email,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    if (u.address != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        u.address!,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: u.isAdmin
                      ? AppColors.primaryRedMuted
                      : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: u.isAdmin
                        ? AppColors.primaryRedDark
                        : AppColors.borderDefault,
                    width: 0.8,
                  ),
                ),
                child: Text(
                  u.role,
                  style: TextStyle(
                    color: u.isAdmin
                        ? AppColors.primaryRedLight
                        : AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// KPI Card Widget
class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, size: 16, color: accentColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: accentColor.withValues(alpha: 0.85),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Book Admin Card Widget
class _BookAdminCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BookAdminCard({
    required this.book,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock = book.stockQuantity <= 15;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 55,
              height: 80,
              color: AppColors.surfaceHighlight,
              child: Image.network(
                book.coverImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.textMuted,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        book.genreName,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (book.isBestseller) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRedMuted,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Bestseller',
                          style: TextStyle(
                            color: AppColors.primaryRedLight,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  book.author,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${book.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.primaryRedLight,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isLowStock
                            ? const Color(0x1AEF4444)
                            : const Color(0x1A10B981),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '\${book.stockQuantity} in stock',
                        style: TextStyle(
                          color: isLowStock
                              ? AppColors.error
                              : AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons
          Column(
            children: [
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                onPressed: onEdit,
              ),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: AppColors.error,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Order Admin Card Widget
class _OrderAdminCard extends StatelessWidget {
  final OrderModel order;
  final void Function(String newStatus) onStatusChanged;

  const _OrderAdminCard({required this.order, required this.onStatusChanged});

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return AppColors.warning;
      case 'PROCESSING':
        return const Color(0xFFF59E0B);
      case 'SHIPPED':
        return const Color(0xFF3B82F6);
      case 'DELIVERED':
        return AppColors.success;
      case 'CANCELLED':
        return AppColors.error;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderNumber,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              // Status Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: order.status,
                    dropdownColor: AppColors.surfaceElevated,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: statusColor,
                      size: 18,
                    ),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                    items:
                        [
                          'PENDING',
                          'PROCESSING',
                          'SHIPPED',
                          'DELIVERED',
                          'CANCELLED',
                        ].map((s) {
                          return DropdownMenuItem(value: s, child: Text(s));
                        }).toList(),
                    onChanged: (v) {
                      if (v != null) onStatusChanged(v);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\${order.customerName} • \${order.contactPhone}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order.shippingAddress,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderSubtle),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.primaryRedLight,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0x1A10B981),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order.paymentStatus,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              if (order.trackingNumber != null)
                Text(
                  order.trackingNumber!,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
