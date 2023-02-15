import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maccave/widgets/mainappbar.dart';

class AskQuestionsScreen extends StatelessWidget {
  const AskQuestionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: '자주 묻는 질문'),
      body: Center(
        child: Text('AskQuestionsScreen'),
      ),
    );
  }
}
