// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Foundation

final class NotificationService: NSObject {

    // MARK: - Public Methods
    func trigger(title: String, message: String) {
        if #available(iOS 10.0, *) {
            triggerAfteriOS10(title: title, message: message)
        } else {
            triggerBeforeiOS10(title: title, message: message)
        }
    }

    // MARK: - Private Methods
    @available(iOS 10.0, *)
    private func triggerAfteriOS10(title: String, message: String) {
        guard DependencyContainer.instance.preferencesStorage.isDebugEnabled else { return }

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { isGranted, _ in
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = message
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request, withCompletionHandler: nil)
        }
    }
    private func triggerBeforeiOS10(title: String, message: String) {

    }
}
