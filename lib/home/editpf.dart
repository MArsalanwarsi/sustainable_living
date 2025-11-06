import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? name;
  String? email;
  String? role;
  String? uid;
  String? profile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _showEditIcon = false;
  // NOTE: In a real app, these values should be secured, perhaps via a build config or Firebase Remote Config.
  final String cloudName = 'dlmhuap1u';
  final String uploadPresent = 'Sus_living';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Dispose controllers
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    if (user == null) {
      // Use pushReplacementNamed to prevent user from going back to this screen
      Navigator.pushReplacementNamed(context, '/Login');
    } else {
      uid = user?.uid;
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          role = data['role'];

          if (role == 'admin') {
            // Redirect admin users
            Navigator.pushReplacementNamed(context, '/AdminDashboard');
          } else {
            name = data['name'];
            // Use the email from FirebaseAuth as it's the source of truth for auth
            email = user?.email;
            profile = data['profile_image'];

            // Initialize controllers with fetched data
            _nameController.text = name ?? '';
            _emailController.text = email ?? '';

            print("profile data $profile");
            setState(() {});
          }
        }
      } catch (e) {
        // Handle any errors that might occur during the fetch
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error fetching user data: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // Marked as Future<String?> to clearly indicate return type
  Future<String?> uploadImageToCloudinary() async {
    // Check if the current profile path is a local file path
    if (profile != null && !profile!.startsWith('http')) {
      try {
        final cloudinary = CloudinaryPublic(
          cloudName,
          uploadPresent,
          cache: false,
        );

        // 1. Upload the file from the local path
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            profile!,
            resourceType: CloudinaryResourceType.Image,
          ),
        );

        // 2. Get the secure URL from the response
        return response.secureUrl;
      } on CloudinaryException catch (e) {
        print('Cloudinary Error: ${e.message}');
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
    return profile; // Return existing URL if no new file was picked
  }

  // **FIX: Made async and awaited the uploadImageToCloudinary call**
  Future<void> updateData() async {
    if (formKey.currentState!.validate()) {
      String? finalProfileUrl = profile;
      bool imageUpdated = false;

      // Check if a new image was selected (it will be a local file path)
      if (profile != null && !profile!.startsWith('http')) {
        // Show loading indicator or disable button here in a real app


        // Await the asynchronous upload operation
        finalProfileUrl = await uploadImageToCloudinary();
        imageUpdated = true;

        if (finalProfileUrl == null) {
          // Upload failed, stop the profile update
          return;
        }
      }

      // Determine final values, preferring the controller text (which may be the original value)
      // The old logic of setting controller text before update is redundant if controllers are initialized.
      String newName = _nameController.text.trim();
      String newEmail = _emailController.text.trim();

      // Only update if the name or email has actually changed, or if the image was updated
      if (newName != name || newEmail != email || imageUpdated) {
        FirebaseAuth.instance.currentUser?.verifyBeforeUpdateEmail(newEmail).catchError((error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Email update failed: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({
              'name': newName,
              'profile_image':
                  finalProfileUrl, // Use the awaited URL or the existing one
            })
            .then((_) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                // After successful update, navigate back to Profile screen
                Navigator.pushReplacementNamed(context, '/Profile');
              }
            })
            .catchError((error) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update profile: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No changes detected.'),
              backgroundColor: Colors.blueGrey,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/name.png', height: 58, fit: BoxFit.contain),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pushReplacementNamed(context, '/Profile'),
        ),
      ),
      backgroundColor: const Color(0xFFEAF4EA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              GestureDetector(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      profile = pickedFile.path;
                    });
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 1.0, // Remove opacity for better visibility
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.green.shade100,
                        backgroundImage: profile != null
                            ? (profile!.startsWith('http')
                                  ? NetworkImage(profile!)
                                  : FileImage(File(profile!)) as ImageProvider)
                            : null,
                        child: (profile == null || profile == '')
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.green.shade700,
                              )
                            : null,
                      ),
                    ),
                    MouseRegion(
                      onEnter: (_) => setState(() => _showEditIcon = true),
                      onExit: (_) => setState(() => _showEditIcon = false),
                      child: AnimatedOpacity(
                        opacity:
                            _showEditIcon ||
                                (profile == null || profile!.isEmpty)
                            ? 1.0
                            : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.green,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Change Photo",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 25),

              // Form Container
              Form(
                key: formKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Full Name",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          final text = value?.trim() ?? '';
                          if (text.isEmpty && (name == null || name!.isEmpty)) {
                            return 'Please enter your full name';
                          }
                          if (text.isNotEmpty && text.length < 3) {
                            return 'Name must be at least 3 characters';
                          }
                          if (text.isNotEmpty &&
                              !RegExp(r'^[a-zA-Z\s]+$').hasMatch(text)) {
                            return 'Name can only contain letters and spaces';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          hintText:
                              name ??
                              'Enter your name', // Use hintText instead of hint: Text()
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Email Address",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          final text = value?.trim() ?? '';
                          if (text.isEmpty &&
                              (email == null || email!.isEmpty)) {
                            return 'Please enter your email';
                          }
                          if (text.isNotEmpty &&
                              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(text)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          hintText: email ?? 'Enter your email',
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // Call the async updateData function
                            updateData();
                          },
                          child: const Text(
                            "Save Changes",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // Navigate back to the previous screen
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
    );
  }
}
