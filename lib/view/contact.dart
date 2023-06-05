import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasematerial/controller/contact_controller.dart';
import 'package:firebasematerial/model/contact_model.dart';
import 'package:firebasematerial/view/add_contact.dart';
import 'package:firebasematerial/view/edit_contact.dart';
import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  var cc = ContactController();

  @override
  void initState() {
    // TODO: implement initState
    cc.getContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 130,
                  height: 100,
                  child: Image.network('https://i.imgur.com/uRCRG.jpg'),
                ),
                const SizedBox(width: 40), // Jarak antara gambar dan teks
                const Text(
                  'Contact',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
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
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onLongPress: () {
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
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Text(
                                  data[index]['name']
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(data[index]['name']),
                              subtitle: Text(data[index]['phone']),
                              //membuat iconbutton untuk edit data
                              //jika data dihapus maka akan mereload data dan membuat pilihan untuk menghapus data yes or no dan snackbar untuk notifikasi data berhasil dihapus dan buatkan edit data
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Delete Data'),
                                        content: const Text(
                                            'Are you sure want to delete this data?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              cc.deleteContact(data[index].id);
                                              cc.getContact();
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      //teks data nama yang dihapus
                                                      'Data berhasil dihapus'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            },
                                            child: const Text('Yes'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No'),
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
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => const AddContact()),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
