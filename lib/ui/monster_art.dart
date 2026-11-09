import 'dart:math' as math;

import 'package:flutter/material.dart';

class MonsterArt extends StatefulWidget {
  const MonsterArt({
    super.key,
    required this.sceneAsset,
    required this.characterAsset,
    required this.description,
  });

  final String sceneAsset;
  final String characterAsset;
  final String description;

  @override
  State<MonsterArt> createState() => _MonsterArtState();
}

class _MonsterArtState extends State<MonsterArt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounce = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: widget.description,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final characterWidth = math.min(width * 0.80, height * 1.26);
        final bounceHeight = widget.characterAsset.endsWith('cowering.png')
            ? 2.0
            : 7.0;
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                widget.sceneAsset,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            AnimatedBuilder(
              animation: _bounce,
              builder: (context, child) => Positioned(
                left: -5,
                bottom:
                    height * 0.02 +
                    math.sin(_bounce.value * math.pi) * bounceHeight,
                width: characterWidth,
                height: height * 0.94,
                child: child!,
              ),
              child: Image.asset(widget.characterAsset, fit: BoxFit.contain),
            ),
          ],
        );
      },
    ),
  );
}
