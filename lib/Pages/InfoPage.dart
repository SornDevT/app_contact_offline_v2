import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class InfoPage extends StatefulWidget {
  InfoPage({super.key, required this.contactID});

  final int contactID;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final _contactBox = Hive.box("contact_box");
  late final Map<dynamic, dynamic> items;

  /// function ອ່ານຂໍ້ມູນ
  void _readItem(int itemkey) {
    final item = _contactBox.get(itemkey);
    setState(() {
      items = item;
    });
    print(item);
  }

  @override
  void initState() {
    super.initState();
    _readItem(widget.contactID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ຂໍ້ມູນຜູ້ຕິດຕໍ່'),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            color: Colors.blue,
            child: const Center(
              child: Icon(
                Icons.person,
                size: 190,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.account_circle,
                    ),
                    title: Row(
                      children: [
                        items["gender"] == "male"
                            ? Text("ທ່ານ ")
                            : Text("ທ່ານ ນ "),
                        Text(items["name"] + " " + items["last_name"])
                      ],
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on,
                    ),
                    title: Text(items["address"]),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.phone,
                    ),
                    title: Text(items["tel"]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Expanded(
              child: Center(
                child: Container(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      _callNumber(items["tel"]);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone),
                        Text("ໂທທັນທີ"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _callNumber(String phoneNumber) async {
    String number = phoneNumber;
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}
