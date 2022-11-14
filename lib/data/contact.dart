import 'dart:convert';

import 'dart:io';

class Contact {
  // contact id (keys)
  int? id;
  String name;
  String email;
  // String for phone number
  String phoneNumber;
  bool isFavorite;
  File? imageFile;

  // constructor with optional named parameters
  Contact({
    // required annotation makes sure that
    // an optional parameter is actually passed in
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isFavorite = false,
    this.imageFile,
    this.id,
  });

  // Map with string Keys and values with any type
  Map<String, dynamic> toMap() {
    // Map literalls are created using curly braces{}
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isFavorite': isFavorite ? 1 : 0,
      // we cannot store a file object with SEMBAST library directly.
      // That's why we only store it's  path.
      'imageFilePath': imageFile?.path,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      isFavorite: map['isFavorite'] == 1 ? true : false,
      // if there is an imagefilePath, convert it to file.
      // Otherwise set it to be null.
      imageFile:
          map['imageFilePath'] != null ? File(map['imageFilePath']) : null,
    );
  }
}
