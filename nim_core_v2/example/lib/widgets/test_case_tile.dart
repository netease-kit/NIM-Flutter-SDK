// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

enum _TestCaseState { idle, running, pass, fail }

/// 可复用的测试用例卡片组件
/// 统一展示：用例标题、前置条件说明、运行按钮、通过/失败状态
class TestCaseTile extends StatefulWidget {
  /// 用例标题
  final String title;

  /// 前置条件说明（可选）
  final String? description;

  /// 用例执行回调，抛出异常即视为失败；正常返回即视为通过
  final Future<void> Function() onRun;

  const TestCaseTile({
    Key? key,
    required this.title,
    this.description,
    required this.onRun,
  }) : super(key: key);

  @override
  State<TestCaseTile> createState() => _TestCaseTileState();
}

class _TestCaseTileState extends State<TestCaseTile> {
  _TestCaseState _state = _TestCaseState.idle;
  String? _errorMessage;

  Future<void> _run() async {
    setState(() {
      _state = _TestCaseState.running;
      _errorMessage = null;
    });
    try {
      await widget.onRun();
      setState(() {
        _state = _TestCaseState.pass;
      });
    } catch (e, stack) {
      final msg = e.toString();
      print('[TestCase FAIL] ${widget.title}: $msg\n$stack');
      setState(() {
        _state = _TestCaseState.fail;
        _errorMessage = msg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                _buildStatusIcon(),
                const SizedBox(width: 8),
                _buildButton(),
              ],
            ),
            if (widget.description != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.description!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
            if (_state == _TestCaseState.fail && _errorMessage != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(fontSize: 12, color: Colors.red[700]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (_state) {
      case _TestCaseState.pass:
        return const Icon(Icons.check_circle, color: Colors.green, size: 20);
      case _TestCaseState.fail:
        return const Icon(Icons.cancel, color: Colors.red, size: 20);
      case _TestCaseState.running:
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case _TestCaseState.idle:
        return const SizedBox(width: 20);
    }
  }

  Widget _buildButton() {
    final isRunning = _state == _TestCaseState.running;
    return ElevatedButton(
      onPressed: isRunning ? null : _run,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: const Size(60, 32),
        textStyle: const TextStyle(fontSize: 12),
      ),
      child: Text(isRunning ? '运行中' : '▶ 运行'),
    );
  }
}
