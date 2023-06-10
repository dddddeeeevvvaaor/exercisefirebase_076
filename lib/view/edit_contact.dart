import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasematerial/controller/contact_controller.dart';
import 'package:firebasematerial/model/contact_model.dart';
import 'package:firebasematerial/view/contact.dart';
import 'package:flutter/material.dart';

class EditContact extends StatefulWidget {
  ContactModel contactModel;
  EditContact({
    Key? key,
    required DocumentSnapshot<Object?> contact,
    required this.contactModel,
  }) : super(key: key);

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  var contactController = ContactController();
  final formKey = GlobalKey<FormState>();
  String? name;
  String? phone;
  String? email;
  String? address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Contact'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: TextEditingController(
                  text: widget.contactModel.name,
                ),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: const TextStyle(color: Colors.indigo),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.indigo.withOpacity(0.5)),
                  ),
                ),
                onChanged: (value) => name = value,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: TextEditingController(
                  text: widget.contactModel.phone,
                ),
                decoration: InputDecoration(
                  labelText: 'Phone',
                  labelStyle: const TextStyle(color: Colors.indigo),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.indigo.withOpacity(0.5)),
                  ),
                ),
                onChanged: (value) => phone = value,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: TextEditingController(
                  text: widget.contactModel.email,
                ),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.indigo),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.indigo.withOpacity(0.5)),
                  ),
                ),
                onChanged: (value) => email = value,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: TextEditingController(
                  text: widget.contactModel.address,
                ),
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: const TextStyle(color: Colors.indigo),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.indigo.withOpacity(0.5)),
                  ),
                ),
                onChanged: (value) => address = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text(
                  'Update Contact',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ContactModel cm = ContactModel(
                      id: widget.contactModel.id,
                      name: name ?? widget.contactModel.name,
                      phone: phone ?? widget.contactModel.phone,
                      email: email ?? widget.contactModel.email,
                      address: address ?? widget.contactModel.address,
                    );
                    contactController.updateContact(cm);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contact Updated'),
                        duration: Duration(seconds: 1),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Contact(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
