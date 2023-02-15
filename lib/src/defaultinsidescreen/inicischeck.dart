import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:maccave/models/loginmodel.dart';
import 'package:maccave/widgets/blackelevatedbtn.dart';
import 'package:maccave/widgets/mainappbar.dart';
import 'package:go_router/go_router.dart';

class InicisCheckScreen extends StatefulWidget {
  const InicisCheckScreen({super.key, required this.social});
  final Function social;
  @override
  State<InicisCheckScreen> createState() => _InicisCheckScreenState();
}

class _InicisCheckScreenState extends State<InicisCheckScreen> {
  bool _allCheck = false;
  bool _privacyCheck = false;
  bool _serviceCheck = false;
  void _onSubmit() {
    if (_privacyCheck && _serviceCheck) {
      widget.social().then((LoginModel value) {
        if (value.type) {
          context.go('/feed');
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('필수 동의사항에 동의해주세요.'),
        ),
      );
    }
  }

  void _onAllCheck(bool? value) {
    _allCheck = value!;
    _privacyCheck = value;
    _serviceCheck = value;
    setState(() {});
  }

  void _onOrderCheck(bool? value) {
    if (_privacyCheck && _serviceCheck) {
      _allCheck = true;
    } else {
      _allCheck = false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        apptitle: '',
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CheckboxListTile(
              onChanged: _onAllCheck,
              checkboxShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              value: _allCheck,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('전체선택'),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: CheckboxListTile(
                    onChanged: (value) {
                      _privacyCheck = value!;
                      _onOrderCheck(value);
                      setState(() {});
                    },
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    value: _privacyCheck,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('(필수)  개인정보활용동의'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.push('/userinfo/infopolicy');
                  },
                  child: const Icon(Icons.arrow_right_alt),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: CheckboxListTile(
                    onChanged: (value) {
                      _serviceCheck = value!;
                      _onOrderCheck(value);
                      setState(() {});
                    },
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    value: _serviceCheck,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('(필수)  서비스이용약관'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.push('/userinfo/serviceconditions');
                  },
                  child: const Icon(Icons.arrow_right_alt),
                ),
              ],
            ),
            MacCaveElevatedButton(
              onPressed: () {
                _onSubmit();
              },
              child: const Text('PASS 확인'),
            ),
          ],
        ),
      ),
    );
  }
}
