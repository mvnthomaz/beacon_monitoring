// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import 'dart:convert';

import 'beacon.dart';
import 'region.dart';

class RangingResult {
  static const _region = 'region';
  static const _beacons = 'beacons';

  final Region region;
  late final List<Beacon> beacons;

  RangingResult({
    required this.region,
    required this.beacons,
  });

  RangingResult.fromJson(Map<String, dynamic> json)
      : region = Region.fromJson(json[_region]),
        beacons = json[_beacons] != null
            ? (json[_beacons] as List<dynamic>)
                .map((it) => Beacon.fromJson(it as Map<String, dynamic>))
                .toList()
            : List.empty();

  Map<String, dynamic> toJson() => <String, dynamic>{
        _region: region.toJson(),
        _beacons: beacons.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => jsonEncode(toJson());
}
