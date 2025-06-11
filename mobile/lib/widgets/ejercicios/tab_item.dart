import 'package:flutter/material.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/widgets/ejercicios/tab_info.dart';

class TabItem extends StatelessWidget {
  final String title;

  const TabItem({
    required this.title,
    super.key
    });


  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title, 
            style: Theme.of(context).textTheme.titleMedium
            ),
        ],
      )
    );
  }
}