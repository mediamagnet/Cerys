import 'dart:io' show Platform;
import 'dart:convert';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:toml/loader/fs.dart';

String get dartVersion {
  final platformVersion = Platform.version;
  return platformVersion.split('(').first;
}

String helpCommandGen(String commandName, String description,
    {String additionalInfo}) {
  FilesystemConfigLoader.use();
  final buffer = StringBuffer();
  var cfg;

  buffer.write('**${cfg['Bot']['Prefix']}${commandName}**');

  if (additionalInfo != null) {
    buffer.write(' `$additionalInfo`');
  }

  buffer.write(' - $description.\n');

  return buffer.toString();
}

Future wodScrape(String page) async {
  var client = Client();
  var path = page;
  var response = await client.get(Uri.parse('http://wodcodex.com/wiki/${path}_(2nd_Edition)'));
  var document = parse(response.body);
  var tables = document.getElementsByTagName('table');
  print(response.statusCode);
  var itemMap = <dynamic, Map<dynamic, dynamic>>{};
  var headerMap = <String>[];
  var section = '';
  var n = 0;

  for (var row in tables[0].children[0].children) {
    if (headerMap.isEmpty) {
      for (var hitem in row.children) {
        headerMap.add(hitem.text.trim());
      }
      continue;
    }

    if (row.children.length <= 2) {
      section = row.text.trim();
      continue;
    }

    var rowMap = <String, String>{};
    if (section != '') {
      rowMap['Type'] = section;
    }

    // print(headerMap);

    for (var item in row.children.asMap().entries) {
      if (item.value.text.trim() != '') {
        rowMap[headerMap[item.key]] = item.value.text.trim();
      }
      // print('header: ${headerMap}');
      // print('row: ${itemMap}');
      if (headerMap[0] == rowMap[0]) {
        // print(n);
        // print('header: ${headerMap[0]}');
        // print('row: ${rowMap[0]}');
        while (n <= rowMap.length) {
          headerMap.add('col${n}');
        }
        ;
      }
    }
    itemMap[rowMap[headerMap[0]]] = rowMap;
  }
  // return itemMap;
  return jsonEncode(itemMap);
  //print(itemMap);
}
