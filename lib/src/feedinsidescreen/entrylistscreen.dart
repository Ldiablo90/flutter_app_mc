import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/entrymodel.dart';
import 'package:maccave/widgets/feed/feeditem.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';

class EntryListScreen extends StatefulWidget {
  const EntryListScreen({super.key});

  @override
  State<EntryListScreen> createState() => _EntryListScreenState();
}

class _EntryListScreenState extends State<EntryListScreen> {
  late List<EntryModel> entryList;
  bool loadding = true;
  Future<void> setEntryListData() async {
    entryList = await FireStoreData.getEntrys();
    loadding = false;
    setState(() {});
  }

  @override
  void initState() {
    setEntryListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: ''),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: !loadding
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    ...entryList
                        .map<Widget>(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: FeedItem(entry: e),
                          ),
                        )
                        .toList(),
                  ],
                ),
              )
            : LoadingPage(height: 300),
      ),
    );
  }
}
