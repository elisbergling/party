import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:party/constants/colors.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final String name;
  final Color color;
  final Color textColor;

  final BoxFit fit;

  CachedImage(
    this.imageUrl, {
    this.height,
    this.width,
    this.name = '?',
    this.color,
    this.textColor,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    try {
      if (imageUrl != null && imageUrl != '') {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color == null ? blue : color,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: fit,
              placeholder: (context, url) => MyLoadingWidget(),
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
                  blue,
                  purple,
                  red,
                ]
              : [color, color],
          tileMode: TileMode.clamp,
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: name != null
          ? Center(
              child: Text(
                name.split('')[0],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor == null ? black : textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: height / 2.2,
                ),
              ),
            )
          : Container(height: 0.0, width: 0.0),
    );
  }
}
