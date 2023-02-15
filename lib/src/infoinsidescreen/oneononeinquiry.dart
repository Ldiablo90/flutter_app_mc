import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maccave/widgets/mainappbar.dart';

class OneOnOneInquiryScreen extends StatelessWidget {
  const OneOnOneInquiryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: '1:1 문의'),
      body: Center(child: Text('OneOnOneInquiry')),
    );
  }
}
