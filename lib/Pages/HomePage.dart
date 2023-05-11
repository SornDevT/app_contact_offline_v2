import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override

  // --------- ປະກາດໂຕແປ ------------------
  final TextEditingController _name = TextEditingController();
  final TextEditingController _last_name = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _tel = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Contact Offline'),
      ),
      body: Center(
        child: Text(
          'ບໍ່ມີຂໍ້ມູນ',
          style: TextStyle(fontSize: 22),
        ),
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
    } else {
      /// ເປີດຟອມ
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSate) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
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
                            onChanged: (value) {}),
                        Text("ຊາຍ"),
                        Radio(
                            value: "female",
                            groupValue: _gender.text,
                            onChanged: (value) {}),
                        Text("ຍິງ"),
                      ],
                    ),
                    TextField(
                      controller: _address,
                      decoration: InputDecoration(hintText: "ທີ່ຢູ່"),
                    ),
                    TextField(
                      controller: _tel,
                      decoration: InputDecoration(hintText: "ເບີໂທ"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: Text("ບັນທຶກຂໍ້ມູນ"))
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
