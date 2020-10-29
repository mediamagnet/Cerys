import 'dart:io' show Platform;
import 'dart:convert';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:toml/loader/fs.dart';


String get dartVersion {
  final platformVersion = Platform.version;
  return platformVersion.split('(').first;
}

String helpCommandGen(String commandName, String description, { String? additionalInfo }) {
  FilesystemConfigLoader.use();
  final buffer = StringBuffer();
  var cfg;

  var prefix = cfg['bot']['prefix'];

  buffer.write('**${prefix}${commandName}**');

  if (additionalInfo != null) {
    buffer.write(' `$additionalInfo`');
  }

  buffer.write(' - $description.\n');

  return buffer.toString();
}

Future wodScrape(String page) async {
  var client = Client();
  var path = page;
  var response = await client.get('http://wodcodex.com/wiki/${path}_(2nd_Edition)');
  var document = parse(response.body);
  var tables = document.getElementsByTagName('table');
  print(response.statusCode);
  var itemMap = <dynamic, Map<dynamic, dynamic>>{};
  var headerMap = <String>[];
  var section = '';
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
    for (var item in row.children.asMap().entries) {
      if (item.value.text.trim() != '') {
        rowMap[headerMap[item.key]] = item.value.text.trim();
      }
    }
    itemMap[rowMap[headerMap[0]]] = rowMap;
  }
  // return itemMap;
  return jsonEncode(itemMap);
  //print(itemMap);
}