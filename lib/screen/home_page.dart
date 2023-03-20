import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _controller = TextEditingController();
  TextEditingController _updateController = TextEditingController();
  Box? _countryBox;
  
  @override
  void initState() {
    _countryBox = Hive.box("country-list");
    // TODO: implement initState
    super.initState();
  }

  void clearAddTextField() {
    _controller.clear();
  }
  void clearUpdateTextField() {
    _updateController.clear();
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue,width: 2),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                    onPressed: (){
                      final userData = _controller.text;
                      _countryBox!.add(userData);
                      clearAddTextField();
                    }, child: Text("ADD")),
              ),
              SizedBox(height: 10,),
              Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: Hive.box("country-list").listenable(),
                      builder: (context,box,widget){
                        return ListView.builder(
                          itemCount: _countryBox!.keys.toList().length,
                            itemBuilder: (context,index){
                            return Card(
                              child: ListTile(
                                title: Text(
                                  _countryBox!.getAt(index).toString(),
                                ),
                                trailing: Container(
                                  width: 100,
                                  //color: Colors.blue,
                                  child: Row(
                                    children: [
                                      IconButton(onPressed: (){
                                        showDialog(context: context, builder: (context){
                                          return AlertDialog(
                                           content: Column(
                                             children: [
                                               TextField(
                                                 controller: _updateController,
                                                 decoration: InputDecoration(
                                                   border: OutlineInputBorder(
                                                     borderSide: BorderSide(color: Colors.blue),
                                                     borderRadius: BorderRadius.circular(15)
                                                   ),

                                                 ),
                                               ),
                                               SizedBox(height: 10,),
                                               ElevatedButton(onPressed: (){
                                                 _countryBox!.putAt(index, _updateController.text);
                                                 Navigator.pop(context);
                                                 clearUpdateTextField();
                                               }, child: Text("Update"))
                                             ],
                                           ),
                                          );
                                        });
                                      }, icon: CircleAvatar(
                                          backgroundColor: Colors.greenAccent,
                                          child: Icon(Icons.edit))),
                                      IconButton(onPressed: (){
                                        _countryBox!.deleteAt(index);
                                      }, icon: CircleAvatar(
                                        backgroundColor: Colors.red,
                                          child: Icon(Icons.remove))),
                                    ],
                                  ),
                                ),
                              ),
                            );
                        }
                        );
                      }
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
