import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllTab extends StatelessWidget {
  const AllTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Entry point"),
        Icon(
          Icons.favorite,
          color: Colors.red,
          size: 48.0,
          semanticLabel: 'Text to announce in accessibility modes',
        ),
        Icon(CupertinoIcons.doc_text_fill, size: 48.0, semanticLabel: 'Add'),
        Image.network(
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
          width: 300,
          height: 200,
          fit: BoxFit.contain,
          cacheHeight: 900,
          loadingBuilder:
              (
                BuildContext context,
                Widget child,
                ImageChunkEvent? loadingProgress,
              ) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
                return const Text('Failed to load image');
              },
        ),
      ],
    );
  }
}
