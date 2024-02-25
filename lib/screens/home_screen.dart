import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/task.dart';



class HomeScreen extends StatefulWidget{

  static const routeName = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _taskController;

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task t = Task.fromString(_taskController.text);
    //prefs.setString('task', json.encode(t.getMap()));
    //_taskController.text = '';
    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);
    print(list);
    list.add(json.encode(t.getMap()));
    print(list);
    prefs.setString('task', json.encode(list));
    _taskController.text  = '';
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueGrey,centerTitle: true,title: Text(textAlign: TextAlign.center,'İş Planlayıcı',
      style: GoogleFonts.montserrat(color: Colors.white),)),
      body: Center(child: Text('Henüz eklenmiş bir iş yok'),),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(context: context, builder: (BuildContext context) => Container(
          padding: const EdgeInsets.all(10.0),
          width: 500,
          height: 250,
          color: Colors.blueGrey[400],
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('İş Ekle',style: GoogleFonts.montserrat(color: Colors.white,fontSize: 20.0),),
                GestureDetector( child:Icon(Icons.close),onTap: () => Navigator.of(context).pop(),),
              ],
            )
            ,Divider(
              thickness: 1.2,
            ),
            SizedBox(height: 20.0,),
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0)
                      ,borderSide: BorderSide(color:Colors.blue)
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Görev girin',
                hintStyle: GoogleFonts.montserrat()

              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              width: MediaQuery.of(context).size.width,
              //height: 200.0,
              child: Row(children: [
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - 20,
                  color: Colors.white,
                  child: ElevatedButton(
                    child: Text('Sil', style: GoogleFonts.montserrat(),),
                    onPressed: () => _taskController.text = '',

                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - 20,
                  color: Colors.blue,
                  child: ElevatedButton(
                    child: Text('Ekle', style: GoogleFonts.montserrat(),),
                    onPressed: () => saveData(),
                  ),
                )
              ],),
            )

          ],),
        )),
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}