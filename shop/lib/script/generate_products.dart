import 'dart:math';
import 'package:pocketbase/pocketbase.dart';

Future<void> main() async {
  final pb = PocketBase('http://127.0.0.1:8090');

 await pb.admins.authWithPassword('anna.sa.65@ubu.ac.th', 'anat123456');

  final rand = Random();
  final adjectives = ['Cool', 'Smart', 'Fresh', 'Eco', 'Super', 'Quick', 'Happy', 'Magic', 'Bright', 'Prime'];
  final nouns = ['Gadget', 'Shoes', 'Bag', 'Watch', 'Lamp', 'Book', 'Toy', 'Bottle', 'Chair', 'Phone'];

  for (int i = 0; i < 100; i++) {
    final name = '${adjectives[rand.nextInt(adjectives.length)]} ${nouns[rand.nextInt(nouns.length)]} #${rand.nextInt(9999)}';
    final price = (rand.nextInt(9000) + 100) / 100.0;
    final imageUrl = 'https://picsum.photos/seed/${rand.nextInt(100000)}/200/200';

    final body = {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    };

    try {
      final record = await pb.collection('products').create(body: body);
      print('✅ Product $i created: ${record.data['name']}');
    } catch (e) {
      print('❌ Failed to create product $i: $e');
    }
  }

  print('🎉 Done creating 100 products!');
}
