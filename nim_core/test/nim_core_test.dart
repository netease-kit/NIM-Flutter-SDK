// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:nim_core/nim_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('canLaunch android || ios', () {
    test('interface ', () {
      final result = NimCore.instance.messageService;
      expect(result, null);
    });
  });
}
