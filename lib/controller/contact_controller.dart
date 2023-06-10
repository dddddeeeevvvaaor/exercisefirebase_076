import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasematerial/model/contact_model.dart';

class ContactController {
  final contactCollection = FirebaseFirestore.instance.collection('contacts');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  Future<void> addContact(ContactModel ctmodel) async {
    final contact = ctmodel.toMap();

    final DocumentReference docRef = await contactCollection.add(contact);

    final String docId = docRef.id;

    final ContactModel contactModel = ContactModel(
      id: docId,
      name: ctmodel.name,
      phone: ctmodel.phone,
      email: ctmodel.email,
      address: ctmodel.address,
    );
    await docRef.update(contactModel.toMap());
  }

  Future getContact() async{
    final contact = await contactCollection.get();
    streamController.add(contact.docs);
    return contact.docs;
  }

  Future<void> deleteContact(String id) async {
    await contactCollection.doc(id).delete();
    await getContact();

    
  }

  //membuat fungsi untuk mengedit data
  Future<void> updateContact(ContactModel contactModel) async {
  await contactCollection.doc(contactModel.id).update(contactModel.toMap());
  }


  Future updateContact2(String docId, ContactModel contactModel) async {
    final ContactModel updateContactModel = ContactModel(
      id: docId,
      name: contactModel.name,
      phone: contactModel.phone,
      email: contactModel.email,
      address: contactModel.address,
    );

    final DocumentSnapshot documentSnapshot =
        await contactCollection.doc(docId).get();
        if (!documentSnapshot.exists) {
          print('Document with ID $docId does not exist');
          return;
        }
        final updatedContact = updateContactModel.toMap();
        await contactCollection.doc(docId).update(updatedContact);
        await getContact();
        print('Updated contact with ID: $docId');
  }
}
