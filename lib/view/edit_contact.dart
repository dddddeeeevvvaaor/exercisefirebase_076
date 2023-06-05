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
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: TextEditingController(
                  text: widget.contactModel.name,
                ),
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
                onChanged: (value) => name = value,
              ),
              TextFormField(
                controller: TextEditingController(
                  text: widget.contactModel.phone,
                ),
                decoration: const InputDecoration(
                  hintText: 'Phone',
                ),
                onChanged: (value) => phone = value,
              ),
              TextFormField(
                controller: TextEditingController(
                  text: widget.contactModel.email,
                ),
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                onChanged: (value) => email = value,
              ),
              TextFormField(
                controller: TextEditingController(
                  text: widget.contactModel.address,
                ),
                decoration: const InputDecoration(
                  hintText: 'Address',
                ),
                onChanged: (value) => address = value,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: const Text('Update Contact'),
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
