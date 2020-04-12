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
  List _dataCountry;
  ScrollController _controller = ScrollController();
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


  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );


  void bottomTapped(int index) {
    setState(() {
      _cIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  // API Connection
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
    if(_data != null) {
      _dataCountry = _data.getRange(8, _data.length - 7).toList();
      return true;
    }
    return false;
  }

  // Build Screens
  Widget _buildPageView(){
    return PageView(
      controller: pageController,
      onPageChanged: _pageViewChanged,
      children: <Widget>[
        _buildGlobalBody(),
        _buildCountriesBody(),
        _buildContinentBody(),
      ],
    );
  }

  Widget _buildFutureBuilder(int page){
    return FutureBuilder<bool>(
        future: _taskGlobal,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.data == true) {
              return _buildPageView();
            }else{
              return Center(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(

                      child: Icon(
                        Icons.network_wifi,
                        color: Colors.red[700],
                        size: 80,

                      ),
                    ),
                    Text("Problemas na conexão", style: TextStyle(fontSize: 18)),
                  ],
                )
              );
            }
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
  Widget _buildContinentBody(){
    return Center(
      child:ListView.builder(
        controller: _controller,
          shrinkWrap: true,
          itemBuilder: _buildContinentCard,
          itemCount: 6
      ),
    );
  }
  Widget _buildCountriesBody(){

    return Center(
      child:ListView.builder(
          controller:  _controller,
          shrinkWrap: true,
          itemBuilder: _buildCountryCard,
          itemCount: _dataCountry.length
      ),
    );
  }

  // Build Components
  Widget buildChart(){
    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 1000),
      chartLegendSpacing: 32.0,
      legendStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      chartRadius: MediaQuery.of(context).size.width ,
      showChartValuesInPercentage: true,
      showChartValues: true,
      showChartValuesOutside: false,
      chartValueBackgroundColor: Colors.grey[200],
      colorList: colorList,
      showLegends: true,
      legendPosition: MediaQuery.of(context).size.height >= 650 ? LegendPosition.bottom : LegendPosition.right,

      decimalPlaces: 1,
      showChartValueLabel: true,
      initialAngle: 0,
      chartValueStyle: defaultChartValueStyle.copyWith(
        color: Colors.blueGrey[900].withOpacity(0.9),
      ),
      chartType: ChartType.disc,
    );
  }
  Widget _buildInfoCard(String title, Map<String, dynamic> infos, Color color){
    String cases = FormatNumber.formatInt(infos["cases"]);
    String deaths = FormatNumber.formatInt(infos["deaths"]);
    String lastDay = FormatNumber.formatInt(infos["todayDeaths"]);
    return Container(
        margin: EdgeInsets.only(top:10.0),
        child: FlatButton(
padding: EdgeInsets.all(0),
          onPressed: (){
            Navigator.pushNamed(
                context,
                '/detail',
                arguments: infos
            );
          },
              color: Colors.transparent ,

              child:Card(
          color: color == null ? Theme.of(context).cardColor : color,
          child:Container(
              padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: AutoSizeText(

                      title, style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                      maxLines: 1,
                     ),
                  ),

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
  Widget _buildContinentCard(BuildContext context, int index){
    return _buildInfoCard(_data[index]["country"], _data[index] ,null);
  }
  Widget _buildCountryCard(BuildContext context, int index) {
    return _buildInfoCard(_dataCountry[index]["country"], _dataCountry[index], null);
  }
  Widget _buildBottomMenu(){
    return BottomNavigationBar(
      currentIndex: _cIndex, // this will be set when a new tab is tapped
      onTap: bottomTapped, // new
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
  void _pageViewChanged(int index) {
    setState(() {
      _cIndex = index;
    });
  }

  @override
  void initState(){
    super.initState();
    _taskGlobal = _getGlobalData();
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
      floatingActionButton: _cIndex > 0 ? FloatingActionButton(
        onPressed: () {
          _controller.jumpTo(_controller.position.minScrollExtent);
        },
        child: Icon(Icons.arrow_upward),
        backgroundColor:  Theme.of(context).primaryColor,
      ) : null,
                bottomNavigationBar: _buildBottomMenu(),
            );
        }
  }

