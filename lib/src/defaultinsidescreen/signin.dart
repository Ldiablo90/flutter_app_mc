import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:maccave/firebaseserver/firebaseauth.dart';
import 'package:maccave/widgets/mainappbar.dart';
import 'package:go_router/go_router.dart';
import 'package:maccave/widgets/sosiallogin.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailValue = TextEditingController();
  final passValue = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  bool _emailHasError = false;
  bool _passHasError = false;

  void inputClear() {
    emailValue.clear();
    passValue.clear();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _formKey.currentState?.fields.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext maincontext) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: 'SignInScreen'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .55,
              child: Image.asset(
                'assets/maccavelogoblack.png',
                fit: BoxFit.cover,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                '맥케이브 어플로 로그인하고\n실시간 주류 발매정보를 얻으세요',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  FormBuilder(
                    key: _formKey,
                    onChanged: () {
                      _formKey.currentState!.save();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('이메일 주소'),
                        FormBuilderTextField(
                          controller: emailValue,
                          name: 'email',
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(height: 0),
                            suffixIcon: _emailHasError
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(
                                    Icons.check,
                                    color: Colors.blue,
                                  ),
                            isDense: true,
                            contentPadding: const EdgeInsets.all(10),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _emailHasError = !(_formKey
                                      .currentState?.fields['email']
                                      ?.validate() ??
                                  false);
                            });
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.email(errorText: ''),
                          ]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text('비밀번호'),
                        FormBuilderTextField(
                          name: 'password',
                          controller: passValue,
                          obscureText: true,
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(height: 0),
                            suffixIcon: _passHasError
                                ? const Icon(Icons.error, color: Colors.red)
                                : const Icon(
                                    Icons.check,
                                    color: Colors.blue,
                                  ),
                            isDense: true,
                            contentPadding: const EdgeInsets.all(10),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _passHasError = !(_formKey
                                      .currentState?.fields['password']
                                      ?.validate() ??
                                  false);
                            });
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.minLength(1, errorText: ''),
                            FormBuilderValidators.minLength(8, errorText: ''),
                          ]),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            child: const Text('로그인'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  _formKey.currentState!.value['email']
                                          .toString()
                                          .length >
                                      1) {
                                CustomAuth.signInEmailAndPass(
                                  _formKey.currentState!.value['email'],
                                  _formKey.currentState!.value['password'],
                                ).then(
                                  (model) => {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(model.messege),
                                        );
                                      },
                                    ).then(
                                      (value) => {
                                        if (model.type) {context.go('/feed')}
                                      },
                                    )
                                  },
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return const AlertDialog(
                                      content: Text('정보를 입력해주세요'),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: Text('회원가입하기'),
                        onTap: () {
                          inputClear();
                          maincontext.go('/login/certification');
                        },
                      ),
                      InkWell(
                        child: Text('아이디찾기'),
                        onTap: () {},
                      ),
                      InkWell(
                        child: Text('비밀번호찾기'),
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(30),
              child: Divider(
                height: 1,
                color: Colors.black,
              ),
            ),
            Text('간편 로그인하기'),
            SosialLoginWidget(),
          ],
        ),
      ),
    );
  }
}
