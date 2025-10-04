import 'package:flutter/material.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_issue.dart';

class NursingConcernDetailPage extends StatelessWidget {
  final NursingIssue issue;

  const NursingConcernDetailPage({Key? key, required this.issue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(issue.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(issue.description),
            const SizedBox(height: 16),
            Text(
              'Images:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (issue.images.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: issue.images.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      issue.images[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              )
            else
              const Text('No images attached.'),
          ],
        ),
      ),
    );
  }
}
