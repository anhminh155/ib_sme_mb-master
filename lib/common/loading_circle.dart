import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Center(
          child: LoadingAnimationWidget.discreteCircle(
              secondRingColor: secondaryColor,
              thirdRingColor: primaryColor,
              color: primaryColor,
              size: 40)),
    );
  }
}
