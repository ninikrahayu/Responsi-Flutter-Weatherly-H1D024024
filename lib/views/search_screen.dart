import 'package:flutter/material.dart';

import '../widgets/nothing_card.dart';
import '../widgets/section_title.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('CARI LOKASI')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        TextField(
          decoration: InputDecoration(
            hintText: 'Cari nama kota...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        SizedBox(height: 24),
        SectionTitle(title: 'Lokasi Favorit'),
        SizedBox(height: 16),
        NothingCard(
          child: Text('Belum ada favorit', textAlign: TextAlign.center),
        ),
      ],
    ),
  );
}
