import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

class IndexWidget extends StatelessWidget {
  final int index;
  const IndexWidget({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.only(left: 3, right: 5, bottom: 2),
        // width: 20,
        // height: 20,
        decoration: const BoxDecoration(
          color: primaryColor, // Màu sắc góc dưới bên phải
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(12.5), // Các góc cần được bo tròn
          ),
        ),
        child: Text(
          '$index',
          textAlign: TextAlign.center,
          style: const TextStyle(color: colorWhite, fontSize: 12),
        ),
      ),
    );
  }
}
