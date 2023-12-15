import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastWidget extends StatelessWidget {
  final Color color;
  final Icon? icon;
  final String msg;
  const ToastWidget(
      {Key? key, required this.msg, required this.color, this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 40),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(color: const Color.fromRGBO(255, 129, 130, 0.4)),
        color: color,
      ),
      child: IntrinsicWidth(
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon!,
                  const SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                      child: Text(
                    msg,
                    textAlign: TextAlign.center,
                  )),
                ],
              )
            : Text(
                msg,
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}

showToast(
    {required BuildContext context,
    required String msg,
    required Color color,
    Icon? icon}) {
  FToast fToast = FToast();

  fToast.init(context);
  return fToast.showToast(
    child: ToastWidget(msg: msg, color: color, icon: icon),
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 3),
    positionedToastBuilder: (context, child) {
      return Positioned(
        top: 60.0,
        right: 20.0,
        child: child,
      );
    },
  );
}
