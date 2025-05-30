import 'package:flutter/widgets.dart';
import '../../app_style.dart';
// import 'package:gcountyusa/theme/text_style.dart';

class GParagraphSemiBold extends StatelessWidget {
  const GParagraphSemiBold(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GAppStyle.style11w600(color: color));
  }
}
