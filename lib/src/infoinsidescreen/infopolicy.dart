import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/privacysmodel.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';

class InfoPolicyScreen extends StatelessWidget {
  const InfoPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: '개인정보 처리방침'),
      body: FutureBuilder(
        future: FireStoreData.getPrivacys("policy"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Center(
                    child:
                        Text(snapshot.data!.content.replaceAll("\\n", "\n"))),
              ),
            );
          }
          return LoadingPage(height: 350);
        },
      ),
    );
  }
}
