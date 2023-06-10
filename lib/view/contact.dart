import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasematerial/controller/contact_controller.dart';
import 'package:firebasematerial/model/contact_model.dart';
import 'package:firebasematerial/view/add_contact.dart';
import 'package:firebasematerial/view/edit_contact.dart';
import 'package:firebasematerial/view/login.dart';
import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  var cc = ContactController();

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    cc.getContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //menambahkan logout
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade400, Colors.indigo.shade700],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        NetworkImage('https://i.imgur.com/uRCRG.jpg'),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Contact',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      _logout();
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: cc.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<DocumentSnapshot> data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditContact(
                                  contactModel: ContactModel.fromMap(data[index]
                                      .data() as Map<String, dynamic>),
                                  contact: data[index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Text(
                                  data[index]['name']
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                data[index]['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                data[index]['phone'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Delete Data',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: const Text(
                                          'Are you sure you want to delete this data?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              cc.deleteContact(data[index].id);
                                              cc.getContact();
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Data ${data[index]['name']} berhasil dihapus',
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Yes',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'No',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddContact(),
            ),
          );
        },
        // ignore: sort_child_properties_last
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
