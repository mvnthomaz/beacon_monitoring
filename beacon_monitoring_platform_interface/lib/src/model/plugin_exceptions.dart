// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import '../config.dart';

const supportedCodes = [
  Config.bluetoothDisabledExceptionCode,
  Config.locationDisabledExceptionCode,
  Config.locationPermissionDeniedExceptionCode
];

class PluginException {
  static bool supports(String code) {
    return supportedCodes.contains(code);
  }

  static PluginException fromCode(String code) {
    switch (code) {
      case Config.bluetoothDisabledExceptionCode:
        return const BluetoothDisabledException();
      case Config.locationDisabledExceptionCode:
        return const LocationDisabledException();
      case Config.locationPermissionDeniedExceptionCode:
        return const LocationPermissionDeniedException();
      default:
        return throw ArgumentError("Unsupported exception code: $code");
    }
  }

  const PluginException();
}

class BluetoothDisabledException extends PluginException {
  const BluetoothDisabledException();
}

class LocationDisabledException extends PluginException {
  const LocationDisabledException();
}

class LocationPermissionDeniedException extends PluginException {
  const LocationPermissionDeniedException();
}
