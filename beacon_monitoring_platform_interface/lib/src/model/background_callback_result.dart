// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import 'dart:convert';

import 'monitoring_result.dart';

class BackgroundCallbackResult {
  static const _monitoringCallbackId = 'monitoringCallbackId';
  static const _monitoringResult = 'monitoringResult';

  final int monitoringCallbackId;
  final MonitoringResult monitoringResult;

  BackgroundCallbackResult.fromJson(Map<String, dynamic> json)
      : monitoringCallbackId = json[_monitoringCallbackId],
        monitoringResult = MonitoringResult.fromJson(
          json[_monitoringResult],
        );

  Map<String, dynamic> toJson() => {
        _monitoringCallbackId: monitoringCallbackId,
        _monitoringResult: monitoringResult.toJson(),
      };

  @override
  String toString() => jsonEncode(toJson());
}
