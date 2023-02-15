import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/gallerymodel.dart';
import 'package:maccave/widgets/blackelevatedbtn.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';
import 'package:go_router/go_router.dart';

class GalleryEdit extends StatefulWidget {
  const GalleryEdit({super.key, required this.id});
  final String id;
  @override
  State<GalleryEdit> createState() => _GalleryEditState();
}

class _GalleryEditState extends State<GalleryEdit> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormBuilderState>();
  late GalleryModel gallery;
  final _titleController = TextEditingController();
  bool loading = true;

  Future<void> userCheck() async {
    final temp = await FireStoreData.getGalleryItem(widget.id);
    if (temp != null && temp.userid == _auth.currentUser!.uid) {
      _titleController.text = temp.title;
      loading = false;
      gallery = temp;
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

  @override
  void initState() {
    super.initState();
    userCheck();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _formKey.currentState?.fields.clear();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: ''),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  FormBuilder(
                    key: _formKey,
                    onChanged: () {
                      _formKey.currentState!.save();
                    },
                    child: !loading
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MacCaveElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.isValid) {
                                        if (_formKey.currentState!
                                                    .value['title'] !=
                                                null &&
                                            _formKey.currentState!
                                                    .value['title'] !=
                                                gallery.title) {
                                          FireStoreData.updateGallery(
                                                  widget.id,
                                                  _formKey.currentState!
                                                      .value['title'])
                                              .then(
                                            (value) {
                                              if (value) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: const Text(
                                                          '수정이 완료되었습니다.'),
                                                      actionsAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      actions: [
                                                        MacCaveElevatedButton(
                                                          child:
                                                              const Text('확인'),
                                                          onPressed: () {
                                                            context.pop();
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  },
                                                ).then(
                                                    (value) => context.goNamed(
                                                          'galleryreading',
                                                          params: {
                                                            "id": gallery.id
                                                          },
                                                        ));
                                              }
                                            },
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content:
                                                    const Text('수정사항이 없습니다.'),
                                                actionsAlignment:
                                                    MainAxisAlignment.center,
                                                actions: [
                                                  MacCaveElevatedButton(
                                                    child: const Text('확인'),
                                                    onPressed: () {
                                                      context.pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
                                    child: const Text('수정하기'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 330,
                                child: CarouselSlider(
                                  items: gallery.images
                                      .map((image) => Image.network(image))
                                      .toList(),
                                  options: CarouselOptions(
                                    height: MediaQuery.of(context).size.width,
                                    viewportFraction: 1.0,
                                    enlargeCenterPage: false,
                                    enableInfiniteScroll: false,
                                    scrollPhysics:
                                        const BouncingScrollPhysics(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 250,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(5)),
                                child: FormBuilderTextField(
                                  controller: _titleController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 15,
                                  name: 'title',
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    hintText: '내용을 입력해 주세요.',
                                    border: InputBorder.none,
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                            ],
                          )
                        : LoadingPage(height: 300),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
