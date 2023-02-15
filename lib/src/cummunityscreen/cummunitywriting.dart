import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/widgets/mainappbar.dart';

class CummunityWriting extends StatefulWidget {
  const CummunityWriting({super.key});

  @override
  State<CummunityWriting> createState() => _CummunityWritingState();
}

class _CummunityWritingState extends State<CummunityWriting> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<String> typeOption = ['발매정보', 'bar장소', '기타'];
  String dropdown = '게시판 선택';
  bool dropdownSelect = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _formKey.currentState?.fields.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: ''),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => AlertDialog(
                          insetPadding: EdgeInsets.zero,
                          // iconPadding: EdgeInsets.zero,
                          // actionsPadding: EdgeInsets.zero,
                          // contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          content: SizedBox(
                            height: 110,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 100, vertical: 5),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.near_me_outlined,
                                                  size: 18),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: Center(
                                                  child: Text(
                                                    option,
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
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: FormBuilderTextField(
                    name: 'title',
                    decoration: const InputDecoration(
                      hintText: '제목',
                      errorStyle: TextStyle(height: 0),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: '제목을 입력해주세요.')
                    ]),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  height: 350,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: FormBuilderTextField(
                    name: 'content',
                    keyboardType: TextInputType.multiline,
                    maxLines: 50,
                    decoration: const InputDecoration(
                      hintText: '내용을 입력해주세요.',
                      border: InputBorder.none,
                      errorStyle: TextStyle(height: 0),
                      fillColor: Colors.white,
                      isDense: true,
                      // filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          !dropdown.contains('게시판')) {
                        FireStoreData.setCummunity(
                          dropdown,
                          _formKey.currentState!.value['title'],
                          _formKey.currentState!.value['content'],
                        ).then((saveok) {
                          if (saveok) {
                            context.pop();
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: Text('업로드하기'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
