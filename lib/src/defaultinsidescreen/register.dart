import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:maccave/firebaseserver/firebaseauth.dart';
import 'package:maccave/widgets/mainappbar.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _emailHasError = false;
  bool _passHasError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: '회원가입'),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 20,
            ),
            child: FormBuilder(
              key: _formKey,
              onChanged: () {
                _formKey.currentState!.save();
              },
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'newemail',
                    decoration: InputDecoration(
                      labelText: '이메일',
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
                                .currentState?.fields['newemail']
                                ?.validate() ??
                            false);
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.email(errorText: ''),
                    ]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    name: 'newpass',
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: '패스워드',
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
                                .currentState?.fields['newpass']
                                ?.validate() ??
                            false);
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.minLength(8, errorText: ''),
                    ]),
                  ),
                  ElevatedButton(
                    child: Text('회원가입'),
                    onPressed: () async {
                      if (_formKey.currentState!.saveAndValidate()) {
                        CustomAuth.signUpEmailAndPass(
                          _formKey.currentState!.value['newemail'],
                          _formKey.currentState!.value['newpass'],
                        ).then(
                          (model) {
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
                            );
                          },
                        );
                      } else {}
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
