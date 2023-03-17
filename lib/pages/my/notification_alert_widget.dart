import 'package:flutter/material.dart';

Future<bool> notificationShowDialogb2(context,title,content) async{
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  child: Text('허용'),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // 너비를 가득 차게 설정
                  ),
                  onPressed: () {
                    // OK 버튼을 눌렀을 때 실행할 코드
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
              Expanded(
                child: TextButton(
                  child: Text('허용 안함'),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // 너비를 가득 차게 설정
                  ),
                  onPressed: () {
                    // Cancel 버튼을 눌렀을 때 실행할 코드
                    Navigator.of(context).pop(false);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<bool> notificationShowDialogb1(context,title,content) async{
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: const TextStyle(fontSize: 16),),
        content: Text(content, style: const TextStyle(fontSize: 12),),
        actions: <Widget>[
          TextButton(
            child: Text('확인'),
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 50), // 너비를 가득 차게 설정
            ),
            onPressed: () {
              // OK 버튼을 눌렀을 때 실행할 코드
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
