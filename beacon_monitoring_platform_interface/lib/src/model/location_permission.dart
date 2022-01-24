// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

/// The required permissions for background use are [always],
/// and for foreground use are [whileInUse].
///
/// iOS CLAuthorizationStatus to LocationPermission mapping:
/// notDetermined - denied
/// restricted - denied
/// denied - denied
/// authorizedAlways - always
/// authorizedWhenInUse - whileInUse
///
/// Android permissions to LocationPermission mapping:
/// none - denied
/// ACCESS_FINE_LOCATION - whileInUse
/// ACCESS_FINE_LOCATION and ACCESS_BACKGROUND_LOCATION - always
enum LocationPermission {
  denied,
  always,
  whileInUse,
}

extension LocationPermissionExtension on LocationPermission {
  static parse(String? value) {
    return LocationPermission.values
        .firstWhere((e) => describeEnum(e) == value);
  }
}
