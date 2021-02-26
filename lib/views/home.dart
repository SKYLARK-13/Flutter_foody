import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:foody/models/recipe_model.dart';
import 'package:foody/views/recipe_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = false;

  List<RecipeModel> recipes = new List<RecipeModel>();
  TextEditingController textEditingController = new TextEditingController();

  getRecipes(String query) async{
    String url = "https://api.edamam.com/search?q=$query&app_id=a604d78d&app_key=717b0e00668cf3aa1867b4ddfa44c53f";
var response = await http.get(url);
Map<String,dynamic> jsonData = jsonDecode(response.body);
jsonData["hits"].forEach((element){
      print(element.toString());

      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipes.add(recipeModel);


    });
      setState(() {

      });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xff213A50),
                  const Color(0xff071930)
                ]
              )
            ),

          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 60,horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Foody',style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600
                      ),),
                      Text('Recipes',style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 24
                      ),)
                    ],
                    ),
                  SizedBox(height: 30,),
                  Text('What will you cook today ?',style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,fontFamily: "Overpass"
                  ),),
                  SizedBox(height: 8,),
                  Text('Just enter the ingredients you have we will show you the best recipes related to that',style: TextStyle(
                    color: Colors.white,
                    fontFamily: "OverpassRegular",
                    fontSize: 15
                  ),),
                  SizedBox(height: 30,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Expanded(child: TextField(
                          controller: textEditingController ,
                          decoration: InputDecoration(
                            hintText: "Enter Ingredients",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                            ),
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.5),
                            )
                          ),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                          ),
                        )),
                        SizedBox(width: 16,),
                        InkWell(
                          onTap: () async {
                            if(textEditingController.text.isNotEmpty){
                              setState(() {
                                _loading = true;
                              });
                              getRecipes(textEditingController.text);
                            }

                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                colors: [
                                const Color(0xffA2834D),
                                const Color(0xffBC9A5F)
                                ],)
                                ),
                                child: Icon(Icons.search,color: Colors.white,),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                  child:GridView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,mainAxisSpacing: 10.0
                  ),
                  children: List.generate(recipes.length, (index)  {
                    return GridTile(
                    child: RecipeTile(
                      title: recipes[index].label,
                    desc: recipes[index].source,
                    imgUrl: recipes[index].image,
                    url: recipes[index].url
                    )
                  );
                  }),
                  )
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RecipeTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipeTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipeTile> {
  _launchURL(String url) async {
    print(url);
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
              print(widget.url + " this is what we are going to see");
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


