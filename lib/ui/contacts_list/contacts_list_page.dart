import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/contact/contact_create_page.dart';
import 'package:contacts_app/ui/contacts_list/model/contacts_model.dart';
import 'package:contacts_app/ui/contacts_list/widget/contact_tile.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class contactsListPage extends StatefulWidget {
  @override
  State<contactsListPage> createState() => _contactsListPageState();
}

class _contactsListPageState extends State<contactsListPage> {
// runs when the widget initiated
  @override

// runs when the state changes
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('contacts'),
      ),
      body: ScopedModelDescendant<ContactsModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: model.contacts.length,
                // Runs& build every single list item
                itemBuilder: (context, index) {
                  return ContactTile(
                    ContactIndex: index,
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ContactCreatePage(),
          ));
        },
      ),
    );
  }
}
