// Delete account dialog widget
import 'package:flutter/material.dart';

class DeleteAccountDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Account'),
      content: Text(
        'Are you sure you want to delete your account? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Delete'),
        ),
      ],
    );
  }
}
