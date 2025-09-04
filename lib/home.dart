import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pokemon_controller.dart';
import 'pokemon_tile.dart';
import 'app_pages.dart';

class HomeView extends GetView<PokemonController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Pokémon (${c.selectedIds.length}/3)')),
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () => Get.toNamed(Routes.team),
            tooltip: 'ทีมของฉัน',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: c.resetTeam,
            tooltip: 'Reset Team',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'ค้นหาโปเกมอน...',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => c.query.value = v,
            ),
          ),
          Expanded(
            child: Obx(() {
              final list = c.filtered;
              if (list.isEmpty) {
                return const Center(child: Text('กำลังโหลดหรือไม่พบข้อมูล'));
              }
              return ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => PokemonTile(p: list[i]),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() => FloatingActionButton.extended(
            onPressed: () => Get.toNamed(Routes.team),
            label: Text('ทีมของฉัน (${c.selectedIds.length}/3)'),
            icon: const Icon(Icons.check),
          )),
    );
  }
}
