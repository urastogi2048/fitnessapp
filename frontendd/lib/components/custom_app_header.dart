import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppHeader extends StatelessWidget {
  final String? backLabel;
  final VoidCallback? onBackPressed;
  final String title;
  final Widget? trailing;

  const CustomAppHeader({
    super.key,
    this.backLabel,
    this.onBackPressed,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button with Label
        if (backLabel != null)
          InkWell(
            onTap: onBackPressed ?? () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.grey,
                    size: 14.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    backLabel!,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          InkWell(
            onTap: onBackPressed ?? () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
              child: Icon(
                FontAwesomeIcons.arrowLeft,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ),
        SizedBox(height: 16.h),
        // Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 28.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.manrope().fontFamily,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ],
    );
  }
}
