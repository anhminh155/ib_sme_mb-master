import 'package:flutter/material.dart';

class LabelWidget extends StatefulWidget {
  const LabelWidget(
      {super.key,
      required this.child,
      required this.label,
      required this.colors,
      this.padding,
      this.alignment,
      this.fontWeight,
      this.note});

  final dynamic colors;
  final String label;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final bool? note;
  final dynamic fontWeight;

  @override
  State<LabelWidget> createState() => _LabelWidgetState();
}

class _LabelWidgetState extends State<LabelWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: widget.alignment,
            child: Row(
              children: [
                if (widget.label.isNotEmpty)
                  Text(
                    widget.label,
                    style: TextStyle(
                        color: widget.colors,
                        fontSize: 14,
                        fontWeight: widget.fontWeight ?? FontWeight.w600,
                        height: 1.5),
                  ),
                (widget.note == null || widget.note == false)
                    ? Container()
                    : Text(
                        " *",
                        style: TextStyle(
                          color: Colors.red.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      )
              ],
            ),
          ),
          if (widget.label.isNotEmpty)
            const SizedBox(
              height: 5.0,
            ),
          Container(
            alignment: widget.alignment,
            width: MediaQuery.of(context).size.width,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
