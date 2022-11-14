import 'dart:io' as a;
import 'dart:convert';

import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/contacts_list/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactForm extends StatefulWidget {
  final Contact? editedContact;

  ContactForm({
    Key? key,
    this.editedContact,
  }) : super(key: key);
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  // keys allow us to access widgets from  a different place in the code
  // They are something like View IDs if you are familiar with android development
  final _formkey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _phoneNumber;

  a.File? _contactImageFile;

  bool get isEditMode => widget.editedContact != null;
  bool get isSelectedCustomImage => _contactImageFile != null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _contactImageFile = widget.editedContact?.imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formkey,
        child: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            SizedBox(height: 10),
            _buildContactPicture(),
            SizedBox(height: 10),
            TextFormField(
              initialValue: widget.editedContact?.name,
              onSaved: (Value) => _name = Value,
              validator: _validateName,
              decoration: InputDecoration(
                  labelText: 'name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: widget.editedContact?.email,
              onSaved: (Value) => _email = Value,
              validator: _validateEmail,
              decoration: InputDecoration(
                  labelText: 'email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: widget.editedContact?.phoneNumber,
              onSaved: (Value) => _phoneNumber = Value,
              validator: _validatePhoneNumber,
              decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
            ),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: _onSaveContactButtonPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('SAVE CONTACT'),
                  SizedBox(width: 5),
                  Icon(Icons.person, size: 18),
                ],
              ),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
            ),
          ],
        ));
  }

  Widget _buildContactPicture() {
    final halfScreenDiameter = MediaQuery.of(context).size.width / 2;
    return Hero(
      tag: widget.editedContact?.hashCode ?? 0,
      child: GestureDetector(
        onTap: _onContactPictureTapped,
        child: CircleAvatar(
          radius: halfScreenDiameter / 2,
          child: _buildCircleEditorContact(halfScreenDiameter),
        ),
      ),
    );
  }

  void _onContactPictureTapped() async {
    final imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _contactImageFile = a.File(imageFile!.path);
    });
  }

  Widget _buildCircleEditorContact(double halfScreenDiameter) {
    if (isEditMode || isSelectedCustomImage) {
      return _buildEditModeCircleAvatarContent(halfScreenDiameter);
    } else {
      return Icon(
        Icons.person,
        size: halfScreenDiameter / 2,
      );
    }
  }

  Widget _buildEditModeCircleAvatarContent(double halfScreenDiameter) {
    if (_contactImageFile == null) {
      return Text(
        widget.editedContact!.name[0],
        style: TextStyle(fontSize: halfScreenDiameter / 2),
      );
    } else {
      return Image.file(_contactImageFile as a.File);
    }
  }

  //  validators either return an error string or null
  // if the value is the correct format
  String? _validateName(String? value) {
    if (value!.isEmpty) {
      return 'Enter a name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final emailregex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value!.isEmpty) {
      return 'Enter an Email';
    } else if (!emailregex.hasMatch(value)) {
      return 'Enter a valid eamil address';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    final phoneregex = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    if (value!.isEmpty) {
      return 'Enter an phone numberl';
    } else if (!phoneregex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  void _onSaveContactButtonPressed() {
    //  Accessing the form through _formkey
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      final newOrContact = Contact(
        name: _name!,
        email: _email!,
        phoneNumber: _phoneNumber!,
        // elvis operator ?. returns null if edited contact is null
        // Null coalescing operator (??)
        // if the left side is null, it returns teh right side
        isFavorite: widget.editedContact?.isFavorite ?? false,
        imageFile: _contactImageFile,
      );
      if (isEditMode) {
        // Id doesn't change after updating other contact fields
        newOrContact.id = widget.editedContact!.id;
        ScopedModel.of<ContactsModel>(context).updadeContact(
          newOrContact,
        );
      } else {
        ScopedModel.of<ContactsModel>(context).addContact(newOrContact);
      }

      Navigator.of(context).pop();
    }
  }
}
