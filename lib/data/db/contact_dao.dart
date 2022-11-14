import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/data/db/database.dart';
import 'package:sembast/sembast.dart';

class ContactDao {
  static const String contact_store_name = 'contacts';
  // A store with int keys and Map<String, Dynamics> values.
  // This is what we need since we convert contact object to map.
  final _contactStore = intMapStoreFactory.store(contact_store_name);
  Future get _db async => await AppDatabase.instance.database;
  Future insert(Contact contact) async {
    await _contactStore.add(
      await _db,
      contact.toMap(),
    );
  }

  Future update(Contact contact) async {
    // Finder object allows filter by key, field values and more.
    final finder = Finder(
      filter: Filter.byKey(contact.id),
    );

    await _contactStore.update(
      await _db,
      contact.toMap(),
      finder: finder,
    );
  }

  Future delete(Contact contact) async {
    final finder = Finder(
      filter: Filter.byKey(contact.id),
    );
    await _contactStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Contact>> getAllInsortedOrder() async {
    // Finder object can also facilitates sorting.
    // As before, we are primaly sorting based on isFavorite status.
    // secondary sorting is alphabetical
    final finder = Finder(
      sortOrders: [
        // False indicates that is favorite will be saved in desceding order
        // false should be displayed after true for isFavorite.
        SortOrder('isFavorite', false),
        SortOrder('name'),
      ],
    );
    final recordSnapshots = await _contactStore.find(
      await _db,
      finder: finder,
    );

    // Map iterates over the whole list and give us access to every element
    // it also returns a new list containing different values (Contact objects)

    return recordSnapshots.map((snapshot) {
      final contact = Contact.fromMap(snapshot.value);
      contact.id = snapshot.key;
      return contact;
    }).toList();
  }
}
