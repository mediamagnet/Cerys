import 'dart:io' show Platform;
import 'dart:convert';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

String get dartVersion {
  final platformVersion = Platform.version;
  return platformVersion.split("(").first;
}

String helpCommandGen(String commandName, String description, { String? additionalInfo }) {
  final buffer = StringBuffer();

  // buffer.write("**$envPrefix$commandName**");

  if (additionalInfo != null) {
    buffer.write(" `$additionalInfo`");
  }

  buffer.write(" - $description.\n");

  return buffer.toString();
}

Future wodscrape(String context) async {
  var client = Client();
  var path = context.replaceAll('..test ', '');
  var response = await client.get(
    'http://wodcodex.com/wiki/${path}_(2nd_Edition)'
  );
 var document = parse(response.body);
 var tables = document.getElementsByTagName('table');
 print(response.statusCode);
 var itemMap = <dynamic, Map<dynamic, dynamic>>{};
 var headerMap = <String>[];
 var section = '';
 var i = 0;
 for (var row in tables[0].children[0].children) {
   print(i);
   i++;
   if (headerMap.isEmpty) {
     for (var hitem in row.children) {
       headerMap.add(hitem.text.trim().toLowerCase());
     }
     continue;
   }
   if (row.children.length <= 2) {
     //print(row.text.trim());
     section = row.text.trim();
     // print(section);
     continue;
   }
   var rowMap = <String, String>{};
   if (section != '') {
     rowMap['section'] = section;
     // print(rowMap);
   }
   for (var item in row.children.asMap().entries) {
    rowMap[headerMap[item.key]] = item.value.text.trim();
   }
   itemMap[rowMap[headerMap[0]]] = rowMap;
   //print(itemMap);
  //  if (row == tables[0].children[0].children.last) {
     //print('hello');
     //print(json.encode(itemMap));
   //}
 }
 return json.encode(itemMap);
  //print(itemMap);
 ;
}