import 'package:contacts_app/ui/contact/contact_create_page.dart';
import 'package:contacts_app/ui/contacts_list/model/contacts_model.dart';
import 'package:contacts_app/ui/contacts_list/widget/contact_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactsListPage extends StatefulWidget {
  const ContactsListPage({Key? key}) : super(key: key);

  @override
  State<ContactsListPage> createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
// runs when the widget initiated
  @override

// runs when the state changes
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('contacts'),
      ),
      body: ScopedModelDescendant<ContactsModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: model.contacts.length,
                // Runs& build every single list item
                itemBuilder: (context, index) {
                  return ContactTile(
                    contactIndex: index,
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const ContactCreatePage(),
          ));
        },
      ),
    );
  }
}
