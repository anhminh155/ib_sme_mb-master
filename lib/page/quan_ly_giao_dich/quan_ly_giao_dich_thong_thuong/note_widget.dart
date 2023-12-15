import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/card_layout.dart';

import '../../../utils/theme.dart';

class NoteWidget extends StatefulWidget {
  final String? taiKhoanNguon;
  const NoteWidget({super.key, this.taiKhoanNguon});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isRotated = false;

  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(_controller);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Nếu đã hoàn thành xoay 180 độ
        // Thực hiện hành động bạn muốn ở đây
        setState(() {
          _isRotated = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleRotation() {
    setState(() {
      _isRotated = !_isRotated;
      if (_isRotated) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _renderNote();
  }

  _renderNote() {
    return CardLayoutWidget(
      child: Column(children: [
        if (widget.taiKhoanNguon != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Tài khoản nguồn"),
              Text(widget.taiKhoanNguon ?? '')
            ],
          ),
        if (widget.taiKhoanNguon != null)
          const Divider(
            color: primaryColor,
          ),
        if (widget.taiKhoanNguon != null)
          const SizedBox(
            height: 5.0,
          ),
        InkWell(
          onTap: _toggleRotation,
          child: Row(
            children: [
              const Icon(
                Icons.error,
                color: primaryColor,
              ),
              const SizedBox(
                width: 8.0,
              ),
              const Text(
                "Lưu ý: ",
                style: TextStyle(color: primaryColor),
              ),
              const Text(" Trạng thái giao dịch"),
              const Expanded(
                child: SizedBox(),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Transform.rotate(
                    angle: _animation.value * 2.0 * 3.141592653589793,
                    child: child!,
                  );
                },
                child: const Icon(
                  Icons.arrow_drop_down_sharp,
                ),
              ),
            ],
          ),
        ),
        if (_isRotated == true)
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 6.0,
            ),
            renderTextNote('Chờ duyệt:',
                ' Giao dịch đã được lập thành công bởi mã lập lệnh và chưa được duyệt bởi mã quản trị/mã duyệt lệnh.'),
            const SizedBox(
              height: 6.0,
            ),
            renderTextNote('Đã duyệt:',
                ' Lệnh giao dịch đã được duyệt bởi mã duyệt lệnh/quản trị'),
            const SizedBox(
              height: 6.0,
            ),
            renderTextNote('Từ chối:',
                ' Lệnh giao dịch bị từ chối bởi mã duyệt lệnh/quản trị.'),
            const SizedBox(
              height: 6.0,
            ),
            renderTextNote(
                'Thành công:', ' Lệnh giao dịch đã thực hiện thành công.'),
            const SizedBox(
              height: 6.0,
            ),
            renderTextNote('Lỗi:', ' Lệnh giao dịch bị lỗi.')
          ]),
      ]),
    );
  }

  renderTextNote(label, content) {
    return Text.rich(
      TextSpan(
        text: '• $label',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
              text: content,
              style: const TextStyle(fontWeight: FontWeight.normal)),
        ],
      ),
      textAlign: TextAlign.justify,
    );
  }
}
