import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'model/team.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  List<Team> teams = [];

  //get teams
  Future getTeams() async {
    //get response from url
    var response = await http.get(Uri.https('balldontlie.io', '/api/v1/teams'));
    //decode and store in jsonData var
    var jsonData = jsonDecode(response.body);

    //store each item of jsonData to teams list using a model Team
    for (var eachTeam in jsonData['data']) {
      final team =
          Team(abbreviation: eachTeam['abbreviation'], city: eachTeam['city']);
      teams.add(team);
    }
    //print(teams.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NBA Teams'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getTeams(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(teams[index].abbreviation),
                          subtitle: Text(teams[index].city),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
