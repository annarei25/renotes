import 'package:flutter/material.dart';

import '../models/etiqueta.dart';
import '../theme/app_dimensions.dart';
import 'tag_chip.dart';

/// Muestra varias etiquetas en un Wrap, para que pasen a la línea
/// siguiente cuando no caben (requisito de scroll del PDF).
class TagWrap extends StatelessWidget {
  final List<Etiqueta> etiquetas;
  final void Function(Etiqueta etiqueta)? onTap;

  const TagWrap({super.key, required this.etiquetas, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: 6,
      children: [
        for (final etiqueta in etiquetas)
          TagChip(
            etiqueta: etiqueta,
            onTap: onTap == null ? null : () => onTap!(etiqueta),
          ),
      ],
    );
  }
}
