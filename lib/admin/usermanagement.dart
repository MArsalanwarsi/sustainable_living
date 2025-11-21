import 'package:flutter/material.dart';
import 'package:sustainable_living/Custom/admincustomwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  String selectedSort = "A - Z";
  String searchQuery = "";
  List<Map<String, dynamic>> userData = [];
  List<Map<String, dynamic>> allUserData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    setState(() {
      isLoading = true;
    });

    try {
      // 1. Get all user documents from users collection
      QuerySnapshot userDocs = await FirebaseFirestore.instance
          .collection('users')
          .get();
      List<Map<String, dynamic>> fetchedList = userDocs.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();

      // 4. Sort initially
      allUserData = fetchedList;
      userData = sortUsers(filterUsers(searchQuery, fetchedList));

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error, e.g., show a snackbar
    }
  }

  List<Map<String, dynamic>> filterUsers(
    String query,
    List<Map<String, dynamic>> inputList,
  ) {
    if (query.isEmpty) return inputList;
    return inputList
        .where(
          (user) =>
              (user["name"] ?? "").toString().toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              (user["email"] ?? "").toString().toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();
  }

  List<Map<String, dynamic>> sortUsers(List<Map<String, dynamic>> inputList) {
    List<Map<String, dynamic>> tempList = List.from(inputList);
    switch (selectedSort) {
      case "A - Z":
        tempList.sort(
          (a, b) => ((a['name'] ?? "")).toString().toLowerCase().compareTo(
            ((b['name'] ?? "")).toString().toLowerCase(),
          ),
        );
        break;
      case "Z - A":
        tempList.sort(
          (a, b) => ((b['name'] ?? "")).toString().toLowerCase().compareTo(
            ((a['name'] ?? "")).toString().toLowerCase(),
          ),
        );
        break;
      case "Newest":
        tempList.sort((a, b) {
          final aDate = a['createdAt'] != null && a['createdAt'] is Timestamp
              ? (a['createdAt'] as Timestamp).toDate()
              : DateTime(2000);
          final bDate = b['createdAt'] != null && b['createdAt'] is Timestamp
              ? (b['createdAt'] as Timestamp).toDate()
              : DateTime(2000);
          return bDate.compareTo(aDate);
        });
        break;
      case "Oldest":
        tempList.sort((a, b) {
          final aDate = a['createdAt'] != null && a['createdAt'] is Timestamp
              ? (a['createdAt'] as Timestamp).toDate()
              : DateTime(2000);
          final bDate = b['createdAt'] != null && b['createdAt'] is Timestamp
              ? (b['createdAt'] as Timestamp).toDate()
              : DateTime(2000);
          return aDate.compareTo(bDate);
        });
        break;
    }
    return tempList;
  }

  void onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
      userData = sortUsers(filterUsers(searchQuery, allUserData));
    });
  }

  void onSortChanged(String? value) {
    if (value == null) return;
    setState(() {
      selectedSort = value;
      userData = sortUsers(filterUsers(searchQuery, allUserData));
    });
  }

  Future<void> showEditRoleDialog(Map<String, dynamic> user) async {
    String selectedRole = user["role"] ?? "User";
    String uid = user["uid"] ?? "";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit User Role"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text("User"),
              value: "User",
              groupValue: selectedRole,
              onChanged: (val) async {
                Navigator.pop(context);
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({'role': 'user'});
                await fetchAllUsers();
              },
            ),
            RadioListTile(
              title: const Text("Admin"),
              value: "Admin",
              groupValue: selectedRole,
              onChanged: (val) async {
                Navigator.pop(context);
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({'role': 'admin'});
                await fetchAllUsers();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> showDeleteDialog(Map<String, dynamic> user) async {
  //   String uid = user["uid"] ?? "";
  //   String name = user["name"] ?? "this user";
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text("Delete User"),
  //       content: Text(
  //         "Are you sure you want to delete $name? This cannot be undone.",
  //       ),
  //       actions: [
  //         TextButton(
  //           child: const Text("Cancel"),
  //           onPressed: () => Navigator.pop(context),
  //         ),
  //         TextButton(
  //           child: const Text("Delete", style: TextStyle(color: Colors.red)),
  //           onPressed: () async {
  //             Navigator.pop(context);
  //             try {

  //               await FirebaseFirestore.instance.collection('users').doc(uid).delete();
  //               await fetchAllUsers();
  //             } catch (e) {
  //               // Handle error
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F3EA),
      appBar: buildAdminCustomAppBar(context),
      bottomNavigationBar: buildAdminCustomBottomBar(context, 5),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: onSearchChanged,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        hintText: "Search users...",
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Sorting Dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedSort,
                            items: ["A - Z", "Z - A", "Newest", "Oldest"]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: onSortChanged,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  /// User List
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      final user = userData[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.green.shade200,
                              child: Text(
                                (user["name"] ?? "").isNotEmpty
                                    ? user["name"][0]
                                    : "?",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            /// Name + Email + Role
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user["name"] ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  Text(
                                    user["email"] ?? "Unavailable",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      user["role"] ?? "Unknown",
                                      style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// Edit Button
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => showEditRoleDialog(user),
                              tooltip: "Change role (Admin/User)",
                            ),

                            /// Delete Button
                            // IconButton(
                            //   icon: const Icon(Icons.delete, color: Colors.red),
                            //   onPressed: () => showDeleteDialog(user),
                            //   tooltip: "Delete user",
                            // ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
