import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'InfoPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --------- ປະກາດໂຕແປ ------------------

  final _contactBox = Hive.box('contact_box');

  final TextEditingController _name = TextEditingController();
  final TextEditingController _last_name = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _tel = TextEditingController();

  //
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Contact Offline'),
      ),
      body: _items.isEmpty
          ? const Center(
              child: Text(
                'ບໍ່ມີຂໍ້ມູນ',
                style: TextStyle(fontSize: 22),
              ),
            )
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final currentItem = _items[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InfoPage(contactID: currentItem["key"]),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Row(children: [
                        currentItem["gender"] == "male"
                            ? const Text("ທ່ານ ")
                            : const Text("ທ່ານ ນ "),
                        Text(currentItem["name"] +
                            ' ' +
                            currentItem["last_name"]),
                      ]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ທີ່ຢູ່: ${currentItem['address']}"),
                          Text("ເບີໂທ: ${currentItem['tel']}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              _ShowForm(context, currentItem["key"]);
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              _deleteItem(currentItem["key"]);
                            },
                            icon: Icon(Icons.delete),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ShowForm(context, null),
        child: Icon(Icons.add),
      ),
    );
  }

  /// ----------- Function --------------------
  void _ShowForm(BuildContext context, int? itemKey) async {
    if (itemKey != null) {
      /// ອັບເດດຂໍ້ມູນ
      print("ທຳການອັບເດດຂໍ້ມູນ");

      final getItem = _items.firstWhere((element) => element["key"] == itemKey);
      _name.text = getItem["name"];
      _last_name.text = getItem["last_name"];
      _gender.text = getItem["gender"];
      _address.text = getItem["address"];
      _tel.text = getItem["tel"];
    } else {
      /// ເຄຼຍຟອມ
      _name.text = '';
      _last_name.text = '';
      _gender.text = '';
      _address.text = '';
      _tel.text = '';
    }

    // ເປີດຟອມ
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _name,
                      decoration: InputDecoration(hintText: "ຊື່"),
                    ),
                    TextField(
                      controller: _last_name,
                      decoration: InputDecoration(hintText: "ນາມສະກຸນ"),
                    ),
                    Row(
                      children: [
                        Text("ເພດ:"),
                        Radio(
                            value: "male",
                            groupValue: _gender.text,
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                _gender.text = value!;
                              });
                            }),
                        Text("ຊາຍ"),
                        Radio(
                            value: "female",
                            groupValue: _gender.text,
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                _gender.text = value!;
                              });
                            }),
                        Text("ຍິງ"),
                      ],
                    ),
                    TextField(
                      controller: _address,
                      decoration: InputDecoration(hintText: "ທີ່ຢູ່"),
                    ),
                    TextField(
                      keyboardType: TextInputType.phone,
                      controller: _tel,
                      decoration: InputDecoration(hintText: "ເບີໂທ"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (itemKey == null) {
                          _createItem({
                            "name": _name.text,
                            "last_name": _last_name.text,
                            "gender": _gender.text,
                            "address": _address.text,
                            "tel": _tel.text,
                          });
                        } else {
                          _updateItem(itemKey!, {
                            "name": _name.text,
                            "last_name": _last_name.text,
                            "gender": _gender.text,
                            "address": _address.text,
                            "tel": _tel.text,
                          });
                        }

                        _name.text = '';
                        _last_name.text = '';
                        _gender.text = '';
                        _address.text = '';
                        _tel.text = '';

                        Navigator.of(context).pop();
                      },
                      child: itemKey == null
                          ? const Text("ບັນທຶກຂໍ້ມູນ")
                          : const Text("ອັບເດດຂໍ້ມູນ"),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Function add data
  ///
  void _createItem(Map<String, dynamic> newItem) async {
    // print(newItem);
    await _contactBox.add(newItem);
    _refreshItems();
  }

  void _updateItem(int itemKey, Map<String, dynamic> itemUpdate) async {
    await _contactBox.put(itemKey, itemUpdate);
    _refreshItems();
  }

  void _deleteItem(int itemKey) async {
    await _contactBox.delete(itemKey);
    _refreshItems();
  }

  void _refreshItems() {
    final data = _contactBox.keys.map((key) {
      final value = _contactBox.get(key);
      return {
        "key": key,
        "name": value["name"],
        "last_name": value["last_name"],
        "gender": value["gender"],
        "address": value["address"],
        "tel": value["tel"],
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
    });

    print(data.reversed.toList());
  }
}
