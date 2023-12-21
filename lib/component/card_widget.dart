import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/colors.dart';
import '../helper/spacer.dart';

// ignore: must_be_immutable
class CardWidget extends StatelessWidget {
  Widget child;
  double? padding;
  double? verticalp;
  CardWidget({super.key, required this.child, this.padding, this.verticalp});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: padding ?? 10, vertical: verticalp ?? 0),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: <Color>[Color(0xffE895BF), Color(0xffB25383)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(50)),
        child: child);
  }
}

Widget backWidget({bool? forward, VoidCallback? ontap, double? padding}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment:
        forward == true ? MainAxisAlignment.end : MainAxisAlignment.start,
    children: [
      horizental(padding ?? 20),
      Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: IconButton(
            onPressed: ontap ??
                () {
                  Get.back(canPop: true);
                },
            icon: Icon(
              forward == true
                  ? Icons.arrow_forward_ios_rounded
                  : Icons.arrow_back_ios_new_rounded,
              color: AppColors.black,
            )),
      ),
      horizental(padding ?? 20),
    ],
  );
}
