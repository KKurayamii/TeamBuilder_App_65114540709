import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'pokemon.dart';
import 'poke_api.dart';

class PokemonController extends GetxController {
  final allPokemon = <Pokemon>[].obs;
  final selectedIds = <int>[].obs; // เก็บ id ที่เลือก (สูงสุด 3)
  final query = ''.obs;
  final teamName = 'My Team'.obs;

  final _box = GetStorage();
  static const _kTeamIds = 'team_ids';
  static const _kTeamName = 'team_name';

  // โหลดรายการ + กู้คืนทีม
  @override
  void onInit() {
    super.onInit();
    _restore();
    _load();
    // บันทึกอัตโนมัติเมื่อมีการเปลี่ยนแปลง
    ever<List<int>>(selectedIds, (_) => _persist());
    ever<String>(teamName, (_) => _persist());
  }

  Future<void> _load() async {
    try {
      final list = await PokeApi.fetchPokemon(limit: 151);
      allPokemon.assignAll(list);
    } catch (_) {
      // fallback: ถ้าเน็ตล่มก็อย่างน้อยให้แอปไม่พัง
      allPokemon.assignAll([]);
    }
  }

  void toggle(Pokemon p) {
    if (selectedIds.contains(p.id)) {
      selectedIds.remove(p.id);
    } else {
      if (selectedIds.length >= 3) {
        Get.snackbar('Team full', 'เลือกได้สูงสุด 3 ตัว');
        return;
      }
      selectedIds.add(p.id);
    }
  }

  bool isSelected(Pokemon p) => selectedIds.contains(p.id);

  void resetTeam() {
    selectedIds.clear();
  }

  List<Pokemon> get filtered {
  final q = query.value.trim().toLowerCase();
  if (q.isEmpty) return allPokemon;
  return allPokemon.where((p) {
    final name = p.name.toLowerCase().trim();
    return name.contains(q);
  }).toList();
}

  List<Pokemon> get selectedPokemon =>
      allPokemon.where((p) => selectedIds.contains(p.id)).toList();

  void _persist() {
    _box.write(_kTeamIds, selectedIds);
    _box.write(_kTeamName, teamName.value);
  }

  void _restore() {
    final ids = _box.read<List>(_kTeamIds)?.cast<int>() ?? <int>[];
    final name = _box.read<String>(_kTeamName);
    selectedIds.assignAll(ids);
    if (name != null && name.isNotEmpty) teamName.value = name;
  }
}
