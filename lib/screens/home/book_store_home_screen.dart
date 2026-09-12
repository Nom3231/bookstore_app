import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/book_cover_image.dart';
import '../../data/models/book_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/admin_service.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/cart_service.dart';
import '../auth/login_screen.dart';
import '../book_detail/book_detail_sheet.dart';
import '../admin/admin_dashboard_screen.dart';
import '../cart/cart_screen.dart';
import '../explore/explore_screen.dart';
import '../profile/profile_screen.dart';

class BookStoreHomeScreen extends StatefulWidget {
  final UserModel currentUser;

  const BookStoreHomeScreen({super.key, required this.currentUser});

  @override
  State<BookStoreHomeScreen> createState() => _BookStoreHomeScreenState();
}

class _BookStoreHomeScreenState extends State<BookStoreHomeScreen> {
  final AdminService _adminService = AdminService();
  final CartService _cartService = CartService();
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';
  int _currentNavIndex = 0;

  final List<String> _categories = [
    'All',
    'Computer Science',
    'Fiction & Literature',
    'Business & Finance',
    'Philosophy & Psychology',
  ];

  @override
  void initState() {
    super.initState();
    _adminService.addListener(_onUpdate);
    _cartService.addListener(_onUpdate);
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _adminService.removeListener(_onUpdate);
    _cartService.removeListener(_onUpdate);
    _searchController.dispose();
    super.dispose();
  }

  void _openCartTab() => setState(() => _currentNavIndex = 2);

  void _openBook(BookModel book) {
    BookDetailSheet.show(context, book, onViewCart: _openCartTab);
  }

  void _addToCart(BookModel book) {
    _cartService.add(book);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${book.title}" to cart'),
        action: SnackBarAction(
          label: 'VIEW',
          textColor: AppColors.primaryRedLight,
          onPressed: _openCartTab,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final books = _adminService.books;
    final bestsellers = books.where((b) => b.isBestseller).toList();
    final filteredBooks = books.where((b) {
      final matchesCategory =
          _selectedCategory == 'All' || b.genreName == _selectedCategory;
      final matchesSearch =
          _searchQuery.isEmpty ||
          b.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.genreName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    final genreItems = <({String name, String category, IconData icon, Color color})>[
      (name: 'Fiction', category: 'Fiction & Literature', icon: Icons.auto_stories_rounded, color: Color(0xFF8C5E45)),
      (name: 'Business', category: 'Business & Finance', icon: Icons.trending_up_rounded, color: Color(0xFF627A68)),
      (name: 'Computer science', category: 'Computer Science', icon: Icons.code_rounded, color: Color(0xFF64748B)),
      (name: 'Psychology', category: 'Philosophy & Psychology', icon: Icons.psychology_alt_rounded, color: Color(0xFF9A7181)),
      (name: 'Philosophy', category: 'Philosophy & Psychology', icon: Icons.lightbulb_outline_rounded, color: Color(0xFF8A7650)),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          SafeArea(
            child: CustomScrollView(
          slivers: [
            // Top App Bar with User Greeting & Notification
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.surfaceHighlight,
                      child: Text(
                        widget.currentUser.fullName.isNotEmpty
                            ? widget.currentUser.fullName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: AppColors.primaryRedLight,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good day,',
                            style: TextStyle(
                              color: AppColors.textMuted.withValues(alpha: 0.9),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            widget.currentUser.fullName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.currentUser.isAdmin)
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminDashboardScreen(
                                currentUser: widget.currentUser,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRedMuted,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primaryRedDark,
                              width: 0.8,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.admin_panel_settings_rounded,
                                size: 14,
                                color: AppColors.primaryRedLight,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'ADMIN',
                                style: TextStyle(
                                  color: AppColors.primaryRedLight,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Sign Out',
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
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Search & Filter Box
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.borderSubtle,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) =>
                              setState(() => _searchQuery = val.trim()),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search books, authors, or genres...',
                            hintStyle: const TextStyle(
                              color: AppColors.inputPlaceholder,
                              fontSize: 13,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              size: 20,
                              color: AppColors.textMuted,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear_rounded,
                                      size: 18,
                                      color: AppColors.textMuted,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.borderSubtle,
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.tune_rounded,
                          color: AppColors.primaryRedLight,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _currentNavIndex = 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Genre discovery: a visual entry point into the catalog.
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Browse by genre',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _selectedCategory = 'All'),
                      child: const Text('View all'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 92,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: genreItems.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final genre = genreItems[index];
                    return _GenreTile(
                      label: genre.name,
                      icon: genre.icon,
                      color: genre.color,
                      selected: _selectedCategory == genre.category,
                      onTap: () => setState(() => _selectedCategory = genre.category),
                    );
                  },
                ),
              ),
            ),

            // Hero Featured Banner (Dribbble style)
            if (_searchQuery.isEmpty && bestsellers.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: _FeaturedHeroBanner(
                    book: bestsellers.first,
                    onTap: () => _openBook(bestsellers.first),
                  ),
                ),
              ),

            // Category Chips Ribbon
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _categories.length,
                    itemBuilder: (ctx, i) {
                      final cat = _categories[i];
                      final isSelected = cat == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => setState(() => _selectedCategory = cat),
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryRed
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryRed
                                    : AppColors.borderSubtle,
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              cat,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontSize: 12.5,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Bestsellers Carousel Header
            if (_searchQuery.isEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Trending & Bestsellers',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _currentNavIndex = 1),
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: AppColors.primaryRedLight,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bestsellers Horizontal Carousel
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: bestsellers.length,
                    itemBuilder: (ctx, i) {
                      final b = bestsellers[i];
                      return _BookCoverCard(
                        book: b,
                        onTap: () => _openBook(b),
                      );
                    },
                  ),
                ),
              ),
            ],

            // Catalog Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  children: [
                    Text(
                      _searchQuery.isNotEmpty
                          ? 'Search Results (${filteredBooks.length})'
                          : 'All Books',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (filteredBooks.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 48,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.borderSubtle,
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.search_off_rounded,
                            size: 36,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No books found',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No titles match "$_searchQuery"'
                              : 'No books currently in category "$_selectedCategory"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 18),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.refresh_rounded, size: 16),
                          label: const Text('Reset filters'),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                              _selectedCategory = 'All';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              // 2-Column Catalog Grid
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate((ctx, i) {
                    final b = filteredBooks[i];
                    return _GridBookCard(
                      book: b,
                      onTap: () => _openBook(b),
                      onAddToCart: () => _addToCart(b),
                    );
                  }, childCount: filteredBooks.length),
                ),
              ),
          ],
            ),
          ),
          ExploreScreen(onOpenCart: _openCartTab),
          CartScreen(
            currentUser: widget.currentUser,
            onKeepShopping: () => setState(() => _currentNavIndex = 0),
          ),
          ProfileScreen(currentUser: widget.currentUser),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.95),
          border: const Border(
            top: BorderSide(color: AppColors.borderSubtle, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentNavIndex,
          onTap: (idx) => setState(() => _currentNavIndex = idx),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryRed,
          unselectedItemColor: AppColors.textMuted,
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Discover',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: _cartService.itemCount > 0,
                label: Text('${_cartService.itemCount}'),
                backgroundColor: AppColors.primaryRed,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _GenreTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _GenreTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Browse $label books',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 112,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: selected ? color : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? color : AppColors.borderSubtle,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: selected ? Colors.white.withValues(alpha: 0.2) : color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 17, color: selected ? Colors.white : color),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.textPrimary,
                  fontSize: 12,
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

// Dribbble-Style Featured Hero Banner
class _FeaturedHeroBanner extends StatelessWidget {
  final BookModel book;
  final VoidCallback onTap;

  const _FeaturedHeroBanner({required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          colors: [Color(0xFF6A453A), Color(0xFF2F2926)],
          ),
          border: Border.all(
            color: AppColors.primaryRedDark.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Text details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'BOOK OF THE WEEK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: const TextStyle(
                      color: Color(0xFFE8D9C9),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '\$${book.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.primaryRedLight,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB800),
                        size: 16,
                      ),
                      Text(
                        ' ${book.ratingAvg}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Cover with 3D shadow
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.7),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: BookCoverImage(
                imageUrl: book.coverImageUrl,
                width: 80,
                height: 115,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bestseller Carousel Card
class _BookCoverCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onTap;

  const _BookCoverCard({required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: BookCoverImage(
                imageUrl: book.coverImageUrl,
                width: 130,
                height: 175,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${book.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.primaryRedLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: Color(0xFFFFB800),
                    ),
                    Text(
                      '${book.ratingAvg}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 2-Column Grid Card
class _GridBookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const _GridBookCard({
    required this.book,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BookCoverImage(
                imageUrl: book.coverImageUrl,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${book.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.primaryRedLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                InkWell(
                  onTap: onAddToCart,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRedMuted,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primaryRedDark.withValues(alpha: 0.6),
                        width: 0.8,
                      ),
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart_rounded,
                      size: 15,
                      color: AppColors.primaryRedLight,
                    ),
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
