import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/task.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _taskController;
  List<Task> _tasks = [];
  List<bool> _tasksDone = [];

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task t = Task.fromString(_taskController.text);
    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);
    print(list);
    list.add(json.encode(t.getMap()));
    print(list);
    prefs.setString('task', json.encode(list));
    _taskController.text = '';
    Navigator.of(context).pop();
    _getTasks();
  }

  void _getTasks() async {
    _tasks = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);

    for (dynamic d in list) {
      _tasks.add(Task.fromMap(json.decode(d)));
    }

    _tasksDone = List.generate(_tasks.length, (index) => false);
    print(_tasks);

    setState(() {});
  }

  void updatePendingTasksList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Task> pandingList = [];
    for(var i = 0;i<_tasks.length;i++)
      if(!_tasksDone[i]) pandingList.add(_tasks[i]);

    var pandingListEncoded = List.generate(pandingList.length, (i) => json.encode(pandingList[i].getMap()));
    
    prefs.setString('task', json.encode(pandingListEncoded));
    _getTasks();
  }

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
    _getTasks();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text(
          textAlign: TextAlign.center,
          'İş Planlayıcı',
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        actions: [
          IconButton(onPressed: updatePendingTasksList, icon: Icon(Icons.save,color: Colors.cyanAccent,)),
          IconButton(onPressed: () async
          {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('task', json.encode([]));
          _getTasks();
          }, icon: Icon(Icons.delete,color: Colors.redAccent,)),
        ],
      ),
      body: (_tasks == null)
          ? Center(
              child: Text('Henüz eklenmiş bir iş yok'),
            )
          : Column(
              children: _tasks
                  .map((e) => Container(
                        height: 70.0,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        padding: const EdgeInsets.only(left: 10.0),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.black, width: 0.5),
                          color: Colors.deepPurple[100]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.task,
                              style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Checkbox(
                              value: _tasksDone[_tasks.indexOf(e)],
                              key: GlobalKey(),
                              onChanged: (value) {
                                setState(() {
                                  _tasksDone[_tasks.indexOf(e)] = value!;
                                });
                              },
                            )
                          ],
                        ),
                      ))
                  .toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 500,
                  height: 250,
                  color: Colors.deepPurple,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'İş Ekle',
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 20.0),
                          ),
                          GestureDetector(
                            child: Icon(Icons.close),
                            onTap: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1.2,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: _taskController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.blue)),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Görev girin',
                            hintStyle: GoogleFonts.montserrat()),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        width: MediaQuery.of(context).size.width,
                        //height: 200.0,
                        child: Row(
                          children: [
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 20,
                              child: ElevatedButton(
                                child: Text(
                                  'Sil',
                                  style: GoogleFonts.montserrat(color: Colors.black),
                                ),
                                onPressed: () => _taskController.text = '',
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 20,

                              child: ElevatedButton(
                                child: Text(
                                  'Ekle',
                                  style: GoogleFonts.montserrat(color: Colors.black),
                                ),
                                onPressed: () => saveData(),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
