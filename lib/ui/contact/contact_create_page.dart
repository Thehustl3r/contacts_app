import 'package:contacts_app/ui/contact/widget/contact_forn.dart';
import 'package:flutter/material.dart';

class ContactCreatePage extends StatelessWidget {
  const ContactCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create'),
      ),
      body: ContactForm(),
    );
  }
}
