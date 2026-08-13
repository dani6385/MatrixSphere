
library core_widgets;

import 'package:flutter/material.dart';
/// A widget that provides empty space with a specified width or height.
class Gap extends StatelessWidget {
  final double? width;
  final double? height;

  const Gap({
    super.key,
    this.width,
    this.height,
  }) : assert(width != null || height != null, 'Either width or height must be provided.');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}