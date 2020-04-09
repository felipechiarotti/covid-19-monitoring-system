import 'package:intl/intl.dart';

class FormatNumber {
  //static final NumberFormat _formatter = NumberFormat.decimalPattern('pt_BR');

  static String formatInt(int value){
    //final _formatter = NumberFormat("##0.0#", "pt_BR");
    final _formatter = NumberFormat('###,###,##0', 'pt_BR');
    try{
      return _formatter.format(value);
    } catch (e) {
      print(e);
    }
    return '0';
  }
}