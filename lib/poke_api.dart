import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pokemon.dart';

class PokeApi {
  static const base = 'https://pokeapi.co/api/v2';

  // ดึง type จริงของโปเกม่อนตาม id
  static Future<List<String>> fetchPokemonTypes(int id) async {
    final res = await http.get(Uri.parse('$base/pokemon/$id'));
    if (res.statusCode != 200) throw Exception('Failed to load types');

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final typesList = data['types'] as List<dynamic>;

    // แปลงเป็น List<String> พร้อม capitalize
    return typesList
        .map((t) => (t['type']['name'] as String))
        .map((s) => s[0].toUpperCase() + s.substring(1))
        .toList();
  }

  // ดึงรายชื่อโปเกม่อน และ type จริง
  static Future<List<Pokemon>> fetchPokemon({int limit = 20}) async {
    final uri = Uri.parse('$base/pokemon?limit=$limit');
    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Failed to load Pokémon');
    }

    final data = json.decode(res.body) as Map<String, dynamic>;
    final results = (data['results'] as List).cast<Map<String, dynamic>>();

    final List<Pokemon> list = [];

    for (var item in results) {
      final url = item['url'] as String;
      final idStr = url.split('pokemon/').last.replaceAll('/', '');
      final id = int.parse(idStr);

      final types = await fetchPokemonTypes(id); // ดึง type จริง

      final img =
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

      list.add(Pokemon(
        id: id,
        name: item['name'][0].toUpperCase() + item['name'].substring(1),
        imageUrl: img,
        types: types,
      ));
    }

    return list;
  }
}
