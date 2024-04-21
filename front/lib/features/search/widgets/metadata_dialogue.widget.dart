// metadata_dialog.dart
import 'package:flutter/material.dart';
import 'package:pictouapi/pictouapi.dart';

Future<void> showMetadataDialog(BuildContext context, ImageMetaData metadata) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(metadata.caption),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${metadata.id}'),
            Text('Owner ID: ${metadata.ownerId}'),
            Text('tag: ${metadata.sharedWith.join(', ')}'),
            ...metadata.tags.map((tag) => Text('- $tag')).toList(),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
