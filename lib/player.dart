import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pokemon_controller.dart';
import 'home.dart';

class TeamView extends StatefulWidget {
  const TeamView({super.key});

  @override
  State<TeamView> createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
  final c = Get.find<PokemonController>();
  late final TextEditingController _teamController;

  @override
  void initState() {
    super.initState();
    _teamController = TextEditingController(text: c.teamName.value);

    // Sync teamName Rx กับ TextEditingController
    _teamController.addListener(() {
      c.teamName.value = _teamController.text;
    });

    ever<String>(c.teamName, (val) {
      if (_teamController.text != val) {
        _teamController.text = val;
      }
    });
  }

  @override
  void dispose() {
    _teamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Team'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAll(() => HomeView()),
        ),
        actions: [
          IconButton(
            onPressed: c.resetTeam,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final team = c.selectedPokemon;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ชื่อทีม
              TextField(
                controller: _teamController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อทีม',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // แสดงจำนวนสมาชิกทีม
              Text(
                'สมาชิกทีม (${team.length}/3)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              // Grid แสดงโปเกม่อนในทีม
              Expanded(
                child: team.isEmpty
                    ? const Center(child: Text('ยังไม่ได้เลือกสมาชิก'))
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: team.length,
                        itemBuilder: (_, i) {
                          final p = team[i];
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: FadeTransition(opacity: animation, child: child),
                              );
                            },
                            child: Card(
                              key: ValueKey(p.id),
                              elevation: 2,
                              child: InkWell(
                                onTap: () => c.toggle(p), // แตะเพื่อเอาออก
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // รูปโปเกม่อน
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Image.network(
                                          p.imageUrl,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    // ชื่อโปเกม่อน
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: Text(
                                        p.name.capitalizeFirst!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // ประเภทโปเกม่อน (Type)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6, top: 2),
                                      child: Text(
                                        'Type: ${p.types.join(', ')}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontStyle: FontStyle.italic),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 4),
              Text(
                'แตะการ์ดเพื่อเอาออก / กลับหน้าแรกเพื่อเพิ่ม',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        }),
      ),
    );
  }
}
