import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart'
    show CommandContext, CommandGroup, Commander;
import 'package:toml/loader/fs.dart';
import 'dart:async';
import 'dart:math' show Random;
import 'dart:io' show Process, ProcessInfo, pid, File;
import 'dart:convert';
import 'utils.dart' as utils;
import 'package:html_unescape/html_unescape.dart';


var ownerID;
// ignore: prefer_single_quotes

Future main(List<String> arguments) async {
  FilesystemConfigLoader.use();
  var cfg;
  try {
    cfg = await loadConfig('config.toml');
    print(cfg['Bot']['ID']);
    ownerID = cfg['Owner']['ID'];

    final bot = Nyxx(cfg['Bot']['Token']!);

    Commander(bot, prefix: cfg['Bot']['Prefix'])
      ..registerCommandGroup(CommandGroup(beforeHandler: checkForAdmin)
        ..registerSubCommand('shutdown', shutdownCommand))
      ..registerCommandGroup(CommandGroup(name: 'codex')
        ..registerSubCommand('embed', embedCommand))
      ..registerCommand('help', helpCommand)
      ..registerCommand('info', infoCommand)
      ..registerCommand('ping', pingCommand);
  } catch (e) {
    print(e);
  }
  return cfg;
}

Future<void> helpCommand(CommandContext ctx, String content) async {
  // Assign method to variable for shorter name
  const helpGen = utils.helpCommandGen;

  // Write zero-width character to skip first line where nick is
  final buffer = StringBuffer('‎\n');

  buffer.write(helpGen('info', 'sends basic info about bot'));
  buffer.write(helpGen('ping', 'sends current bot latency'));
  buffer.write(helpGen('help', 'this command'));
  buffer.write(helpGen('shutdown', 'Shuts down bot'));

  await ctx.reply(content: buffer.toString());
}

Future<void> pingCommand(CommandContext ctx, String content) async {
  await ctx.message.delete();
  final random = Random();
  final color = DiscordColor.fromRgb(
      random.nextInt(255), random.nextInt(255), random.nextInt(255));
  final gatewayDelayInMilis = ctx.client.shardManager.shards
      .firstWhere((element) => element.id == ctx.shardId)
      .gatewayLatency
      .inMilliseconds;
  final stopwatch = Stopwatch()..start();

  final embed = EmbedBuilder()
    ..color = color
    ..addField(
        name: 'Gateway latency',
        content: '$gatewayDelayInMilis ms',
        inline: true)
    ..addField(
        name: 'Message roundup time', content: 'Pending...', inline: true);

  final message = await ctx.reply(embed: embed);

  embed
    ..replaceField(
        name: 'Message roundup time',

        content: '${stopwatch.elapsedMilliseconds} ms',
        inline: true);

  await message.edit(embed: embed);
}

Future<void> infoCommand(CommandContext ctx, String content) async {
  final color = DiscordColor.fromRgb(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));

  final embed = EmbedBuilder()
    ..addAuthor((author) {
      author.name = ctx.client.self.tag;
      author.iconUrl = ctx.client.self.avatarURL();
      author.url = 'https://github.com/mediamagnet/cerys';
    })
    ..addFooter((footer) {
      footer.text =
          'Nyxx 1.0.0 | Shard [${ctx.shardId + 1}] of [${ctx.client.shards}] | ${utils.dartVersion}';
    })
    ..color = color
    ..addField(
        name: 'Uptime', content: ctx.client.uptime.inMinutes, inline: true)
    ..addField(
        name: 'DartVM memory usage',
        content:
            '${(ProcessInfo.currentRss / 1024 / 1024).toStringAsFixed(2)} MB',
        inline: true)
    ..addField(
        name: 'Created at', content: ctx.client.app.createdAt, inline: true)
    ..addField(
        name: 'Guild count', content: ctx.client.guilds.count, inline: true)
    ..addField(
        name: 'Users count', content: ctx.client.users.count, inline: true)
    ..addField(
        name: 'Channels count',
        content: ctx.client.channels.count,
        inline: true)
    ..addField(
        name: 'Users in voice',
        content: ctx.client.guilds.values
            .map((g) => g.voiceStates.count)
            .reduce((f, s) => f + s),
        inline: true)
    ..addField(name: 'Shard count', content: ctx.client.shards, inline: true)
    ..addField(
        name: 'Cached messages',
        content: ctx.client.channels
            .find((item) => item is MessageChannel)
            .cast<MessageChannel>()
            .map((e) => e.messages.count)
            .fold(0, (first, second) => (first as int) + second),
        inline: true);

  await ctx.message.delete();
  await ctx.reply(embed: embed);
}

Future<void> shutdownCommand(CommandContext ctx, String content) async {
  Process.killPid(pid);
}

Future<void> embedCommand(CommandContext ctx, String content) async {
  final color = DiscordColor.fromRgb(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));

  var unescape = HtmlUnescape();
  Map wodembed = json.decode(await File('codex/embed.json').readAsString());
  var keyword = htmlEscape.convert(content.replaceAll('..codex embed ', '').toLowerCase().replaceAll(' ', '_'));
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
      footer.text =
      'Cerys v0.0.1';
    })
    ..color = color
    // ..addField(name: 'Name:', content: unescape.convert(obj['Name']))
    ..addField(name: 'Description:', content: obj['Description'])
    ..addField(name: 'Pool:', content: obj['Pool'], inline: true)
    ..addField(name: 'Type:', content: obj['Type'], inline: true)
    ..addField(name: 'Source', content: obj['Source']);

  await ctx.message.delete();
  await ctx.reply(embed: embed);
}

Future<bool> checkForAdmin(CommandContext context) async {
  if (ownerID != null) {
    return context.author!.id == ownerID;
  }

  return false;
}
