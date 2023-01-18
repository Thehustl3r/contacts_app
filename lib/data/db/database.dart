import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AppDatabase {
  // The only available instance  of this AppDatabase class.
  // is stored in this private field
  static final AppDatabase _singleton = AppDatabase._();

  // this instance get-only property is only way for other classes to access
  // the single AppDatabase object.
  static AppDatabase get instance => _singleton;

  // completer is used to transform synchronous code into asynchronous code
  Completer<Database>? _dbOpenCompleter;

  // A private constuctor
  // If a class specify its own constructor, it mediately losses it's default one.
  // this means by creating private constructor, We can create new instances.
  // only within its Appdatabase class itself
  AppDatabase._();

  Future<Database> get database async {
    // If completer is null , database is not yet opened.
    if (_dbOpenCompleter == null) {
      debugPrint('debug: database is not yet opened');
      log('database is not yet opened');
      _dbOpenCompleter = Completer();
      // Calling _openDatabase will also complete the completer with database instance.
      _openDatabase();

      log('database is opened');
    }
    // if the database is already opened return imediately,
    // Otherwise wait untill complete() is called on completer() in _openDatabase.
    return _dbOpenCompleter!.future;
  }

  Future _openDatabase() async {
    //  Get a platform-specific directory where persistent app data can be stored
    final Directory appDocumentDir;
    if (kIsWeb) {
      debugPrint(' is web flutter');
      appDocumentDir = await getApplicationDocumentsDirectory();
    } else {
      debugPrint(' is android flutter');
      appDocumentDir = await getApplicationDocumentsDirectory();
    }
    // path with the form: /platform-specific-directory/contacts.db
    final dbPath = p.join(appDocumentDir.path, 'contacts.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    _dbOpenCompleter!.complete(database);
    debugPrint(' database is opened');
  }
}
