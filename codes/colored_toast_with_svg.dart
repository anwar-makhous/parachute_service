import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yallaharek_mobile/core/theme/app_colors.dart';
import 'package:yallaharek_mobile/core/widgets/texts/localized_text.dart';

class ColoredToastWithSvg extends StatelessWidget {
  final Color backgroundColor;
  final String localizedKey;
  final String svgResourcePath;

  ///Colored Toast with default backgroundColor = AppColors.white,
  ///please notice that this widget have to wrapped with Ftoast.showToast()
  ///after declaring a Ftoast object and calling Ftoast.init(context) inside
  /// initState
  const ColoredToastWithSvg(
      {Key? key,
      this.backgroundColor = AppColors.white,
      required this.localizedKey,
      required this.svgResourcePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 16.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(
          color: AppColors.lightGold,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: LocalizedText(
              localizedKey,
              size: 12.sp,
              textColor: AppColors.fontDark,
              //maxLines default value in Localizedtext is 100
              //but we have to set it to null to let the Text expand vertically
              maxLines: null,
              textOverflow: TextOverflow.visible,
            ),
          ),
          SvgPicture.asset(
            svgResourcePath,
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
