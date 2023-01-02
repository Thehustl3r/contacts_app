import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/contact/widget/contact_forn.dart';
import 'package:flutter/material.dart';

class ContactEditPage extends StatelessWidget {
  final Contact editedContact;

  const ContactEditPage({
    Key? key,
    required this.editedContact,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
      ),
      body: ContactForm(
        editedContact: editedContact,
      ),
    );
  }
}
