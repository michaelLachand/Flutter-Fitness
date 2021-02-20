import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Fitness App - Mike'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int radioSelect;
  Map radioMapActivity = {
   0 :  "faible",
   1 : "Moyenne",
   2 :  "Intense"
  };

  double poids;
  bool gender = false;
  double age;
  double taille = 165.0;

  int caloriesBase;
  int caloriesWithActivity;

  @override
  Widget build(BuildContext context) {

    return new GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
      child: Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: this.getColorGender(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            makeSpace(),
            textWithStyle("Vous devez remplir les champs ci-dessous afin d'obtenir "
                "votre besoin journalier en calories !"
                ),
            makeSpace(),
            new Card(
              elevation: 12.0,
              child: Column(
                children: <Widget>[
                  makeSpace(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      textWithStyle("Homme", color: Colors.blue),
                      new Switch(value: gender, onChanged: (bool b) {
                        setState(() {
                          gender = b;
                        });
                      },
                      inactiveTrackColor: Colors.blue,
                      inactiveThumbColor: Colors.blue,
                      activeTrackColor: Colors.pink,
                      activeColor: Colors.pink,
                      ),
                      textWithStyle("Femme", color: Colors.pink),
                    ],
                  ),
                  makeSpace(),
                  new RaisedButton(onPressed: datePicker,
                      color: getColorGender(),
                      child: textWithStyle(age == null ? "Indiquer notre age !" : "Votre age est ${age.toInt()} ans ",color: Colors.white),
                  ),
                  makeSpace(),
                  
                  textWithStyle("Votre taille est de ${taille.toInt()} cm.", color: getColorGender()),
                  makeSpace(),
                  new Slider(value: taille, onChanged: (double d) {
                    setState(() {
                      taille = d;
                    });
                  },
                  max: 220.0,
                  min : 100.0,
                  activeColor: getColorGender(),
                  ),
                  makeSpace(),
                  new TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (String string) {
                      setState(() {
                        poids = double.tryParse(string);
                      });
                    },
                    decoration: new InputDecoration(
                       labelText: "Entrez votre poids en kilos ici..."
                     ),
                  ),
                    makeSpace(),
                  textWithStyle("Indiquez votre intensité d'activités :", color: getColorGender()),
                  makeSpace(),
                  getAcitivityRow(),
                  makeSpace(),
                ],
              ),
            ),
            makeSpace(),
            new RaisedButton(onPressed: makeCalcul, color: getColorGender(), child: textWithStyle("Calculer", color: Colors.white)
              ,)
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Future<Null> showResult() async {
    return showDialog(context: context, barrierDismissible: false,
    builder: (BuildContext buildContext) {
      return SimpleDialog(
        title: textWithStyle("Votre besoin en calories !", color: getColorGender()),
        contentPadding: EdgeInsets.all(12.0),
        children: <Widget>[
          makeSpace(),
          textWithStyle("Votre besoin de base est de $caloriesBase kcal"),
          makeSpace(),
          textWithStyle("Votre besoin avec votre activité sportive est de : $caloriesWithActivity kcal"),
          new RaisedButton(onPressed: () {
            Navigator.pop(buildContext);
          }, child: textWithStyle("Merci !" , color: getColorGender())),
        ],
      );
    });

  }

  Future<Null> datePicker() async {
    DateTime time = await showDatePicker(
            context: context,
            initialDate: new DateTime.now(),
            firstDate: new DateTime(1920),
            lastDate: new DateTime.now(),
            initialDatePickerMode: DatePickerMode.year);
    if (time !=null){
      var compare = new DateTime.now().difference(time);
      var days = compare.inDays;
      var years = (days/365);
      setState(() {
        age = years;
      });
    }
  }

  Padding makeSpace() {
    return new Padding(padding: EdgeInsets.only(top: 15.0));
  }

  Color getColorGender() {
    if(gender)
      return Colors.pink;
    else
      return Colors.blue;
  }

  
  Text textWithStyle(String data, {color: Colors.black, fontSize: 15.0}) {
    return new Text (
      data,
      textAlign: TextAlign.center,
      style:  new TextStyle(
        color: color,
        fontSize: fontSize
      ),
    );
  }

  Row getAcitivityRow() {
    List<Widget> list = [];

    radioMapActivity.forEach((key, value) {
      Column column = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(value: key, groupValue: radioSelect, onChanged: (Object i) {
            setState(() {
              radioSelect = i;
            });
          },
          activeColor: getColorGender(),
            ),
          textWithStyle(value, color: getColorGender()),
        ],
      );
      list.add(column);
    });

    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: list,
    );
  }

  void makeCalcul() {
    if (age != null && poids != null && radioSelect != null) {

      //Calculer les calories bases
      if(gender){
        //homme
        caloriesBase = (66.4730 + (13.7516 * poids) + (5.0033 * taille) + (6.7550 * age)).toInt();
      } else {
        //femme
        caloriesBase = (65.0955 + (19.5634 * poids) + (1.8496 * taille) + (4.6756 * age)).toInt();
      }

      //Calculer les calories avec activités
      switch(radioSelect) {
        case 0 :
          caloriesWithActivity = (caloriesBase * 1.2).toInt();
          break;
        case 1 :
          caloriesWithActivity = (caloriesBase * 1.5).toInt();
          break;
        case 2 :
          caloriesWithActivity = (caloriesBase * 1.8).toInt();
          break;
        default:
          caloriesWithActivity = caloriesBase;
          break;
      }
      setState(() {
        showResult();
      });

    }else {
      alertWarningField();
    }
  }

  Future<Null> alertWarningField() async {
    return showDialog(context: context, barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return new AlertDialog(
          title: textWithStyle("Erreur de calcul !"),
          content: textWithStyle("Vous devez remplir tous les champs pour continuer..."),
          actions: <Widget>[
            new FlatButton(onPressed: () {
              Navigator.pop(buildContext);
            }, child: textWithStyle("J'ai compris !" , color: Colors.red))
          ],
        );
      }
    );
  }

}
