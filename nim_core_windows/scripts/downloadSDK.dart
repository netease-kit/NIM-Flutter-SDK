// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

//import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path/path.dart' show dirname, join;
import 'package:process_run/shell.dart';

main() async {
  var url = Platform.isWindows
      ? "https://yx-web-nosdn.netease.im/package/nim-win32-x64-refs-tags-9.6.0.1676-build.312.tar.gz?download=nim-win32-x64-refs-tags-9.6.0.1676-build.312.tar.gz"
      : Platform.isMacOS
          ? "https://yx-web-nosdn.netease.im/package/nim-darwin-x64-refs-tags-9.6.0.1676-build.312.tar.gz?download=nim-darwin-x64-refs-tags-9.6.0.1676-build.312.tar.gz"
          : "";
  if (url.isEmpty) {
    print("[downloadSDK]: Platform not supported.");
    return;
  }

  Uri u = Uri.parse(url);
  var sdkFile = u.queryParameters['download'];
  sdkFile ??= "nim_sdk.zip";

  var tmpdir = join(dirname(Platform.script.path), '../nim_sdk');
  if (Platform.isWindows) {
    tmpdir = tmpdir.substring(1, tmpdir.length);
  }
  var sdk = tmpdir + "/" + sdkFile;
  if (File(sdk).existsSync()) {
    print("[downloadSDK]: sdk existing.");
    return;
  }

  await Directory(tmpdir).create(recursive: true);
  print("[downloadSDK]: start download sdk from $url");

  final request = await HttpClient().getUrl(u);
  final response = await request.close();
  await response.pipe(File(sdk).openWrite());
  print("[downloadSDK]: download the end.");

  print("[downloadSDK]: start decompressing $sdk");
  if (Platform.isWindows) {
    final bytesTmp = new File(sdk).readAsBytesSync();
    final archiveTmpData = new GZipDecoder().decodeBytes(bytesTmp);
    final archiveTmp = new TarDecoder().decodeBytes(archiveTmpData);
    for (var file in archiveTmp) {
      final filename = tmpdir + '/' + '${file.name}';
      if (file.isFile) {
        var outFile = new File(filename);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      } else {
        await new Directory(filename).create(recursive: true);
      }
    }
  } else {
    var shell = Shell();
    shell = shell.cd(tmpdir);
    await shell.run('tar -zxf "$sdk"');
  }

  print("[downloadSDK]: decompression end(successfull).");
}
