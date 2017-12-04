//
//  ViewController.swift
//  HODL-iOS
//
//  Created by Jake on 12/3/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    // MARK: - Properties
    let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Subviews
    lazy var hodlLabel = UILabel()
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHodlLabel()
        setupNotifications()
        sendNotification()
    }
    
    // MARK: - Setups
    func setupView() {
        view.backgroundColor = .white
    }
    
    func setupHodlLabel() {
        hodlLabel.text = "HODL your coins!"
        hodlLabel.textColor = .orange
        hodlLabel.textAlignment = .center
        
        hodlLabel.frame = view.bounds
        view.addSubview(hodlLabel)
    }
    
    func requestNotificationAuthorization() {
        notificationCenter.requestAuthorization(options: .alert) {
            (granted, error) in
            
            // Error granting Authorization
            if let error = error {
                assertionFailure("Error requesting notification authorization: \(error)")
            }
            
            // Authorization granted
            guard granted else { return }
        }
    }
    
    func setupNotifications() {
        requestNotificationAuthorization()

        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Request notification authorization or respond accordingly
                self.requestNotificationAuthorization()
            }
        }
    }
    
    
    // MARK: - Helpers
    func sendNotification() {
        print(#function)
        
        // Notification Content
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = NSString.localizedUserNotificationString(forKey: "Hey, it's your fellow HODLer!", arguments: nil)
        notificationContent.body = NSString.localizedUserNotificationString(forKey: "Remember to HODL and not sell early", arguments: nil)
        notificationContent.sound = UNNotificationSound.default()

        // Configure the trigger for a 7am wakeup.
        var dateComponents = DateComponents()
        dateComponents.hour = 17
        dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create the request object.
        let notificationRequest = UNNotificationRequest(identifier: "HODLNotification", content: notificationContent, trigger: trigger)
       
        // Request
        notificationCenter.add(notificationRequest) { (error) in
            if let error = error {
                assertionFailure("Error sending notification: \(error)")
            }
        }
    }

}

