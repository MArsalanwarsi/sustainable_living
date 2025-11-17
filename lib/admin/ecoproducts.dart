import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sustainable_living/Custom/admincustomwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

///
/// 🏡 Manage Eco Products Screen (Firebase-ready UI)
///
class ManageEcoProductsScreen extends StatefulWidget {
  const ManageEcoProductsScreen({super.key});

  @override
  State<ManageEcoProductsScreen> createState() =>
      _ManageEcoProductsScreenState();
}

class _ManageEcoProductsScreenState extends State<ManageEcoProductsScreen> {
  // 🎨 Color Palette
  static const Color mintBackground = Color(0xFFE6F3EA);
  static const Color greenMain = Color(0xFF177A4B);
  static const Color greenDark = Color(0xFF135E3B);

  // 🔍 Search and Sort State
  String searchQuery = '';
  String selectedSort = 'Name (A–Z)';

  // 📦 Temporary Static Product List (replace with Firebase later)
  List<Map<String, dynamic>> products = [];
  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final products = await FirebaseFirestore.instance
        .collection('Products')
        .get();
    setState(
      () => this.products = products.docs
          .map(
            (doc) => {
              'id': doc.id,
              'image': doc.data()['image'],
              'name': doc.data()['name'],
              'desc': ((doc.data()['description'] ?? '').toString().length > 15
                  ? '${doc.data()['description'].toString().substring(0, 15)}...'
                  : doc.data()['description']),
            },
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // 🔎 Filtered and Sorted List (safe null handling)
    final filteredProducts =
        products.where((p) {
          final name = (p['name'] ?? '').toString().toLowerCase();
          final desc = (p['desc'] ?? '').toString().toLowerCase();
          return name.contains(searchQuery.toLowerCase()) ||
              desc.contains(searchQuery.toLowerCase());
        }).toList()..sort((a, b) {
          final nameA = (a['name'] ?? '').toString();
          final nameB = (b['name'] ?? '').toString();
          if (selectedSort == 'Name (A–Z)') {
            return nameA.compareTo(nameB);
          } else if (selectedSort == 'Name (Z–A)') {
            return nameB.compareTo(nameA);
          }
          return 0;
        });

    return Scaffold(
      backgroundColor: mintBackground,
      appBar: buildAdminCustomAppBar(context),
      bottomNavigationBar: buildAdminCustomBottomBar(context, 2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 🏷 Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Eco Products',
                    style: TextStyle(
                      color: greenDark,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.settings, color: greenDark),
                ],
              ),

              const SizedBox(height: 25),

              // ➕ Add Product Button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenMain,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 4,
                      ),
                      onPressed: () {
                        _showAddProductDialog(context);
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Add New Product',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔍 Search + Sort Row
              Row(
                children: [
                  // Search Field
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (query) {
                          setState(() => searchQuery = query);
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: greenDark),
                          hintText: 'Search products...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Sort Dropdown
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSort,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: const [
                            DropdownMenuItem(
                              value: 'Name (A–Z)',
                              child: Text('Name (A–Z)'),
                            ),
                            DropdownMenuItem(
                              value: 'Name (Z–A)',
                              child: Text('Name (Z–A)'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => selectedSort = value);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 🧺 Product List (Future: StreamBuilder for Firebase)
              ListView.builder(
                itemCount: filteredProducts.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = filteredProducts[index];
                  return ProductCard(
                    image:
                        item['image'] ??
                        'https://images.unsplash.com/photo-1587474260584-136574528ed5?auto=format&fit=crop&w=400&q=60',
                    title: item['name'] ?? 'Unnamed',
                    subtitle: item['desc'] ?? 'No description',
                    color: greenDark,
                    onInfo: () {
                      _showProductInfoDialog(context, item['id']);
                    },
                    onEdit: () {
                      _showEditProductDialog(context, item['id']);
                    },
                    onDelete: () {
                      _showDeleteConfirmationDialog(
                        context,
                        item['id'],
                        item['name'],
                      );
                    },
                  );
                },
              ),

              SizedBox(height: height * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  // 🎯 Show Add Product Dialog
  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _AddProductDialog(
        onProductAdded: () {
          loadProducts();
        },
      ),
    );
  }

  // 🎯 Show Edit Product Dialog
  void _showEditProductDialog(BuildContext context, String productId) async {
    // Fetch product data from Firestore by id
    final doc = await FirebaseFirestore.instance
        .collection('Products')
        .doc(productId)
        .get();
    if (!doc.exists) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        this.context,
      ).showSnackBar(const SnackBar(content: Text("Product not found.")));
      return;
    }
    final data = doc.data() ?? {};

    if (!mounted) return;
    showDialog(
      context: this.context,
      builder: (context) => _AddProductDialog(
        editMode: true,
        productId: productId,
        initialName: data['name'] ?? '',
        initialDesc: data['description'] ?? '',
        initialImage: data['image'] ?? '',
        initialPrice: data['price']?.toString() ?? '',
        initialGreenPoints: data['greenPoints']?.toString() ?? '',
        initialCo2: data['co2']?.toString() ?? '',
        onProductAdded: () {
          loadProducts();
        },
      ),
    );
  }

  // 🎯 Show Product Info Dialog
  void _showProductInfoDialog(BuildContext context, String productId) async {
    final doc = await FirebaseFirestore.instance
        .collection('Products')
        .doc(productId)
        .get();
    if (!doc.exists) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        this.context,
      ).showSnackBar(const SnackBar(content: Text("Product not found.")));
      return;
    }
    final data = doc.data() ?? {};

    if (!mounted) return;

    // Helper function to safely format numeric values
    String formatPrice(dynamic value) {
      if (value == null) return 'N/A';
      num? numValue;
      if (value is num) {
        numValue = value;
      } else {
        numValue = double.tryParse(value.toString());
      }
      if (numValue == null || !numValue.isFinite) return 'N/A';
      return '\$${numValue.toStringAsFixed(2)}';
    }

    String formatNumber(dynamic value) {
      if (value == null) return 'N/A';
      num? numValue;
      if (value is num) {
        numValue = value;
      } else {
        numValue = double.tryParse(value.toString());
      }
      if (numValue == null || !numValue.isFinite) return 'N/A';
      return numValue.toString();
    }

    showDialog(
      context: this.context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          data['name']?.toString() ?? 'Product',
          style: TextStyle(color: greenDark, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data['image'] != null && data['image'].toString().isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Image.network(
                      data['image'].toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              _InfoRow('Price', formatPrice(data['price'])),
              _InfoRow('Green Points', formatNumber(data['greenPoints'])),
              _InfoRow('CO2 Reduction', '${formatNumber(data['co2'])} kg'),
              const SizedBox(height: 8),
              Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold, color: greenDark),
              ),
              const SizedBox(height: 4),
              Text(data['description']?.toString() ?? 'No description'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: TextStyle(color: greenDark)),
          ),
        ],
      ),
    );
  }

  // 🗑️ Show Delete Confirmation Dialog
  void _showDeleteConfirmationDialog(
    BuildContext context,
    String productId,
    String productName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Product',
          style: TextStyle(color: greenDark, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete "$productName"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('Products')
                    .doc(productId)
                    .delete();
                if (!mounted) return;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text('Product deleted successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                loadProducts();
              } catch (e) {
                if (!mounted) return;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting product: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

///
/// 📦 Product Card Widget
///
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onEdit,
    required this.onDelete,
    required this.onInfo,
  });

  final String image;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🌱 Icon Container
          Container(
            width: width * 0.12,
            height: width * 0.12,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.network(image),
          ),
          const SizedBox(width: 12),

          // 📝 Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),

          // ✏️ Edit / 🗑️ Delete Buttons
          Row(
            children: [
              // info button
              _ActionButton(
                icon: Icons.info,
                background: Colors.green.shade100,
                iconColor: Colors.green.shade700,
                onPressed: onInfo,
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.edit,
                background: Colors.blue.shade100,
                iconColor: Colors.blue.shade700,
                onPressed: onEdit,
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.delete,
                background: Colors.red.shade100,
                iconColor: Colors.red.shade700,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///
/// 🔘 Small Reusable Action Button
///
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.onPressed,
  });

  final IconData icon;
  final Color background;
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }
}

///
/// 📝 Add Product Dialog Widget
///
class _AddProductDialog extends StatefulWidget {
  const _AddProductDialog({
    required this.onProductAdded,
    this.editMode = false,
    this.productId,
    this.initialName = '',
    this.initialDesc = '',
    this.initialImage = '',
    this.initialPrice = '',
    this.initialGreenPoints = '',
    this.initialCo2 = '',
  });

  final VoidCallback onProductAdded;
  final bool editMode;
  final String? productId;
  final String initialName;
  final String initialDesc;
  final String initialImage;
  final String initialPrice;
  final String initialGreenPoints;
  final String initialCo2;

  @override
  State<_AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<_AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _greenPointsController;
  late final TextEditingController _co2Controller;
  late final TextEditingController _descriptionController;
  bool imageError = false;

  String? _imagePath;
  String? _existingImageUrl;
  bool _isLoading = false;

  // Cloudinary configuration (same as editpf.dart)
  final String cloudName = 'dlmhuap1u';
  final String uploadPresent = 'Sus_living';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _priceController = TextEditingController(text: widget.initialPrice);
    _greenPointsController = TextEditingController(
      text: widget.initialGreenPoints,
    );
    _co2Controller = TextEditingController(text: widget.initialCo2);
    _descriptionController = TextEditingController(text: widget.initialDesc);
    if (widget.editMode && widget.initialImage.isNotEmpty) {
      _existingImageUrl = widget.initialImage;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _greenPointsController.dispose();
    _co2Controller.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // 📸 Pick Image from Gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  // ☁️ Upload Image to Cloudinary
  Future<String?> _uploadImageToCloudinary() async {
    if (_imagePath == null) {
      return null;
    }

    try {
      final cloudinary = CloudinaryPublic(
        cloudName,
        uploadPresent,
        cache: false,
      );

      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          _imagePath!,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      return response.secureUrl;
    } on CloudinaryException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image upload failed: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  // ✅ Validate and Save Product to Firebase
  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate image (only for new products, or if editing and no existing image)
    if (!widget.editMode && _imagePath == null) {
      imageError = true;
      setState(() {});
      return;
    }
    if (widget.editMode && _imagePath == null && _existingImageUrl == null) {
      imageError = true;
      setState(() {});
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload image to Cloudinary (only if new image is selected)
      String? imageUrl = _existingImageUrl;
      if (_imagePath != null) {
        imageUrl = await _uploadImageToCloudinary();
        if (imageUrl == null) {
          setState(() => _isLoading = false);
          return;
        }
      }

      // Parse numeric values
      final price = double.tryParse(_priceController.text.trim());
      final greenPoints = int.tryParse(_greenPointsController.text.trim());
      final co2 = double.tryParse(_co2Controller.text.trim());

      // Prepare product data
      final productData = {
        'name': _nameController.text.trim(),
        'price': price,
        'image': imageUrl,
        'greenPoints': greenPoints,
        'co2': co2,
        'description': _descriptionController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Save to Firebase Products collection
      if (widget.editMode && widget.productId != null) {
        // Update existing product
        await FirebaseFirestore.instance
            .collection('Products')
            .doc(widget.productId)
            .update(productData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Add new product
        productData['createdAt'] = FieldValue.serverTimestamp();
        await FirebaseFirestore.instance
            .collection('Products')
            .add(productData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        widget.onProductAdded();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving product: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const greenMain = Color(0xFF177A4B);
    const greenDark = Color(0xFF135E3B);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.editMode ? 'Edit Product' : 'Add New Product',
                      style: TextStyle(
                        color: greenDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Image Picker
                Center(
                  child: GestureDetector(
                    onTap: _isLoading ? null : _pickImage,
                    child: Container(
                      width: width * 0.3,
                      height: width * 0.3,
                      decoration: BoxDecoration(
                        color: greenDark.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: greenDark.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: _imagePath == null && _existingImageUrl == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  color: greenDark,
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.editMode
                                      ? 'Change Image'
                                      : 'Add Image',
                                  style: TextStyle(
                                    color: greenDark,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _imagePath != null
                                  ? kIsWeb
                                        ? Image.network(
                                            _imagePath!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(_imagePath!),
                                            fit: BoxFit.cover,
                                          )
                                  : _existingImageUrl != null
                                  ? Image.network(
                                      _existingImageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                    ),
                  ),
                ),
                if (imageError) const SizedBox(height: 10),
                if (imageError)
                  Center(
                    child: Text(
                      'Please select a product image',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 20),

                // Product Name
                Text(
                  'Product Name *',
                  style: TextStyle(
                    color: greenDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  enabled: !_isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Product name is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter product name',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Price
                Text(
                  'Price *',
                  style: TextStyle(
                    color: greenDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceController,
                  enabled: !_isLoading,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Price is required';
                    }
                    final price = double.tryParse(value.trim());
                    if (value.trim().contains(RegExp(r'[a-zA-Z]'))) {
                      return 'Only numbers are allowed for price';
                    }
                    if (price == null || price <= 0) {
                      return 'Please enter a valid price (greater than 0)';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter price (e.g., 29.99)',
                    prefixText: '\$ ',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Green Points
                Text(
                  'Green Points *',
                  style: TextStyle(
                    color: greenDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _greenPointsController,
                  enabled: !_isLoading,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Green Points is required';
                    }
                    if (value.trim().contains(RegExp(r'[a-zA-Z]'))) {
                      return 'Only numbers are allowed for green points';
                    }
                    final points = double.tryParse(value.trim());
                    if (points == null || points < 0) {
                      return 'Please enter a valid number (0 or greater)';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter green points',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // CO2
                Text(
                  'CO2 Reduction (kg) *',
                  style: TextStyle(
                    color: greenDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _co2Controller,
                  enabled: !_isLoading,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'CO2 reduction is required';
                    }
                    if (value.trim().contains(RegExp(r'[a-zA-Z]'))) {
                      return 'Only numbers are allowed for CO2 reduction';
                    }
                    final co2 = double.tryParse(value.trim());
                    if (co2 == null || co2 < 0) {
                      return 'Please enter a valid CO2 value (0 or greater)';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter CO2 reduction in kg',
                    suffixText: 'kg',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  'Description *',
                  style: TextStyle(
                    color: greenDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  enabled: !_isLoading,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
                    }
                    if (value.trim().length < 10) {
                      return 'Description must be at least 10 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter product description',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenMain,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                widget.editMode
                                    ? 'Update Product'
                                    : 'Save Product',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
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

///
/// 📋 Info Row Widget for Product Info Dialog
///
class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          Text(value, style: TextStyle(color: Colors.grey.shade900)),
        ],
      ),
    );
  }
}
