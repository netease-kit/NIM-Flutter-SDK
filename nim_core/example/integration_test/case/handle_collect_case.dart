// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:nim_core/nim_core.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

class HandleCollectCase extends HandleBaseCase {
  HandleCollectCase();

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);
    // var inputParams = Map<String, dynamic>();
    // if (params != null && params!.length > 0) {
    //   inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
    // }
    final decodedParams = params?.map((e) => jsonDecode(e)).toList();
    switch (methodName) {
      case addCollect:
        {
          final inputParams = decodedParams![0] as Map<String, dynamic>;
          final result = await NimCore.instance.messageService.addCollect(
            type: inputParams["type"],
            data: inputParams["data"],
            ext: inputParams["ext"],
            uniqueId: inputParams["uniqueId"],
          );
          handleCaseResult = ResultBean(
              code: result.code, message: methodName, data: result.toMap());
          break;
        }
      case removeCollect:
        {
          // 先添加一条然后删除
          // final send = await NimCore.instance.messageService.addCollect(
          //     type: inputParams["type"],
          //     data: inputParams["data"],
          //     ext: inputParams["ext"]);

          final result = await NimCore.instance.messageService.removeCollect(
            decodedParams?.map((e) {
                  final inner = (e as Map<String, dynamic>).entries.first.value;
                  return NIMCollectInfo.fromMap(inner as Map<String, dynamic>);
                }).toList() ??
                [],
          );
          handleCaseResult = ResultBean(
              code: result.code, message: methodName, data: result.toMap());
          break;
        }
      case updateCollect:
        {
          // 先添加一条然后更新
          // final send = await NimCore.instance.messageService.addCollect(
          //     type: inputParams["type"],
          //     data: inputParams["data"],
          //     ext: inputParams["sendExt"]);
          final result = await NimCore.instance.messageService.updateCollect(
              NIMCollectInfo.fromMap(
                  decodedParams![0] as Map<String, dynamic>));
          handleCaseResult = ResultBean(
              code: result.code, message: methodName, data: result.toMap());
          break;
        }
      case queryCollect:
        {
          final args = decodedParams![0] as Map<String, dynamic>;
          final anchor = args.containsKey('anchor')
              ? NIMCollectInfo.fromMap(args['anchor'])
              : null;
          final type = args['type'] as int?;
          final toTime = args['toTime'] as int;
          final limit = args['limit'] as int;
          final direction = args['direction'] as int?;
          final result = await NimCore.instance.messageService.queryCollect(
            anchor: anchor,
            toTime: toTime,
            type: type,
            limit: limit,
            direction: direction == 0
                ? QueryDirection.QUERY_OLD
                : QueryDirection.QUERY_NEW,
          );
          handleCaseResult = ResultBean(
              code: result.code, message: methodName, data: result.toMap());
          break;
        }
    }
    return handleCaseResult;
  }
}
