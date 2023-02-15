import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/cummunitymodel.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';
import 'package:go_router/go_router.dart';

class CummunityEdit extends StatefulWidget {
  const CummunityEdit({super.key, required this.id});
  final String id;
  @override
  State<CummunityEdit> createState() => _CummunityEditState();
}

class _CummunityEditState extends State<CummunityEdit> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormBuilderState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  List<String> typeOption = ['발매정보', 'bar장소', '기타'];
  String dropdown = '게시판 선택';
  bool dropdownSelect = false;

  late CummunityModel cummunity;
  bool loading = true;

  Future<void> userCheck() async {
    final temp = await FireStoreData.getCummunity(widget.id);
    if (temp != null && temp.userid == _auth.currentUser!.uid) {
      cummunity = temp;
      dropdown = cummunity.type;
      dropdownSelect = true;
      _titleController.text = cummunity.title;
      _contentController.text = cummunity.content;
      loading = false;
      setState(() {});
    } else {
      await showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text('수정할 권한이 없습니다.'),
        ),
      ).then((value) => GoRouter.of(context).pop());
    }
  }

  Future<void> editSubmit() async {
    if (_formKey.currentState!.validate() && !dropdown.contains('게시판')) {
      if (cummunity.title == _formKey.currentState!.value['title'] &&
          cummunity.content == _formKey.currentState!.value['content']) {
        return;
      }
      FireStoreData.updateCummunity(
        cummunity.id,
        dropdown,
        _formKey.currentState!.value['title'],
        _formKey.currentState!.value['content'],
      ).then((saveok) {
        if (saveok) {
          context.goNamed('cummunityread', params: {"id": cummunity.id});
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userCheck();
  }

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.fields.clear();
    _titleController.dispose();
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: '게시판 수정'),
      body: !loading
          ? SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FormBuilder(
                  key: _formKey,
                  onChanged: () {
                    _formKey.currentState!.save();
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => AlertDialog(
                                insetPadding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                content: SizedBox(
                                  height: 110,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: typeOption
                                        .map(
                                          (option) => InkWell(
                                            onTap: () {
                                              setState(() {
                                                dropdown = option;
                                                dropdownSelect = true;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 100,
                                                        vertical: 5),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.near_me_outlined,
                                                        size: 18),
                                                    Flexible(
                                                      child: Center(
                                                        child: Text(
                                                          option,
                                                          style:
                                                              const TextStyle(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dropdown,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: dropdownSelect
                                      ? Colors.black
                                      : Colors.grey[600],
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down_outlined)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: FormBuilderTextField(
                          name: 'title',
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: '제목',
                            errorStyle: TextStyle(height: 0),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '제목을 입력해주세요.')
                          ]),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        height: 350,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: FormBuilderTextField(
                          name: 'content',
                          controller: _contentController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 50,
                          decoration: const InputDecoration(
                            hintText: '내용을 입력해주세요.',
                            border: InputBorder.none,
                            errorStyle: TextStyle(height: 0),
                            fillColor: Colors.white,
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () {
                            editSubmit();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: Text('업로드하기'))
                    ],
                  ),
                ),
              ),
            )
          : LoadingPage(height: MediaQuery.of(context).size.height),
    );
  }
}
