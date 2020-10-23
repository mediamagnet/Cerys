import 'dart:convert';
import 'package:http/http.dart';
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'; // Contains DOM related classes for extracting data from elements


Future initiate() async {
  var client = Client();
  var response = await client.get(
      'http://wodcodex.com/wiki/Embeds_(2nd_Edition)'
  );

  var document = parse(response.body);
  var tables = document.getElementById('mw-content-text').children;

  var tableMap = <Map<String, dynamic>>[];

  for (var table in tables) {
    tableMap.add({
      'title': table.text
    });
  }
  return json.encode(tableMap);

}