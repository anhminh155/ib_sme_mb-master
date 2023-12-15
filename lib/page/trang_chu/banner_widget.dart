// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ib_sme_mb_view/base/base_component.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/model/model.dart';
import 'package:ib_sme_mb_view/network/services/banner_service.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

import '../../model/models.dart';

class ImageBanerFile {
  int id;
  dynamic file;

  ImageBanerFile({required this.id, required this.file});
}

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> with BaseComponent {
  List<ImageBanerFile> listImageBanner = [];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  getListBanner() async {
    BaseResponseDataList responseDataList =
        await BannerService().getListBanner();
    if (responseDataList.errorCode == FwError.THANHCONG.value) {
      if (responseDataList.data != null) {
        listResponse = responseDataList.data!
            .map((banner) => BannerModel.fromJson(banner))
            .toList();
        convertBase64ToFile(listResponse);
      }
    }
  }

  convertBase64ToFile(listResponse) async {
    for (BannerModel items in listResponse) {
      if (items.fileClob != null) {
        var unit8List = base64Decode(items.fileClob!);
        ui.Image image = await decodeImage(unit8List);

        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        ImageBanerFile imageBannerFile =
            ImageBanerFile(id: items.id!, file: pngBytes);

        if (mounted) {
          setState(() {
            listImageBanner.add(imageBannerFile);
          });
        }
      }
    }
  }

  Future<ui.Image> decodeImage(Uint8List bytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  void initState() {
    getListBanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (listImageBanner.isNotEmpty)
        ? Column(children: [
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    // print(currentIndex);
                  },
                  child: CarouselSlider(
                    items: listImageBanner
                        .map(
                          (item) => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              item.file,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        )
                        .toList(),
                    carouselController: carouselController,
                    options: CarouselOptions(
                      scrollPhysics: const BouncingScrollPhysics(),
                      autoPlay: true,
                      aspectRatio: 2.5,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: listImageBanner.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () =>
                            carouselController.animateToPage(entry.key),
                        child: Container(
                          width: currentIndex == entry.key ? 17 : 7,
                          height: 7.0,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: currentIndex == entry.key
                                  ? secondaryColor
                                  : Colors.black26),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ])
        : Container();
  }
}
