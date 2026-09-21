/*
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constraints/app_strings.dart';

class CustomNetworkImage extends StatelessWidget {
  final String image;
  final String? localImage;
  final double? borderRadius;
  final double? height;
  final double? width;
  final BoxFit? fit;

  const CustomNetworkImage({
    this.height,
    this.width,
    required this.image,
    this.localImage,
    this.borderRadius,
    this.fit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return image.isNotEmpty
        ? Container(
            height: height,
            width: width,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? 0),
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: image,
              fit: fit ?? BoxFit.cover,
              placeholder: (_, __) => _loadingBuilder(),
              errorWidget: (_, __, ___) => _errorBuilder(),
            ),
          )
        : Container(
            height: height,
            width: width,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? 0),
              ),
            ),
            child: _errorBuilder(),
          );
  }

  /// A default loading builder
  Widget _loadingBuilder() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
      ),
    );
  }

  /// A default error builder
  Widget _errorBuilder() {
    return Image.asset(
      localImage ?? AppImagePath.avatar,
      fit: fit ?? BoxFit.cover,
    );
  }
}

 */


import 'package:flutter/material.dart';
import '../constraints/app_strings.dart';

class CustomNetworkImage extends StatelessWidget {
  final String image;
  final String? localImage;
  final double? borderRadius;
  final double? height;
  final double? width;
  final BoxFit? fit;

  const CustomNetworkImage({
    this.height,
    this.width,
    required this.image,
    this.localImage,
    this.borderRadius,
    this.fit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isValidUrl = Uri.tryParse(image)?.hasAbsolutePath ?? false;

    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius ?? 0),
        ),
      ),
      child: isValidUrl
          ? Image.network(
        image,
        fit: fit ?? BoxFit.cover,
        height: height,
        width: width,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _loadingBuilder();
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint("Failed to load image: $error");
          return _errorBuilder();
        },
      )
          : _errorBuilder(),
    );
  }

  /// A default loading builder
  Widget _loadingBuilder() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
      ),
    );
  }

  /// A default error builder
  Widget _errorBuilder() {
    return Image.asset(
      localImage ?? AppImagePath.avatar,
      fit: fit ?? BoxFit.cover,
      height: height,
      width: width,
    );
  }
}

