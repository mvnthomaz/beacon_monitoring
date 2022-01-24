// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

class Region {
  static const _ids = 'ids';
  static const _identifier = 'identifier';

  final String identifier;
  final List<dynamic> ids;

  Region({
    required this.identifier,
    this.ids = const [],
  });

  Region.fromJson(Map<String, dynamic> json)
      : identifier = json[_identifier],
        ids = json[_ids];

  Map<String, dynamic> toJson() => <String, dynamic>{
        _identifier: identifier,
        _ids: ids,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class RegionIBeacon extends Region {
  RegionIBeacon({
    required String identifier,
    String? proximityUUID,
    int? major,
    int? minor,
  }) : super(
          identifier: identifier,
          ids: [],
        ) {
    if (Platform.isIOS) {
      assert(
        proximityUUID != null,
        'Scanning beacon for iOS must provided proximityUUID',
      );
    }
    ids.add(proximityUUID);
    if (major != null) {
      ids.add(major);
    }
    if (minor != null) {
      ids.add(minor);
    }
  }

  RegionIBeacon.from(Region region)
      : this(
          identifier: region.identifier,
          proximityUUID: region.ids[0],
          major: region.ids.length > 1 ? region.ids[1] : null,
          minor: region.ids.length > 2 ? region.ids[2] : null,
        );

  String get proximityUUID => ids[0];

  int? get major => ids.length > 1 ? ids[1] : null;

  int? get minor => ids.length > 2 ? ids[2] : null;
}
