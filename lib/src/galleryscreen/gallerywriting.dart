import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';
import 'package:go_router/go_router.dart';

class GalleryWriting extends StatefulWidget {
  const GalleryWriting({super.key});

  @override
  State<GalleryWriting> createState() => _GalleryWritingState();
}

class _GalleryWritingState extends State<GalleryWriting> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<XFile> _imageFile = [];
  bool sendLoading = true;
  final ImagePicker _picker = ImagePicker();

  Future<void> setImagePicker() async {
    final List<XFile> response = await _picker.pickMultiImage();
    if (response.isNotEmpty) {
      if (response.length > 3) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('3개 이상 선택이 불가능 합니다.'),
            );
          },
        );

        _imageFile = response.sublist(0, 3);
      } else {
        _imageFile = response;
      }
      setState(() {});
    }
  }

  void sendGalleryData() async {
    final result = await FireStoreData.setGallerys(
        _formKey.currentState!.value['title'], _imageFile);
    if (result) {
      context.pop();
      context.pop();
    }
  }

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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.isValid &&
                                    _imageFile.isNotEmpty) {
                                  sendGalleryData();
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: LoadingPage(height: 100),
                                      );
                                    },
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black),
                              child: const Text('업로드'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            setImagePicker();
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 330,
                            child: _imageFile.isNotEmpty
                                ? CarouselSlider(
                                    items: _imageFile
                                        .map((e) => Image.file(File(e.path)))
                                        .toList(),
                                    options: CarouselOptions(
                                      height: MediaQuery.of(context).size.width,
                                      viewportFraction: 1.0,
                                      enlargeCenterPage: false,
                                      enableInfiniteScroll: false,
                                      scrollPhysics:
                                          const BouncingScrollPhysics(),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.5, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 36,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 250,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: FormBuilderTextField(
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
                    ),
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
