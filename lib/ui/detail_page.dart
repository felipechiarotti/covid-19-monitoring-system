import 'package:covid/util/format_number.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}
class _DetailState extends State<Detail> {
  Map<String, dynamic> _data;
  List<Color> colorList = [
    Colors.deepOrange,
    Colors.blue,
    Colors.green,
  ];
  Map<String, double> dataMap =  new Map();

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
      legendPosition: LegendPosition.right,

      decimalPlaces: 1,
      showChartValueLabel: true,
      initialAngle: 0,
      chartValueStyle: defaultChartValueStyle.copyWith(
        color: Colors.blueGrey[900].withOpacity(0.9),
      ),
      chartType: ChartType.disc,
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

  Widget _buildBody(){
      var screenSize = MediaQuery.of(context).size;

      var _cases = FormatNumber.formatInt(_data["cases"]);
      var _todayCases = FormatNumber.formatInt(_data["todayCases"]);
      var _deaths = FormatNumber.formatInt(_data["deaths"]);
      var _todayDeaths = FormatNumber.formatInt(_data["todayDeaths"]);
      var _recovered = FormatNumber.formatInt(_data["recovered"]);
      var _active = FormatNumber.formatInt(_data["active"]);
      var _critical = FormatNumber.formatInt(_data["critical"]);

      return Center(
        child:Column(
          children: <Widget>[
            _buildCard(screenSize.width - 20, _cases, "INFECTADOS", Colors.deepOrange[700]),

            Container(
              margin: EdgeInsets.only(top:10.0, bottom:10.0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                _buildCard(screenSize.width / 2.2, _todayCases, "CASOS HOJE", Colors.deepOrange[800]),
                  _buildCard(screenSize.width / 2.2, _recovered, "RECUPERADOS", Colors.green[700]),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:10.0, bottom:10.0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildCard(screenSize.width / 2.2, _deaths, "MORTES", Colors.red[700]),
                  _buildCard(screenSize.width / 2.2, _todayDeaths, "MORTES HOJE", Colors.red[700]),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only( bottom:10.0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildCard(screenSize.width - 20, _critical, "ESTADO CRÍTICO", Colors.red[700]),


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

  Widget build(BuildContext context) {

    _data = ModalRoute.of(context).settings.arguments;
    dataMap = new Map();
    double cases = double.parse(_data["active"].toString());
    double deaths = double.parse(_data["deaths"].toString());
    double recovered = double.parse(_data["recovered"].toString());
    dataMap.putIfAbsent("Casos", () => cases);
    dataMap.putIfAbsent("Mortes", () => deaths);
    dataMap.putIfAbsent("Recuperados", () => recovered);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: Colors.white
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(_data["country"], style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _buildBody(),
    );
  }
}
