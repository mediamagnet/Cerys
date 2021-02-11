import 'dart:convert';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';
import 'dart:async';
import 'dart:math' show Random;
import 'dart:io' show File;
import 'package:html_unescape/html_unescape.dart';
import 'package:toml/loader/fs.dart';
import 'cerys.dart' as cerys;

var prefix = cerys.prefix;

Future<void> embedCommand(CommandContext ctx, String content) async {
  final color = DiscordColor.fromRgb(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));

  var unescape = HtmlUnescape();
  Map wodembed = json.decode(await File('codex/embed.json').readAsString());
  var keyword = htmlEscape.convert(content
      .replaceAll('${prefix}codex embed ', '')
      .toLowerCase()
      .replaceAll(' ', '_'));
  print(keyword);
  var obj = wodembed[keyword];
  obj['Name'] = unescape.convert(obj['Name']);
  print(obj);

  var embed = EmbedBuilder()
    ..addAuthor((author) {
      author.name = unescape.convert(obj['Name']);
      author.iconUrl = 'https://cdn.discordapp.com/emojis/269519439354003456.png?v=1';
      author.url = 'https://github.com/mediamagnet/cerys';
    })
    ..addFooter((footer) {
      footer.text = 'Cerys v0.0.1';
    })
    ..color = color
    ..addField(name: 'Description:', content: obj['Description'])
    ..addField(name: 'Pool:', content: obj['Pool'], inline: true)
    ..addField(name: 'Type:', content: obj['Type'], inline: true)
    ..addField(name: 'Source', content: obj['Source']);

  await ctx.message.delete();
  await ctx.sendMessage(embed: embed);
}

Future<void> exploitCommand(CommandContext ctx, String content) async {
  final color = DiscordColor.fromRgb(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));

  var unescape = HtmlUnescape();
  Map wodembed = json.decode(await File('codex/exploits.json').readAsString());
  var keyword = htmlEscape.convert(content
      .replaceAll('${prefix}codex exploit ', '')
      .toLowerCase()
      .replaceAll(' ', '_'));
  print(keyword);
  var obj = wodembed[keyword];
  obj['exploit'] = unescape.convert(obj['exploit']);
  print(obj);

  var embed = EmbedBuilder()
    ..addAuthor((author) {
      author.name = unescape.convert(obj['exploit']);
      author.iconUrl = 'https://cdn.discordapp.com/emojis/269519439354003456.png?v=1';
      author.url = 'https://github.com/mediamagnet/cerys';
    })
    ..addFooter((footer) {
      footer.text = 'Cerys v0.0.1';
    })
    ..color = color
    ..addField(name: 'Description:', content: obj['description'])
    ..addField(name: 'Cost:', content: obj['cost'], inline: true)
    ..addField(name: 'Dice Pool:', content: obj['dice_pool'], inline: true)
    ..addField(name: 'Source', content: obj['source']);
  await ctx.message.delete();
  await ctx.sendMessage(embed: embed);
}

Future<void> cruacCommand(CommandContext ctx, String content) async {
  final color = DiscordColor.fromRgb(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));

  var unescape = HtmlUnescape();
  Map wodembed = json.decode(await File('codex/cruac.json').readAsString());
  var keyword = htmlEscape.convert(content
      .replaceAll('${prefix}codex cruac ', '')
      .toLowerCase()
      .replaceAll(' ', '_'));
  print(keyword);
  var obj = wodembed[keyword];
  obj['rite'] = unescape.convert(obj['rite']);
  print(obj);

  var embed = EmbedBuilder()
    ..color = color
    ..addAuthor((author) {
      author.name = unescape.convert(obj['rite']);
      author.iconUrl = 'https://cdn.discordapp.com/emojis/769333984874070026.png?v=1';
      author.url = 'https://github.com/mediamagnet/cerys';
    })
    ..addFooter((footer) {
      footer.text = 'Cerys v0.0.1';
    })
    ..addField(name: 'Description', content: obj['description'])
    ..addField(name: 'Target', content: obj['target'], inline: true)
    ..addField(name: 'Opposition', content: obj['opposition'], inline: true)
    ..addField(name: 'source', content: obj['source']);

  await ctx.message.delete();
  await ctx.sendMessage(embed: embed);
}

Future<void> demonFormsCommand(CommandContext ctx, String content) async {
  final color = DiscordColor.fromRgb(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));

  var unescape = HtmlUnescape();
  Map wodembed = json.decode(await File('codex/demonic_forms.json').readAsString());
  var keyword = htmlEscape.convert(content
      .replaceAll('${prefix}codex demon forms ', '')
      .toLowerCase()
      .replaceAll(' ', '_'));
  print(keyword);
  var obj = wodembed[keyword];
  obj['rite'] = unescape.convert(obj['modification']);
  print(obj);

  var embed = EmbedBuilder()
    ..color = color
    ..addAuthor((author) {
      author.name = unescape.convert(obj['modification']);
      author.iconUrl = 'https://cdn.discordapp.com/emojis/269519439354003456.png?v=1';
      author.url = 'https://github.com/mediamagnet/cerys';
    })
    ..addFooter((footer) {
      footer.text = 'Cerys v0.0.1';
    })
    ..addField(name: 'Appearance', content: obj['Appearance'])
    ..addField(name: 'System', content: obj['system'])
    ..addField(name: 'Source', content: obj['source']);
  await ctx.message.delete();
  await ctx.sendMessage(embed: embed);
}

Future<void> giftCommand(CommandContext ctx, String content) async {
  final color = DiscordColor.fromRgb(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));

  var unescape = HtmlUnescape();
  Map wodembed = json.decode(await File('codex/gifts.json').readAsString());
  var keyword = htmlEscape.convert(content
      .replaceAll('${prefix}codex gifts ', '')
      .toLowerCase()
      .replaceAll(' ', '_'));
  print(keyword);
  var obj = wodembed[keyword];
  obj['facet'] = unescape.convert(obj['facet']);
  print(obj);

  var embed = EmbedBuilder()
    ..color = color
    ..addAuthor((author) {
      author.name = unescape.convert(obj['facet']);
      author.iconUrl = 'https://cdn.discordapp.com/emojis/269519323201142784.png?v=1';
      author.url = 'https://github.com/mediamagnet/cerys';
    })
    ..addFooter((footer) {
      footer.text = 'Cerys v0.0.1';
    })
    ..addField(name: 'Description', content: obj['description'])
    ..addField(name: 'Rank', content: obj['rank'], inline: true)
    ..addField(name: 'Pool', content: obj['pool'])
    ..addField(name: 'Duration', content: obj['duration'], inline: true)
    ..addField(name: 'Type', content: obj['type'], inline: true)
    ..addField(name: 'Reference', content: obj['reference']);

  await ctx.message.delete();
  await ctx.sendMessage(embed: embed);
}

Future<void> conditionCommand(CommandContext ctx, String content) async {
  final color = DiscordColor.fromRgb(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));

  var unescape = HtmlUnescape();
  Map wodembed = json.decode(await File('codex/conditions.json').readAsString());
  var keyword = htmlEscape.convert(content
      .replaceAll('${prefix}codex condition ', '')
      .toLowerCase()
      .replaceAll(' ', '_'));
  print(keyword);
  var obj = wodembed[keyword];
  obj['Name'] = unescape.convert(obj['Name']);
  print(obj);

  var embed = EmbedBuilder()
    ..color = color
    ..addAuthor((author) {
      author.name = unescape.convert(obj['Name']);
      author.iconUrl = 'https://cdn.discordapp.com/emojis/269519439354003456.png?v=1';
      author.url = 'https://github.com/mediamagnet/cerys';
    })
    ..addFooter((footer) {
      footer.text = 'Cerys v0.0.1';
    })
    ..addField(name: 'Effect', content: obj['Effect'])
    ..addField(name: 'Persistent', content: obj['Persistent'], inline: true)
    ..addField(name: 'Type', content: obj['Type'], inline: true)
    ..addField(name: 'Source', content: obj['Source']);

  await ctx.message.delete();
  await ctx.sendMessage(embed: embed);
}
