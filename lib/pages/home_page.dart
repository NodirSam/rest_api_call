import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rest_api_call/users/users_pets.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //To hold response
  late UsersPets usersPets;

  //data is loaded flaga
  bool isDataLoaded = false;

  //error msg
  String errorMsg = "";

  //API Call
  Future<UsersPets> getDataFromAPI() async {
    Uri url = Uri.parse(
        "https://jatinderji.github.io/users_pets_api/users_pets.json");
    var response = await http.get(url);
    if (response.statusCode == HttpStatus.ok) {
      UsersPets usersPets = usersPetsFromJson(response.body);
      return usersPets;
    } else {
      errorMsg = "${response.statusCode}: ${response.body}";
      return UsersPets(data: []);
    }
  }

  assignData() async {
    usersPets = await getDataFromAPI();
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    // call method
    assignData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Rest API Call"),
          centerTitle: true,
        ),
        body: !isDataLoaded
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : errorMsg.isNotEmpty
                ? Center(
                    child: Text(errorMsg),
                  )
                : usersPets.data.isEmpty
                    ? const Center(child: Text("No Data"))
                    : ListView.builder(
                        itemCount: usersPets.data.length,
                        itemBuilder: (context, index) => getMyRow(index),
                      ));
  }

  Widget getMyRow(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 21,
          backgroundColor: usersPets.data[index].isFriendly ? Colors.green : Colors.red,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: usersPets.data[index].isFriendly ? Colors.green : Colors.red,
            backgroundImage: NetworkImage(usersPets.data[index].petImage),
          ),
        ),
        trailing: Icon(
          usersPets.data[index].isFriendly ? Icons.pets : Icons.do_not_touch,
          color: usersPets.data[index].isFriendly ? Colors.green : Colors.red,
         ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              usersPets.data[index].userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Dog : ${usersPets.data[index].petName}"),
          ],
        ),
      ),
    );
  }
}
