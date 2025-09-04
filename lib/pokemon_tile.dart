import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'pokemon.dart';
import 'pokemon_controller.dart';

class PokemonTile extends StatelessWidget {
  final Pokemon p;
  const PokemonTile({super.key, required this.p});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PokemonController>();
    return Obx(() {
      final selected = c.isSelected(p);
      return AnimatedScale(
        scale: selected ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: p.imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                placeholder: (_, __) => const SizedBox(
                  width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ),
          ),
          title: Text(
            '#${p.id}  ${p.name.capitalizeFirst!}',
            style: TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          trailing: Icon(
            selected ? Icons.check_circle : Icons.circle_outlined,
            size: 24,
          ),
          onTap: () => c.toggle(p),
        ),
      );
    });
  }
}
