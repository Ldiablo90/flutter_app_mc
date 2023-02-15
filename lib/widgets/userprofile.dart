import 'package:flutter/material.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/usermodel.dart';
import 'package:go_router/go_router.dart';
import 'package:maccave/widgets/loddinpage.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key, required this.user}) : super(key: key);
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(128),
                  child: Image.network(
                    user.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.email),
                    Text(user.name),
                  ],
                ),
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: const Icon(Icons.settings),
                      onTap: () {
                        // Navigator.pushNamed(context, 'useredit',
                        //     arguments: {"id": user.id});
                        context.pushNamed(
                          'useredit',
                          params: {"id": user.id},
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: FireStoreData.getCumAndGallCount(user.id),
          builder: (context, snapshot) {
            double itemwidth = 75;
            if (snapshot.hasData) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: itemwidth,
                        child: Column(
                          children: [
                            const Text('포인트(에정)'),
                            Text('${user.mileage_points}'),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      SizedBox(
                        width: itemwidth,
                        child: InkWell(
                          onTap: () {
                            context.pushNamed(
                              'mycontents',
                              params: {"id": user.id},
                            );
                          },
                          child: Column(
                            children: [
                              const Text('게시물'),
                              Text('${snapshot.data!}'),
                            ],
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      SizedBox(
                        width: itemwidth,
                        child: InkWell(
                          onTap: () {
                            context.pushNamed(
                              'mydrinklist',
                              params: {"id": user.id},
                            );
                          },
                          child: Column(
                            children: [
                              const Text('술찜리스트'),
                              Text('${user.drinklikes.length}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return LoadingPage(height: 62);
          },
        ),
      ],
    );
  }
}
