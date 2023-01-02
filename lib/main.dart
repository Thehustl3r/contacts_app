import 'package:contacts_app/ui/contacts_list/contacts_list_page.dart';
import 'package:contacts_app/ui/contacts_list/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Scoped model widget will make sure that we can access the contactsModel
    // anywhere down to widget tree. This is possible because of Flutter's
    // inheritedWidget which is a bit advanced to briefly explain, but if you
    // have a drive to learn it, flutter doc can help you.
    return ScopedModel(
      // load all contact  from the database as soon as the app starts
      model: ContactsModel()..loadcontacts(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ContactsListPage(),
      ),
    );
  }
}
