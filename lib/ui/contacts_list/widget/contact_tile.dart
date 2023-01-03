import 'dart:io';

import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/contact/widget/contact_edit_page.dart';
import 'package:contacts_app/ui/contacts_list/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ContactTile extends StatelessWidget {
  const ContactTile({
    Key? key,
    required this.contactIndex,
  }) : super(key: key);
  final int contactIndex;

  @override
  Widget build(BuildContext context) {
    // if you don't need to rebuild the widget tree once the model data changes
    // (when you only make changes to the model, like this contact card)
    // call scopedModell.of<T>()function
    final model = ScopedModel.of<ContactsModel>(context);
    final displayedContact = model.contacts[contactIndex];
    return Slidable(
      // delegate is for choosing the animation while sliding
      key: const ValueKey(1),

      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: ((context) {
              model.removeContact(displayedContact);
            }),
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: ((context) => _callPhonenumber(
                  context,
                  displayedContact.phoneNumber,
                )),
            backgroundColor: Colors.green,
            icon: Icons.phone,
            label: 'Call',
          ),
          SlidableAction(
            onPressed: ((context) =>
                _writeEmail(context, displayedContact.email)),
            backgroundColor: Colors.blue,
            icon: Icons.mail,
            label: 'Email',
          ),
        ],
      ),

      child: _buildContent(
        context,
        displayedContact,
        model,
      ),
    );
  }

  Future _callPhonenumber(
    BuildContext context,
    String number,
  ) async {
    final Uri url = Uri(
      scheme: 'tel:',
      path: number,
    );
    if (await url_launcher.canLaunchUrl(url)) {
      await url_launcher.launchUrl(url);
    } else {
      const snackbar = SnackBar(
        content: Text("cannnot make a call"),
      );
      // showing an error message
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future _writeEmail(
    BuildContext context,
    String emailAddress,
  ) async {
    final Uri url = Uri(
      scheme: 'mail to',
      path: emailAddress,
    );
    if (await url_launcher.canLaunchUrl(url)) {
      await url_launcher.launchUrl(url);
    } else {
      const snackbar = SnackBar(
        content: Text("cannnot write an email"),
      );
      // showing an error message
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Container _buildContent(
    BuildContext context,
    Contact displayedContact,
    ContactsModel model,
  ) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: ListTile(
        title: Text(displayedContact.name),
        subtitle: Text(displayedContact.email),
        leading: _buildCircleAvatar(displayedContact),
        trailing: IconButton(
          onPressed: (() {
            model.changeFavoriteStatus(displayedContact);
          }),
          icon: Icon(
            displayedContact.isFavorite ? Icons.star : Icons.star_border,
            color: displayedContact.isFavorite ? Colors.amber : Colors.grey,
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ContactEditPage(
                editedContact: displayedContact,
              ),
            ),
          );
        },
      ),
    );
  }

  Hero _buildCircleAvatar(Contact displayedContact) {
    return Hero(
      tag: displayedContact.hashCode,
      child: CircleAvatar(
        child: _buildCircleAvatarContent(displayedContact),
      ),
    );
  }

  Widget _buildCircleAvatarContent(Contact displayedContact) {
    if (displayedContact.imageFile == null) {
      return Text(
        displayedContact.name[0],
      );
    } else {
      return ClipOval(
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            displayedContact.imageFile as File,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
