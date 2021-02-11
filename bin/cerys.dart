import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart'
    show CommandContext, CommandGroup, Commander;
import 'package:toml/loader/fs.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math' show Random;
import 'dart:io' show Process, ProcessInfo, pid, sleep;
import 'utils.dart' as utils;
import 'codex.dart' as codex;
import 'package:cron/cron.dart';

var ownerID;
// ignore: prefer_single_quotes

var launch = DateTime.now();

var prefix;

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

Future main(List<String> arguments) async {
  final cron = Cron();
  FilesystemConfigLoader.use();
  var cfg;
  try {
    cfg = await loadConfig('config.toml');
    print(cfg['Bot']['ID']);
    ownerID = cfg['Owner']['ID'];
    prefix = cfg['Bot']['Prefix'];

    final bot = Nyxx(cfg['Bot']['Token'], GatewayIntents.all);

    bot.onReady.listen((ReadyEvent e) {
      print('Connected to discord.');
      bot.setPresence(PresenceBuilder.of(
          game: Activity.of('Cerys v2',
              type: ActivityType.streaming,
              url: 'https://github.com/mediamagnet/cerys')));

      cron.schedule(Schedule.parse('15,45 * * * *'), () async {
        bot.setPresence(PresenceBuilder.of(
            game: Activity.of("with The God Machine's Gears",
                type: ActivityType.game,
                url: 'https://github.com/mediamagnet/cerys')));
      });
      cron.schedule(Schedule.parse('00,30 * * * *'), () async {
        bot.setPresence(PresenceBuilder.of(
            game: Activity.of('${cfg['Bot']['Prefix']}help',
                type: ActivityType.listening,
                url: 'https://github.com/mediamagnet/cerys')));
      });
    });

    bot.onMessageReceived.listen((MessageReceivedEvent e) {
      if (e.message.content.contains('<@!768908244008960011>')) {
        e.message.createReaction(UnicodeEmoji('❤'));
      }
    });

    Commander(bot, prefix: cfg['Bot']['Prefix'])
      ..registerCommandGroup(CommandGroup(beforeHandler: checkForAdmin)
        ..registerSubCommand('shutdown', shutdownCommand))
      ..registerCommandGroup(CommandGroup(name: 'codex')
        ..registerSubCommand('embed', codex.embedCommand)
        ..registerSubCommand('exploit', codex.exploitCommand)
        ..registerSubCommand('demon forms', codex.demonFormsCommand)
        ..registerSubCommand('cruac', codex.cruacCommand)
        ..registerSubCommand('gifts', codex.giftCommand)
        ..registerSubCommand('condition', codex.conditionCommand))
      ..registerCommand('test', testCommand)
      ..registerCommand('help', helpCommand)
      ..registerCommand('info', infoCommand)
      ..registerCommand('ping', pingCommand)
      ..registerCommand('moon', moonCommand);
  } catch (e) {
    print(e);
  }
  return cfg;
}

Future<void> helpCommand(CommandContext ctx, String content) async {
  await ctx.sendMessage(content: "I can't do that yet");
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

  final message = await ctx.sendMessage(embed: embed);

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
          'Nyxx 1.1.0-dev | Shard [${ctx.shardId + 1}] of [${ctx.client.shards}] | ${utils.dartVersion}';
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
        name: "Cached messages",
        content: ctx.client.channels
            .find((item) => item is TextChannel)
            .cast<TextChannel>()
            .map((e) => e.messageCache.count)
            .fold(0, (first, second) => (first as int) + second),
        inline: true);
  await ctx.message.delete();
  await ctx.sendMessage(embed: embed);
}

Future<void> shutdownCommand(CommandContext ctx, String content) async {
  await ctx.message.delete();
  await ctx.sendMessage(content: "I guess... if that's what you want.");
  Process.killPid(pid);
}

Future<void> testCommand(CommandContext ctx, String content) async {
  var page = content.replaceAll('||test ', '').split(' ').first;
  var keyterm = content.replaceAll('||test ${page} ', '');
  var output = await utils.wodScrape(page);
  var embed = EmbedBuilder();
  final color = DiscordColor.fromRgb(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));

  Map wodembed = jsonDecode(output);

  // var keyword = htmlEscape.convert(keyterm);
  print(keyterm);
  var obj = wodembed[keyterm];
  print(obj.keys);
  print(obj);

  if (obj.keys.elementAt(0) == 'Type') {
    embed = EmbedBuilder()
      ..addAuthor((author) {
        author.name = obj.values.elementAt(1);
        author.iconUrl =
            'https://cdn.discordapp.com/emojis/269519439354003456.png?v=1';
        author.url = 'https://github.com/mediamagnet/cerys';
      })
      ..addFooter((footer) {
        footer.text = 'Cerys v0.0.1';
      })
      ..color = color
      ..addField(
          name: '${obj.keys.elementAt(2)}:', content: obj.values.elementAt(2))
      ..addField(
          name: '${obj.keys.elementAt(3)}:',
          content: obj.values.elementAt(3),
          inline: true)
      ..addField(
          name: '${obj.keys.elementAt(0)}:',
          content: obj.values.elementAt(0),
          inline: true)
      ..addField(
          name: '${obj.keys.elementAt(4)}:', content: obj.values.elementAt(4));
  } else {
    embed = EmbedBuilder()
      ..addAuthor((author) {
        author.name = obj.values.elementAt(0);
        author.iconUrl =
            'https://cdn.discordapp.com/emojis/269519439354003456.png?v=1';
        author.url = 'https://github.com/mediamagnet/cerys';
      })
      ..addFooter((footer) {
        footer.text = 'Cerys v0.0.1';
      })
      ..color = color
      ..addField(
          name: '${obj.keys.elementAt(1)}:', content: obj.values.elementAt(1))
      ..addField(
          name: '${obj.keys.elementAt(2)}:',
          content: obj.values.elementAt(2),
          inline: true)
      ..addField(
          name: '${obj.keys.elementAt(3)}:',
          content: obj.values.elementAt(3),
          inline: true)
      ..addField(
          name: '${obj.keys.elementAt(4)}:', content: obj.values.elementAt(4));
  }

  await ctx.message.delete();
  await ctx.sendMessage(embed: embed);
}

Future<void> moonCommand(CommandContext ctx, String content) async {
  var cont = content.split(' ');
  if (cont.last == 'moon' || cont.last == '${prefix}moon') {
    await ctx.sendMessage(content: 'https://wttr.in/moon.png');
  } else {
    await ctx.sendMessage(content: 'https://wttr.in/moon@${cont.last}.png');
  }
}

Future<bool> checkForAdmin(CommandContext context) async {
  if (ownerID != null) {
    return context.author.id == ownerID;
  }

  return false;
}
