import 'package:flutter/material.dart';
import 'package:ib_sme_mb_view/common/show_toast.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import 'package:ib_sme_mb_view/page/bao_cao/bao_cao.dart';
import 'package:ib_sme_mb_view/page/chuyen_tien/Transactions/transaction_create/transaction_create.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/giao_dich_bang_ke_cho_duyet/tim_kiem_bang_ke_cho_duyet.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/giao_dich_cho_duyet/tim_kiem_giao_dich_cho_duyet.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_danh_sach_lenh_tu_choi/tim_kiem_lenh_tu_choi.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_giao_dich_thong_thuong/quan_ly_giao_dich_thong_thuong.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_lenh_tuong_lai_dinh_ky/tim_kiem_giao_dich_tuong_lai_dinh_ky.dart';
import 'package:ib_sme_mb_view/page/quan_ly_giao_dich/quan_ly_trang_thai_bang_ke/tim_kiem_trang_thai_bang_ke.dart';
import 'package:ib_sme_mb_view/provider/favorite_product_provider.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';
import 'package:provider/provider.dart';

class FavoriteServiceWidget extends StatefulWidget {
  final RolesAcc? rolesAcc;
  const FavoriteServiceWidget({super.key, this.rolesAcc});

  @override
  State<FavoriteServiceWidget> createState() => _FavoriteServiceWidgetState();
}

class _FavoriteServiceWidgetState extends State<FavoriteServiceWidget> {
  List<FavoriteProducts> listFavoriteProduct = [];
  RolesAcc? rolesAcc;
  @override
  void initState() {
    super.initState();
    rolesAcc = widget.rolesAcc;
    listFavoriteProduct =
        Provider.of<FavoriteProductProvider>(context, listen: false).items;
  }

  checkIconFavorite(String product) {
    IconData icon;
    switch (product) {
      case "1":
        icon = Icons.autorenew;
        return icon;
      case "2":
        icon = Icons.send;
        return icon;
      case "3":
        icon = Icons.account_balance;
        return icon;
      case "4":
        icon = Icons.view_comfy;
        return icon;
      case "5":
        icon = Icons.bolt;
        return icon;
      case "6":
        icon = Icons.smartphone;
        return icon;
      case "7":
        icon = Icons.water_drop;
        return icon;
      case "8":
        icon = Icons.wifi;
        return icon;
      case "9":
        icon = Icons.call_end;
        return icon;
      case "10":
        icon = Icons.compare_arrows;
        return icon;
      case "11":
        icon = Icons.update;
        return icon;
      case "12":
        icon = Icons.playlist_remove;
        return icon;
      case "13":
        icon = Icons.done_all;
        return icon;
      case "14":
        icon = Icons.plagiarism;
        return icon;
      case "15":
        icon = Icons.view_comfy;
        return icon;
      case "16":
        icon = Icons.monetization_on;
        return icon;
      default:
        return null;
    }
  }

  checkRouteWidgetFavorite(String product) {
    Widget widget;
    switch (product) {
      case "1":
        widget = TransactionsCreate(
          tranType: TransType.CORE.name,
        );
        return widget;
      case "2":
        widget = TransactionsCreate(
          tranType: TransType.NAPAS.name,
        );
        return widget;
      case "3":
        widget = TransactionsCreate(
          tranType: TransType.CITAD.name,
        );
        return widget;
      case "4":
        widget = TransactionsCreate(
          tranType: TransType.CTBK.name,
        );
        return widget;
      case "5":
        widget = showToast(
          context: context,
          msg: 'Chức năng này đang được cập nhật',
          color: Colors.orange,
        );
        return widget;
      case "6":
        widget = showToast(
          context: context,
          msg: 'Chức năng này đang được cập nhật',
          color: Colors.orange,
        );
        return widget;
      case "7":
        widget = showToast(
          context: context,
          msg: 'Chức năng này đang được cập nhật',
          color: Colors.orange,
        );
        return widget;
      case "8":
        widget = showToast(
          context: context,
          msg: 'Chức năng này đang được cập nhật',
          color: Colors.orange,
        );
        return widget;
      case "9":
        widget = showToast(
          context: context,
          msg: 'Chức năng này đang được cập nhật',
          color: Colors.orange,
        );
        return widget;
      case "10":
        widget = const QuanLyGiaoDichThongThuong();
        return widget;
      case "11":
        widget = const QuanLyLenhTuongLaiDinhKy();
        return widget;
      case "12":
        widget = const SearchDanhSachLenhTuChoi();
        return widget;
      case "13":
        widget = QuanLyGiaoDichChoDuyet(rolesAcc: rolesAcc);
        return widget;
      case "14":
        widget = const GiaoDichBangKeChoDuyet();
        return widget;
      case "15":
        widget = const QuanLyGiaoDichBangKe();
        return widget;
      case "16":
        widget = const BaoCaoPhiGaoDich(routate: 1);
        return widget;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (listFavoriteProduct.isNotEmpty)
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (FavoriteProducts item in listFavoriteProduct)
                Expanded(
                  child: FavoriteServiceItem(
                      icon: checkIconFavorite(item.product!),
                      text: FAVORITES.getStringByValue(item.product!, context),
                      onTapWidget: checkRouteWidgetFavorite(item.product!)),
                ),
            ],
          )
        : const SizedBox();
  }
}

class FavoriteServiceItem extends StatelessWidget {
  final IconData icon;
  final Widget onTapWidget;
  final String text;
  const FavoriteServiceItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTapWidget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _handleCardItemClick(context, onTapWidget);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(139, 146, 165, 0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 24,
              color: secondaryColor,
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colorBlack_727374,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  _handleCardItemClick(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }
}
