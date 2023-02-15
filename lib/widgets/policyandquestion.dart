import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PolicyAndQustion extends StatelessWidget {
  PolicyAndQustion({Key? key}) : super(key: key);

  final double dividerHeight = 20;
  final Color? dividerColor = Colors.grey[400];
  final arrowIcon = {
    'icon': Icons.arrow_forward_rounded,
    'size': 20,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(width: 2, color: Colors.grey),
        ),
      ),
      child: Column(
        children: [
          PolicyAndQustionItem(
            label: '공지사항',
            path: '/userinfo/announcement',
          ),
          PolicyAndQustionItem(
            label: '자주 묻는 질문',
            path: '/userinfo/askquestions',
          ),
          PolicyAndQustionItem(
            label: '1:1 문의하기',
            path: '/userinfo/oneononeinquiry',
          ),
          PolicyAndQustionItem(
            label: '서비스 이용약관',
            path: '/userinfo/serviceconditions',
          ),
          PolicyAndQustionItem(
            label: '개인정보 처리방침',
            path: '/userinfo/infopolicy',
          ),
          Row(
            children: const [
              Text('버전정보'),
              SizedBox(
                width: 15,
              ),
              Text('v 0.0.5'),
            ],
          ),
        ],
      ),
    );
  }
}

class PolicyAndQustionItem extends StatelessWidget {
  PolicyAndQustionItem({Key? key, required this.label, required this.path})
      : super(key: key);
  final String label;
  final String path;
  final double dividerHeight = 20;
  final Color? dividerColor = Colors.grey[400];
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(path);
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 20,
              ),
            ],
          ),
          Divider(
            height: dividerHeight,
            color: dividerColor,
          ),
        ],
      ),
    );
  }
}
