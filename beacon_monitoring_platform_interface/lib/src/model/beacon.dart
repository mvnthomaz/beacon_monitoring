// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import 'dart:convert';

class Beacon {
  static const _ids = 'ids';
  static const _rssi = 'rssi';
  static const _distance = 'distance';

  final List<dynamic> ids;
  final int rssi;
  final double distance;

  Beacon({
    required this.ids,
    required this.rssi,
    required this.distance,
  });

  Beacon.fromJson(Map<String, dynamic> json)
      : ids = json[_ids],
        rssi = json[_rssi].toInt(),
        distance = json[_distance].toDouble();

  Map<String, dynamic> toJson() => {
        _ids: ids,
        _rssi: rssi,
        _distance: distance,
      };

  @override
  String toString() => jsonEncode(toJson());
}
