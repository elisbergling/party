import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:party/constants/colors.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final String name;
  final Color? color;
  final Color? textColor;
  final BoxFit fit;

  const CachedImage(
    this.imageUrl, {
    super.key,
    required this.height,
    required this.width,
    this.textColor,
    this.color,
    this.name = '?',
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    try {
      if (imageUrl != '') {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color ?? MyColors.blue,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: fit,
              placeholder: (context, url) => const MyLoadingWidget(),
              errorWidget: (context, url, error) => buildContainer(context),
            ),
          ),
        );
      } else {
        return buildContainer(context);
      }
    } catch (e) {
      print(e);
      return buildContainer(context);
    }
  }

  Container buildContainer(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        //color: color == null ? babyBlue : color,
        gradient: LinearGradient(
          colors: color == null
              ? [
                  MyColors.blue,
                  MyColors.purple,
                  MyColors.red,
                ]
              : [color!, color!],
          tileMode: TileMode.clamp,
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Center(
        child: Text(
          name.split('')[0],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor ?? MyColors.black,
            fontWeight: FontWeight.bold,
            fontSize: height / 2.2,
          ),
        ),
      ),
    );
  }
}
