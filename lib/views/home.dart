import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:search_ur_recipe/models/recipe_model.dart';
import 'package:search_ur_recipe/views/recipe_view.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textEditingController = TextEditingController();

  String applicationId = 'bb97c604';
  String applicationKey = '10c859a4423b54a606895aa5ebf315e4	';
  List<RecipeModel> recipies = <RecipeModel>[];
  getRecipies(String query) async {
    String url =
        'https://api.edamam.com/search?q=$query&app_id=$applicationId&app_key=$applicationKey';

    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["hits"].forEach((element) {
      RecipeModel recipeModel = RecipeModel.fromMap(element["recipe"]);

      recipies.add(recipeModel);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff213A50), Color(0xff071930)])),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: Platform.isIOS ? 60.0 : 40.0, horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: kIsWeb
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      Text(
                        'KnowUr',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Recipe',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  const Text(
                    'What\'s on your mind today?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Overpass'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Just enter the ingrdients & we will provide you with the best recipies',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontFamily: 'OverpassRegular'),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                                hintText: 'Enter the ingredient',
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                hintStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white.withOpacity(0.5))),
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 16),
                        InkWell(
                          onTap: () {
                            if (textEditingController.text.isNotEmpty) {
                              getRecipies(textEditingController.text);
                              print('do it');
                            } else {
                              print('mat karo');
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                gradient: LinearGradient(colors: [
                                  const Color(0xffA2834D),
                                  const Color(0xffBC9A5F)
                                ])),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  GridView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200, mainAxisSpacing: 10.0),
                    children: List.generate(recipies.length, (index) {
                      return GridTile(
                        child: RecipeTile(
                          title: recipies[index].label,
                          desc: recipies[index].source,
                          imgUrl: recipies[index].image,
                          url: recipies[index].url,
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipeTile(
      {required this.title,
      required this.desc,
      required this.url,
      required this.imgUrl});
  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                            postUrl: widget.url,
                          )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: 'OverpassRegular'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
