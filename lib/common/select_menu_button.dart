import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ib_sme_mb_view/utils/theme.dart';

titleListMenu({title}) {
  return Text(
    title,
    style: const TextStyle(
        color: colorBlack_15334A, fontSize: 17, fontWeight: FontWeight.w600),
  );
}

selectMenuButton(
    {required BuildContext context,
    required Color colors,
    required String content,
    imageSVG,
    imagePNG,
    required Widget widget,
    Function? handleClick}) {
  return InkWell(
    onTap: () async {
      if (handleClick != null) {
        final result = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => widget));
        handleClick(result);
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                settings: const RouteSettings(name: "/page1"),
                builder: (context) => widget));
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: colors, borderRadius: BorderRadius.circular(5.0)),
      child: Row(children: [
        imagePNG == null
            ? imageSVG == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SvgPicture.asset(
                      imageSVG,
                      width: 24,
                      height: 24,
                    ),
                  )
            : Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Image.asset(
                  imagePNG,
                  height: 24,
                  width: 24,
                  color: primaryColor,
                  colorBlendMode: BlendMode.modulate,
                ),
              ),
        Expanded(
          child: Text(
            content,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        )
      ]),
    ),
  );
}
