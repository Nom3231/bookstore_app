import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../data/models/book_model.dart';

class BookFormDialog extends StatefulWidget {
  final BookModel? bookToEdit;

  const BookFormDialog({super.key, this.bookToEdit});

  static Future<BookModel?> show(
    BuildContext context, {
    BookModel? bookToEdit,
  }) {
    return showDialog<BookModel>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BookFormDialog(bookToEdit: bookToEdit),
    );
  }

  @override
  State<BookFormDialog> createState() => _BookFormDialogState();
}

class _BookFormDialogState extends State<BookFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _descController;
  late final TextEditingController _imageController;

  String _selectedGenre = 'Computer Science';
  bool _isBestseller = false;
  bool _isNewArrival = false;

  final List<String> _genres = [
    'Computer Science',
    'Fiction & Literature',
    'Business & Finance',
    'Science & Mathematics',
    'Philosophy & Psychology',
  ];

  @override
  void initState() {
    super.initState();
    final b = widget.bookToEdit;
    _titleController = TextEditingController(text: b?.title ?? '');
    _authorController = TextEditingController(text: b?.author ?? '');
    _priceController = TextEditingController(
      text: b != null ? b.price.toStringAsFixed(2) : '',
    );
    _stockController = TextEditingController(
      text: b != null ? b.stockQuantity.toString() : '10',
    );
    _descController = TextEditingController(text: b?.description ?? '');
    _imageController = TextEditingController(text: b?.coverImageUrl ?? '');

    if (b != null) {
      if (_genres.contains(b.genreName)) {
        _selectedGenre = b.genreName;
      }
      _isBestseller = b.isBestseller;
      _isNewArrival = b.isNewArrival;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 10;
    final imgUrl = _imageController.text.trim().isNotEmpty
        ? _imageController.text.trim()
        : 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=1200&auto=format&fit=max&q=85';

    final savedBook = BookModel(
      id: widget.bookToEdit?.id,
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      genreId: _genres.indexOf(_selectedGenre) + 1,
      genreName: _selectedGenre,
      price: price,
      stockQuantity: stock,
      description: _descController.text.trim(),
      coverImageUrl: imgUrl,
      isBestseller: _isBestseller,
      isNewArrival: _isNewArrival,
    );

    Navigator.pop(context, savedBook);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.bookToEdit != null;

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderDefault, width: 1),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRedMuted,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isEditing
                                ? Icons.edit_note_rounded
                                : Icons.add_box_rounded,
                            color: AppColors.primaryRedLight,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isEditing ? 'Edit Book Listing' : 'Add New Book',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.borderSubtle),
                const SizedBox(height: 16),

                // Form Scroll Area
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          label: 'Book Title',
                          hintText:
                              'e.g. Designing Data-Intensive Applications',
                          controller: _titleController,
                          prefixIcon: Icons.menu_book_rounded,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Title is required'
                              : null,
                        ),
                        const SizedBox(height: 14),

                        CustomTextField(
                          label: 'Author Name',
                          hintText: 'e.g. Martin Kleppmann',
                          controller: _authorController,
                          prefixIcon: Icons.person_outline_rounded,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Author is required'
                              : null,
                        ),
                        const SizedBox(height: 14),

                        // Genre Dropdown
                        const Text(
                          'Genre / Category',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: AppColors.inputBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.inputBorder,
                              width: 1,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedGenre,
                              isExpanded: true,
                              dropdownColor: AppColors.surfaceElevated,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.textSecondary,
                              ),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                              items: _genres.map((g) {
                                return DropdownMenuItem(
                                  value: g,
                                  child: Text(g),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedGenre = val);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Price & Stock Row
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Price (\$ USD)',
                                hintText: '39.99',
                                controller: _priceController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                prefixIcon: Icons.attach_money_rounded,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Enter price';
                                  }
                                  if (double.tryParse(v) == null) {
                                    return 'Invalid number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: CustomTextField(
                                label: 'Stock Quantity',
                                hintText: '10',
                                controller: _stockController,
                                keyboardType: TextInputType.number,
                                prefixIcon: Icons.inventory_2_outlined,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Enter stock';
                                  }
                                  if (int.tryParse(v) == null) {
                                    return 'Invalid integer';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        CustomTextField(
                          label: 'Cover Image URL',
                          hintText: 'https://images.unsplash.com/...',
                          controller: _imageController,
                          prefixIcon: Icons.image_outlined,
                        ),
                        const SizedBox(height: 14),

                        CustomTextField(
                          label: 'Description',
                          hintText: 'Brief summary of the book content and key takeaways...',
                          controller: _descController,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                        ),
                        const SizedBox(height: 16),

                        // Switches for Bestseller and New Arrival
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.borderSubtle,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                activeThumbColor: AppColors.primaryRedLight,
                                title: const Text(
                                  'Featured Bestseller',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: const Text(
                                  'Displays in the Bestsellers ribbon on mobile home screen',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                                value: _isBestseller,
                                onChanged: (v) =>
                                    setState(() => _isBestseller = v),
                              ),
                              const Divider(color: AppColors.borderSubtle),
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                activeThumbColor: AppColors.primaryRedLight,
                                title: const Text(
                                  'New Arrival Badge',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: const Text(
                                  'Highlights as recently published acquisition',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                                value: _isNewArrival,
                                onChanged: (v) =>
                                    setState(() => _isNewArrival = v),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        text: isEditing ? 'Update Listing' : 'Save Book',
                        onPressed: _handleSave,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
