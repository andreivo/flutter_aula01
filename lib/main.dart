import 'package:aula01_todo/models/item.dart';
import 'package:flutter/material.dart';

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

    items.add(Item(title: "Banana", done: false));
    items.add(Item(title: "Abacate", done: true));
    items.add(Item(title: "Laranja", done: false));
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
    });
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

          return CheckboxListTile(
            title: Text(item.title!),
            key: Key(item.title!),
            value: item.done,
            onChanged: (value) {
              setState(() {
                item.done = value;
              });
            },
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
