import 'package:contacts_app/data/db/contact_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:contacts_app/data/contact.dart';

class ContactsModel extends Model {
  // in more advanced app, we would't instances contactdao.
  // directly in contactModel class.
  final ContactDao _contactDao = ContactDao();

  // Unederscore act like private modifier
  late List<Contact> _contacts ;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // get only property which makes sure cannot overrite contacts
  //from different class
  List<Contact> get contacts => _contacts;
  Future loadcontacts() async {
    _isLoading = true;
    
    notifyListeners();
    debugPrint('debug: contact is not yet loaded');

    // notify listeners as soon as are loaded
    _contacts = await _contactDao.getAllInsortedOrder();
    debugPrint('debug: contact is assigned');
    _isLoading = false;
    
    notifyListeners();
    debugPrint('debug: contact is  loaded');
    
  }

  Future addContact(Contact contact) async {
    await _contactDao.insert(contact);
    await loadcontacts();

    notifyListeners();
  }

  Future removeContact(Contact contact) async {
    await _contactDao.delete(contact);
    await loadcontacts();

    notifyListeners();
  }

  Future updadeContact(Contact contact) async {
    await _contactDao.update(contact);
    await loadcontacts();

    notifyListeners();
  }

  Future changeFavoriteStatus(Contact contact) async {
    contact.isFavorite = !contact.isFavorite;
    await _contactDao.update(contact);
    // Even though we are loading all contacts, we don't want to change isLoading to true
    // That's because it would look silly to display loading indicator after only
    // changing favorite status.
    _contacts = await _contactDao.getAllInsortedOrder();

    notifyListeners();
  }
}
