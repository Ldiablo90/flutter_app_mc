import 'package:flutter/material.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';

class ServiceConditionsScreen extends StatelessWidget {
  const ServiceConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: '서비스 이용약관'),
      body: FutureBuilder(
        future: FireStoreData.getPrivacys("service"),
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
