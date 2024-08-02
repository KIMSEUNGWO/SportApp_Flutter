import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class SvgIcon extends StatelessWidget {

  final SvgPicture svgPicture;

  const SvgIcon({super.key, required this.svgPicture});

  static SvgIcon asset({
    required SIcon sIcon,
    SvgIconStyle? style,
  }) {
    return _SvgIconBuilder(sIcon: sIcon).build(style);
  }

  static SvgIcon assetBytes({required SIcon sIcon, SvgIconStyle? style,}) {
    return _SvgIconBuilder(sIcon: sIcon).bytesBuild(style);

}
  @override
  Widget build(BuildContext context) {
    return svgPicture;
  }

}

class SvgIconStyle {

  double? width;
  double? height;
  Color? color;
  BoxFit? fit;

  SvgIconStyle({this.width, this.height, this.color, this.fit});

}

class SIcon {

  final String picture;
  SIcon({required this.picture});

  static SIcon pen = SIcon(picture: 'assets/icons/edit.svg');

  static SIcon soccer = SIcon(picture: 'assets/icons/soccer.svg');
  static SIcon baseball = SIcon(picture: 'assets/icons/baseball.svg');
  static SIcon badminton = SIcon(picture: 'assets/icons/badminton.svg');
  static SIcon tennis = SIcon(picture: 'assets/icons/tennis.svg');
  static SIcon basketball = SIcon(picture: 'assets/icons/basketball.svg');
  static SIcon trainers = SIcon(picture: 'assets/icons/trainers.svg');

  static SIcon emptyGroupImage = SIcon(picture: 'assets/icons/emptyGroupImage.svg');
  static SIcon loginLogo = SIcon(picture: 'assets/icons/loginLogo.svg');

  static SIcon line = SIcon(picture: 'assets/line_logo.svg');

  static SIcon banner1 = SIcon(picture: 'assets/banners/icon1.svg.vec');
  static SIcon banner2 = SIcon(picture: 'assets/banners/icon2.svg.vec');
  static SIcon banner3 = SIcon(picture: 'assets/banners/icon3.svg.vec');


}

class _SvgIconBuilder {

  final SIcon sIcon;

  _SvgIconBuilder({required this.sIcon});

  SvgIcon build(SvgIconStyle? style) {
    return SvgIcon(svgPicture: SvgPicture.asset(sIcon.picture,
        width: style?.width,
        height: style?.height,
        fit: style?.fit ?? BoxFit.contain,
        color: style?.color,
    ));
  }

  SvgIcon bytesBuild(SvgIconStyle? style) {
    return SvgIcon(svgPicture: SvgPicture(AssetBytesLoader(sIcon.picture),
      width: style?.width,
      height: style?.height,
      fit: style?.fit ?? BoxFit.contain,
    ));
  }



}