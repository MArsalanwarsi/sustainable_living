import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sustainable_living/Custom/admincustomwidget.dart';

class AdminForumListScreen extends StatefulWidget {
  const AdminForumListScreen({super.key});

  @override
  State<AdminForumListScreen> createState() => _AdminForumListScreenState();
}

class _AdminForumListScreenState extends State<AdminForumListScreen> {
  String selectedSort = 'Newest';
  String searchQuery = '';

  Color get greenMain => const Color(0xFF448C2F);
  Color get greenDark => const Color(0xFF205907);
  Color get mintBackground => const Color(0xFFE6F3EA);

  Stream<QuerySnapshot<Map<String, dynamic>>> get feedsStream =>
      FirebaseFirestore.instance.collection('Feeds').snapshots();

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _sortAndFilterPosts(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> filtered = docs.where((
      doc,
    ) {
      final data = doc.data();
      final query = searchQuery.toLowerCase();
      return (data['title']?.toString().toLowerCase().contains(query) ??
              false) ||
          (data['description']?.toString().toLowerCase().contains(query) ??
              false) ||
          (data['name']?.toString().toLowerCase().contains(query) ?? false);
    }).toList();

    filtered.sort((a, b) {
      final dataA = a.data();
      final dataB = b.data();
      final dtA = (dataA['createdDate'] as Timestamp?)?.toDate();
      final dtB = (dataB['createdDate'] as Timestamp?)?.toDate();
      if (selectedSort == 'Newest') {
        return (dtB ?? DateTime(2000)).compareTo(dtA ?? DateTime(2000));
      } else if (selectedSort == 'Oldest') {
        return (dtA ?? DateTime(2000)).compareTo(dtB ?? DateTime(2000));
      } else if (selectedSort == 'A - Z') {
        String nameA = dataA['name']?.toString().toLowerCase() ?? '';
        String nameB = dataB['name']?.toString().toLowerCase() ?? '';
        return nameA.compareTo(nameB);
      } else if (selectedSort == 'Z - A') {
        String nameA = dataA['name']?.toString().toLowerCase() ?? '';
        String nameB = dataB['name']?.toString().toLowerCase() ?? '';
        return nameB.compareTo(nameA);
      }
      return 0;
    });
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: mintBackground,
      appBar: buildAdminCustomAppBar(context),
      bottomNavigationBar: buildAdminCustomBottomBar(context, 3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // 🏷 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Forum Feed',
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

              // ➕ Add New Feed Button
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
                      onPressed: _showAddPostDialog,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Add New Post',
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
                  // Search
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(13),
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
                          hintText: 'Search posts...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Sort Dropdown
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(13),
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
                              value: 'Newest',
                              child: Text('Newest'),
                            ),
                            DropdownMenuItem(
                              value: 'Oldest',
                              child: Text('Oldest'),
                            ),
                            DropdownMenuItem(
                              value: 'A - Z',
                              child: Text('A - Z'),
                            ),
                            DropdownMenuItem(
                              value: 'Z - A',
                              child: Text('Z - A'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => selectedSort = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: feedsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text(
                      'No posts found.',
                      style: TextStyle(color: Colors.grey),
                    );
                  }
                  final filteredDocs = _sortAndFilterPosts(snapshot.data!.docs);

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      final data = doc.data();
                      return _FacebookPostCard(
                        title: data['title'] ?? '',
                        desc: data['description'] ?? '',
                        imageUrl: data['imageUrl'],
                        status: data['status'] ?? '',
                        datetime:
                            (data['createdDate'] as Timestamp?)?.toDate() ??
                            DateTime.now(),
                        onInfo: () => _showPostInfoDialog(data),
                        onEdit: () => _showEditPostDialog(doc),
                        onDelete: () => _showDeleteConfirmationDialog(doc),
                        greenDark: greenDark,
                      );
                    },
                  );
                },
              ),

              SizedBox(height: height * 0.06),
            ],
          ),
        ),
      ),
    );
  }

  // Dialogs and Actions

  void _showAddPostDialog() {
    showDialog(
      context: context,
      builder: (ctx) => FeedCrudDialog(
        onComplete: () {
          Navigator.of(ctx).pop();
        },
        type: FeedCrudType.add,
      ),
    );
  }

  void _showEditPostDialog(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    showDialog(
      context: context,
      builder: (ctx) => FeedCrudDialog(
        onComplete: () {
          Navigator.of(ctx).pop();
        },
        type: FeedCrudType.edit,
        doc: doc,
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Post"),
        content: Text(
          "Are you sure you want to delete this post by ${data["name"]}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Feeds')
                  .doc(doc.id)
                  .delete();
              Navigator.of(ctx).pop();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showPostInfoDialog(Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(post['name'] ?? "--"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (post['title'] != null)
              Text(
                post['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            if (post['description'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(post['description']),
              ),
            if (post['category'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    const Icon(Icons.category, size: 18),
                    const SizedBox(width: 6),
                    Text(post['category']),
                  ],
                ),
              ),
            if (post['status'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 18),
                    const SizedBox(width: 6),
                    Text("Status: ${post['status']}"),
                  ],
                ),
              ),
            if (post['createdDate'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      (post['createdDate'] is Timestamp)
                          ? (post['createdDate'] as Timestamp)
                                .toDate()
                                .toString()
                                .substring(0, 16)
                          : post['createdDate'].toString().substring(0, 16),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}

/// Facebook style post card
class _FacebookPostCard extends StatelessWidget {
  final String title;
  final String desc;
  final String? imageUrl;
  final String status;
  final DateTime datetime;
  final VoidCallback onInfo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Color greenDark;

  const _FacebookPostCard({
    required this.title,
    required this.desc,
    required this.imageUrl,
    required this.status,
    required this.datetime,
    required this.onInfo,
    required this.onEdit,
    required this.onDelete,
    required this.greenDark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - avatar, name, time, action icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: const AssetImage('assets/name.png'),
                  child: Container(), // No child so the image is shown clearly
                  // If you want an icon overlay only if image fails, use backgroundImage.
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sustainable Living",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: greenDark,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        datetime.toLocal().toString().substring(0, 16),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'info') onInfo();
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(value: 'info', child: Text("View")),
                    const PopupMenuItem(value: 'edit', child: Text("Edit")),
                    const PopupMenuItem(value: 'delete', child: Text("Delete")),
                  ],
                  icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Title & description
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            if (desc.isNotEmpty) ...[
              const SizedBox(height: 7),
              Text(desc, style: const TextStyle(fontSize: 14)),
            ],
            if (imageUrl != null && imageUrl!.isNotEmpty) ...[
              const SizedBox(height: 13),
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 170,
                ),
              ),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

///
/// Feed Create/Edit Dialog with Cloudinary Image Upload (Web-Safe)
///
enum FeedCrudType { add, edit }

class FeedCrudDialog extends StatefulWidget {
  final VoidCallback onComplete;
  final FeedCrudType type;
  final QueryDocumentSnapshot<Map<String, dynamic>>? doc;

  const FeedCrudDialog({
    required this.onComplete,
    required this.type,
    this.doc,
    Key? key,
  }) : super(key: key);

  @override
  State<FeedCrudDialog> createState() => _FeedCrudDialogState();
}

class _FeedCrudDialogState extends State<FeedCrudDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  DateTime? _createdDate;
  String? _imageUrl;
  bool _isLoading = false;
  XFile? _pickedFile; // Use XFile instead of dart:io File for compatibility

  @override
  void initState() {
    super.initState();
    if (widget.type == FeedCrudType.edit && widget.doc != null) {
      final data = widget.doc!.data();
      _title.text = data['title'] ?? '';
      _desc.text = data['description'] ?? '';
      _imageUrl = data['imageUrl'];
      _createdDate =
          (data['createdDate'] as Timestamp?)?.toDate() ?? DateTime.now();
    } else {
      _createdDate = DateTime.now();
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() {
        _pickedFile = picked;
      });
      await _uploadToCloudinary(_pickedFile!);
    }
  }

  // Web-friendly Cloudinary upload using http.MultipartRequest, XFile.bytes, and XFile.name.
  Future<void> _uploadToCloudinary(XFile xfile) async {
    setState(() {
      _isLoading = true;
    });

    // Replace with your Cloudinary Cloud Name and unsigned preset
    final String cloudName = 'dlmhuap1u';
    final String uploadPreset = 'Sus_living';

    try {
      final bytes = await xfile.readAsBytes();

      var uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );
      var request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = uploadPreset;

      // Use MultipartFile.fromBytes for web support
      request.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: xfile.name),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final body =
            json.decode(await response.stream.bytesToString())
                as Map<String, dynamic>;
        _imageUrl = body['secure_url'];
        setState(() {});
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Image Upload Failed.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Image Upload Error: $e')));
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    setState(() => _isLoading = true);

    final data = <String, dynamic>{
      "title": _title.text.trim(),
      "description": _desc.text.trim(),
      "createdDate": _createdDate ?? DateTime.now(),
      "imageUrl": _imageUrl ?? "",
      "status": widget.type == FeedCrudType.edit && widget.doc != null
          ? widget.doc!.data()['status'] ?? "Approved"
          : "Approved",
    };

    if (widget.type == FeedCrudType.add) {
      await FirebaseFirestore.instance.collection('Feeds').add(data);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post Added!')));
    } else {
      await FirebaseFirestore.instance
          .collection('Feeds')
          .doc(widget.doc!.id)
          .update(data);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post Updated!')));
    }
    setState(() => _isLoading = false);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.type == FeedCrudType.add ? "Add New Post" : "Edit Post",
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TITLE
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Title is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              // DESC
              TextFormField(
                controller: _desc,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Description is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Image
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _imageUrl != null && _imageUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.network(
                            _imageUrl!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _pickImage,
                      icon: const Icon(Icons.upload_file),
                      label: Text(_isLoading ? "Uploading..." : "Upload Photo"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Created Date (readonly)
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Created Date",
                  border: const OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                initialValue: _createdDate != null
                    ? _createdDate.toString().substring(0, 16)
                    : "",
              ),

              if (_isLoading) ...[
                const SizedBox(height: 12),
                const LinearProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (!_isLoading) Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: Text(widget.type == FeedCrudType.add ? "Add" : "Update"),
        ),
      ],
    );
  }
}
