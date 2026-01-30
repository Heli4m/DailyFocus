//
//  RequestPermissionNotification.swift
//  DailyFocus
//
//  Created by Liam Ngo on 28/1/26.
//

import Foundation
import UserNotifications

func requestNotifyPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("Success")
        } else {
            print("Fail")
        }
    }
}
