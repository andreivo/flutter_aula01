import 'dart:convert';

import 'package:aula01_todo/models/item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // Ativa o Material 3
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ), // Esquema padrão baseado no azul
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[900], // Azul mais forte para o AppBar
          foregroundColor: Colors.white, // Texto e ícones brancos no AppBar
        ),
      ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  var items = <Item>[];

  Homepage({super.key}) {
    items = [];
  }

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var newTaskCtrl = TextEditingController();

  void addItem() {
    if (newTaskCtrl.text.isEmpty) return;

    setState(() {
      widget.items.add(Item(title: newTaskCtrl.text, done: false));
      newTaskCtrl.text = "";
      saveItems();
    });
  }

  void removeItem(int index) {
    setState(() {
      widget.items.removeAt(index);
      saveItems();
    });
  }

  Future loadItems() async {
    // await Future.delayed(Duration(seconds: 2));
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("data");

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }

    return Future.value();
  }

  Future saveItems() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("data", jsonEncode(widget.items));
  }

  _HomepageState() {
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            labelText: "Nova Tarefa",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (ctxt, index) {
          final item = widget.items[index];
          return Dismissible(
            key: Key(item.title!),
            background: Container(
              color: Colors.red.withValues(alpha: 0.2),
              child: Center(
                child: Text("Excluir"),
              ),
            ),
            onDismissed: (direction) {
              removeItem(index);
            },
            child: CheckboxListTile(
              title: Text(item.title!),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;
                  saveItems();
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addItem,
        backgroundColor: Colors.pink,
        child: Icon(Icons.add),
      ),
    );
  }
}
