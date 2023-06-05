import 'package:firebasematerial/controller/contact_controller.dart';
import 'package:firebasematerial/model/contact_model.dart';
import 'package:firebasematerial/view/contact.dart';
import 'package:flutter/material.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  var contactController = ContactController();
  final formkey = GlobalKey<FormState>();

  String? name;
  String? phone;
  String? email;
  String? address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              TextFormField(
                  decoration: InputDecoration(hintText: 'Name'),
                  onChanged: (value) {
                    name = value;
                  }),
              TextFormField(
                decoration: InputDecoration(hintText: 'Phone'),
                onChanged: (value) {
                  phone = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Email'),
                onChanged: (value) {
                  email = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Address'),
                onChanged: (value) {
                  address = value;
                },
              ),
              //jika data ditambahkan maka akan diarahkan ke halaman contact dan data akan ditambahkan ke firebase dan ditampilkan di halaman contact kemudian halaman contact akan di refresh
              /*ElevatedButton(
                child: Text('Add Contact'),
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    print('validated');
                  } else {
                    print('not validated');
                  }
                  contactController.addContact(ContactModel(
                    name: name!,
                    phone: phone!,
                    email: email!,
                    address: address!,
                  ));
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Contact(),
                      ),
                      (route) => false);
                },
              ),*/
              ElevatedButton(
                child: const Text('Add Contact'),
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    ContactModel cm = ContactModel(
                      name: name!,
                      phone: phone!,
                      email: email!,
                      address: address!,
                    );

                    contactController.addContact(cm).then((_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Contact()),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contact Added'),
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.green,
                        ),
                      );
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
