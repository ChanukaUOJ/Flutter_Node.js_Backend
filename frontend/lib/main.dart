import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Node.js Backend',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Item> items = [];
  final String serverUrl = 'http://10.0.2.2:3000';

  final _nameController = TextEditingController();

  //fetching data
  Future<void> fetchItem() async {
    print("Fetch Item  called!");
    final String url = '$serverUrl/api/v1/items';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonItems = jsonDecode(response.body);
        items = jsonItems.map((json) => Item.fromJson(json)).toList();
        print('Fetching success!');
        print(items.length);
      } else {
        print("Failed to fetch items: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching item: $e");
    }
  }

  //add data
  Future<void> addItem(String name) async {
    print("Add item called!");
    final String url = '$serverUrl/api/v1/items';
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    try {
      if (response.statusCode == 201) {
        final dynamic json = jsonDecode(response.body);
        final Item item = Item.fromJson(json);
      } else {
        throw Exception('Failed to add item');
      }
    } catch (e) {
      print("Exception");
    }
  }

  //update date
  Future<void> updateItem(int id, String name) async {
    print("Update item called!");
    final String url = '$serverUrl/api/v1/items/$id';
    final uri = Uri.parse(url);

    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to Update Item");
    }
  }

  //delete data
  Future<void> deleteItem(int id) async {
    print("Delete item called!");
    final String url = "$serverUrl/api/v1/items/$id";
    final uri = Uri.parse(url);

    final response = await http.delete(uri);

    if (response.statusCode != 200) {
      throw Exception("Failed to delete the item ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Node.js Backend"),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: fetchItem(),
            builder: (context, index) {
              return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, snapshot) {
                    final item = items[snapshot];
                    return ListTile(
                      title: Text(item.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await deleteItem(item.id);
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Update Item"),
                                        content: TextFormField(
                                          controller: _nameController,
                                          decoration: const InputDecoration(
                                              labelText: "Item Name"),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              updateItem(item.id,
                                                  _nameController.text);
                                              setState(() {
                                                _nameController.clear();
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: const Text("Update"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: const Icon(Icons.edit)),
                        ],
                      ),
                    );
                  });
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Add Item'),
                    content: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        label: Text("Item Name"),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          addItem(_nameController.text);
                          setState(() {
                            _nameController.clear();
                            Navigator.pop(context);
                          });
                        },
                        child: const Text("Add"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
