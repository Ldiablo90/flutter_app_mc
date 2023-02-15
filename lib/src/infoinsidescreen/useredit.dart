import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/usermodel.dart';
import 'package:maccave/widgets/blackelevatedbtn.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';
import 'package:go_router/go_router.dart';

class UserEditScreen extends StatefulWidget {
  const UserEditScreen({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late UserModel user;
  late String editImage;
  late String editName;
  bool loading = true;
  final ImagePicker _picker = ImagePicker();
  CroppedFile? _imageFile = null;
  bool localImage = false;

  final _formKey = GlobalKey<FormBuilderState>();
  final _nameController = TextEditingController();

  void userCheck() async {
    final temp = await FireStoreData.getUser(id: widget.id);
    if (temp.id != _auth.currentUser!.uid) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('잘못된 경로로 접속하셨습니다.'),
          );
        },
      ).then((value) => context.pop());
    }
    user = temp;
    editImage = temp.image;
    _nameController.text = temp.name;
    loading = false;
    setState(() {});
  }

  Future<void> setImagePicker() async {
    final XFile? response =
        await _picker.pickImage(source: ImageSource.gallery);
    if (response != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: response.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: '',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              lockAspectRatio: false,
              hideBottomControls: true),
          IOSUiSettings(
            title: '',
          ),
        ],
      );
      if (croppedFile != null) {
        _imageFile = croppedFile;
        editImage = croppedFile.path;
        localImage = true;
        setState(() {});
      }
    }
  }

  Future<void> editSubmit() async {
    if (_formKey.currentState!.validate()) {
      FireStoreData.updateUser(
        id: widget.id,
        cropFile: _imageFile,
        name: _formKey.currentState!.value['name'],
      ).then(
        (value) {
          if (value) {
            Navigator.pop(context, 'userinfo');
          }
        },
      );
      // context.goNamed('userinfo');
      // context.go('/userinfo');
      // context.pop();
    }
    print(_formKey.currentState!.validate());
  }

  @override
  void initState() {
    super.initState();
    userCheck();
  }

  @override
  void dispose() {
    _formKey.currentState?.fields.clear();
    _nameController.clear();
    print('유저수정페이지 디스포스');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: '회원정보 수정', center: true),
      body: !loading
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FormBuilder(
                key: _formKey,
                onChanged: () {
                  _formKey.currentState!.save();
                },
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setImagePicker();
                      },
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: localImage
                                    ? Image.file(
                                        File(editImage),
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        editImage,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional.bottomEnd,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.email,
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: .5, color: Colors.black),
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: FormBuilderTextField(
                        name: 'name',
                        controller: _nameController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: '사용자명',
                          errorStyle: TextStyle(height: 0),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                                errorText: '사용자명을 입력해주세요.')
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '010-xxxx-xxxx',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MacCaveElevatedButton(
                          onPressed: () {
                            editSubmit();
                          },
                          color: Colors.black,
                          child: const Text('수정완료'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          : LoadingPage(height: 300),
    );
  }
}
