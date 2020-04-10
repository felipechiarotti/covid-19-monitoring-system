import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:covid/util/format_number.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../util/format_number.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future _taskGlobal;
  List _data;

  String _cases = "";
  String _deaths = "";
  String _recovered = "";
  List<Color> colorList = [
    Colors.deepOrange,
    Colors.blue,
    Colors.green,
  ];
  Map<String, double> dataMap =  new Map();
  int _cIndex = 0;


  Future<List> _getData(String url) async {
    http.Response response;
    response = await http.get(url);
    List dados = json.decode(response.body);
    return dados;

  }

  Future<bool> _getGlobalData() async{
    _data = await _getData("https://coronavirus-19-api.herokuapp.com/countries");
    setState(() {
      var _worldData = _data[7];
      _cases = FormatNumber.formatInt( _worldData["cases"]);
      _deaths =  FormatNumber.formatInt( _worldData["deaths"]);
      _recovered =  FormatNumber.formatInt( _worldData["recovered"]);

      dataMap = new Map();
      double cases = double.parse(_worldData["active"].toString());
      double deaths = double.parse(_worldData["deaths"].toString());
      double recovered = double.parse(_worldData["recovered"].toString());
      dataMap.putIfAbsent("Casos", () => cases);
      dataMap.putIfAbsent("Mortes", () => deaths);
      dataMap.putIfAbsent("Recuperados", () => recovered);

    });
      return true;
  }





  void onTabTapped(int index) {
    setState(() {
      _cIndex = index;
    });
  }
  Widget _buildInfoCard(String title, Map<String, dynamic> infos, Color color){
    String cases = FormatNumber.formatInt(infos["cases"]);
    String deaths = FormatNumber.formatInt(infos["deaths"]);
    String lastDay = FormatNumber.formatInt(infos["todayDeaths"]);
    return Container(
        margin: EdgeInsets.only(top:10.0),
        child:
        Card(
          color: color == null ? Theme.of(context).cardColor : color,
          child:Container(
              padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AutoSizeText(
                  title, style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),),
                  Column(
crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText("Casos: " + cases.toString(), style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),textAlign: TextAlign.left,),
                      AutoSizeText("Mortes: " + deaths.toString(), style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),textAlign: TextAlign.left,),
                      AutoSizeText("Mortes hoje: " + lastDay.toString(), style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),textAlign: TextAlign.left,),
                    ],
                  )
                ],
              ),

          ),
        )

    );
  }
  Widget _buildCard(double width, String title, String subtitle, Color color){
    return Container(
      margin: EdgeInsets.only(top:10.0),
      child:
      Card(
          color: color == null ? Theme.of(context).cardColor : color,
          child:Container(
            width:width,
            padding:EdgeInsets.only(top:10, bottom:10),
            child: ListTile(
              title: AutoSizeText(title, style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),textAlign: TextAlign.center,),

              subtitle: AutoSizeText(subtitle, style: TextStyle(
                    color: Colors.white70,
                  ),textAlign: TextAlign.center,),

              )

            ),
          )

    );
  }

  Widget buildChart(){
    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 1000),
      chartLegendSpacing: 32.0,
      legendStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      chartRadius: MediaQuery.of(context).size.width ,
      showChartValuesInPercentage: true,
      showChartValues: true,
      showChartValuesOutside: false,
      chartValueBackgroundColor: Colors.grey[200],
      colorList: colorList,
      showLegends: true,
      legendPosition:  LegendPosition.right,

      decimalPlaces: 1,
      showChartValueLabel: true,
      initialAngle: 0,
      chartValueStyle: defaultChartValueStyle.copyWith(
        color: Colors.blueGrey[900].withOpacity(0.9),
      ),
      chartType: ChartType.disc,
    );
  }

  Widget _buildBottomMenu(){
    return BottomNavigationBar(
      currentIndex: _cIndex, // this will be set when a new tab is tapped
      onTap: onTabTapped, // new
      items: [
        BottomNavigationBarItem(
          icon: new Icon(Icons.supervisor_account),
          title: new Text('Global'),
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.location_on),
          title: new Text('Países'),
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.map),
          title: new Text('Continentes'),
        ),
      ],
    );
  }

  Widget _buildFutureBuilder(int page){
    return FutureBuilder<bool>(
        future: _taskGlobal,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            Widget widget;
            if(page == 0)
              widget =  _buildGlobalBody();
            else if(page == 1)
              widget = _buildCountriesBody();
            else
              widget =_buildContinentBody();

            return  widget;
          }else{
            return Center(
              child: SizedBox(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                ),
                width: 80,
                height: 80,
              ),
            );
          }
        }

    );
  }

  Widget _buildGlobalBody(){
    var screenSize = MediaQuery.of(context).size;
    return Center(
      child:Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top:20.0),
            child:Text("DADOS GLOBAIS", style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18.0
            ),)
            ,
          ),
          _buildCard(screenSize.width - 20, _cases, "INFECTADOS", Colors.deepOrange[700]),
          Container(
            margin: EdgeInsets.only(top:10.0, bottom:20.0),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildCard(screenSize.width / 2.2, _deaths, "MORTES", Colors.red[700]),
                _buildCard(screenSize.width / 2.2, _recovered, "RECUPERADOS", Colors.green[700]),
              ],
            ),
          ),
          Expanded(
              child: buildChart()
          ),
        ],
      ),
    );
  }

  Widget _buildContinentCard(BuildContext context, int index){
    return _buildInfoCard(_data[index]["country"], _data[index] ,null);
  }
  Widget _buildCountryCard(BuildContext context, int index) {
    index = index + 8;

    return _buildInfoCard(_data[index]["country"], _data[index], null);
  }

  Widget _buildContinentBody(){
    return Center(
      child:ListView.builder(
          shrinkWrap: true,
          itemBuilder: _buildContinentCard,
          itemCount: 6
      ),
    );
  }

  Widget _buildCountriesBody(){
    return Center(
      child:ListView.builder(
        shrinkWrap: true,
        itemBuilder: _buildCountryCard,
          itemCount: _data.length
      ),
    );
  }

  @override
  void initState(){
    _taskGlobal = _getGlobalData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: Text("COVID-19", style: TextStyle(color: Colors.white)),
                  centerTitle: true,
                ),
                backgroundColor: Theme.of(context).backgroundColor,
                body: _buildFutureBuilder(_cIndex),
                bottomNavigationBar: _buildBottomMenu(),
            );
        }
  }

