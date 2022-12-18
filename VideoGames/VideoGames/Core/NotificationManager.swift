//
//  NotificationManager.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 17.12.2022.
//

import Foundation

import UIKit
import UserNotifications

class NotificationManager: NSObject {

  static let shared = NotificationManager()

  private override init() {}

  func registerForPushNotifications() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
      (granted, error) in
      print("Permission granted: \(granted)")

      guard granted else { return }
      self.getNotificationSettings()
    }
  }
   
  func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
      print("Notification settings: \(settings)")
    }
  }

  func scheduleNotification(notificationType: String) {
    let content = UNMutableNotificationContent()
    let userAction = "User Action"

    content.title = notificationType
    content.body = "This is example how to create " + notificationType
    content.sound = UNNotificationSound.default
    content.badge = 1
    content.categoryIdentifier = userAction

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    let request = UNNotificationRequest(identifier: "10.second.message", content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { (error) in
      if let error = error {
        print("Error: \(error)")
      }
    }
  }
}
