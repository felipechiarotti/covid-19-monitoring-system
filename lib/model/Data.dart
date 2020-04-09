class Data {
  final int cases;
  final int deaths;
  final int recovered;

  Data({this.cases, this.deaths, this.recovered});

  factory Data.fromJson(Map<dynamic, dynamic> json) {
    return Data(
      cases: json['cases'],
      deaths: json['deaths'],
      recovered: json['recovered'],
    );
  }
}