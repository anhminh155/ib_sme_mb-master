import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/label.dart';
import 'package:ib_sme_mb_view/common/form_input_and_label/text_field.dart';
import '../../utils/theme.dart';

class InputFormWidget extends StatefulWidget {
  final String? label;
  final Color? colors;
  final bool? note;
  final TextEditingController? controller;
  final String? hintText;
  final bool? readOnly;
  final dynamic validator;
  final Widget? showBottomSheetWidget;
  final dynamic suffixIcon;
  final bool? obscureText;
  final dynamic fontWeight;
  final Function? onChange;
  final double? horizonalRight;
  final TextInputType? textInputType;
  final dynamic maxLines;
  const InputFormWidget(
      {super.key,
      this.label,
      this.colors,
      this.note,
      this.controller,
      this.hintText,
      this.readOnly,
      this.validator,
      this.showBottomSheetWidget,
      this.obscureText,
      this.fontWeight,
      this.onChange,
      this.suffixIcon,
      this.horizonalRight,
      this.textInputType,
      this.maxLines});

  @override
  State<InputFormWidget> createState() => _InputFormWidgetState();
}

class _InputFormWidgetState extends State<InputFormWidget> {
  @override
  Widget build(BuildContext context) {
    return renderFormInput();
  }

  renderFormInput() {
    return LabelWidget(
      fontWeight: widget.fontWeight,
      label: widget.label ?? '',
      note: widget.note ?? false,
      colors: widget.colors ?? colorBlack_727374,
      child: TextFieldWidget(
        horizontal: widget.horizonalRight,
        maxLines: widget.maxLines ?? 1,
        textInputType: widget.textInputType,
        validator: widget.validator,
        obscureText: widget.obscureText ?? false,
        controller: widget.controller ?? TextEditingController(text: ''),
        hintText: widget.hintText ?? '',
        readOnly: widget.readOnly ?? false,
        onChange: (value) {
          if (widget.onChange != null) {
            widget.onChange!(value);
          }
        },
        onTapInput: (widget.readOnly! == true)
            ? () {
                if (widget.showBottomSheetWidget != null) {
                  _showBottomSheet(widget: widget.showBottomSheetWidget);
                }
              }
            : null,
        suffixIcon: (widget.suffixIcon != null)
            ? InkWell(
                onTap: (widget.readOnly == null)
                    ? () {
                        if (widget.showBottomSheetWidget != null) {
                          _showBottomSheet(
                              widget: widget.showBottomSheetWidget);
                        }
                      }
                    : null,
                child: widget.suffixIcon,
              )
            : null,
      ),
    );
  }

  _showBottomSheet({Widget? widget}) {
    return showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: widget,
          );
        });
  }
}
