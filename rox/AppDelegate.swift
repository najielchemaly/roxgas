//
//  AppDelegate.swift
//  rox
//
//  Created by MR.CHEMALY on 10/11/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager!
    
    let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
    let gcmMessageIDKey: String = "message"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        GMSServices.provideAPIKey(GMS_APIKEY)
        
        self.registerForRemoteNotifications(application: application)
        
//        self.initializeLocationManager()
        
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getGlobalVariables()
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.jsonArray?.last {
                    if let productsArray = json["Products"] as? [NSDictionary] {
                        DatabaseObjects.products = [Product]()
                        for productJson in productsArray {
                            if let product = Product.init(dictionary: productJson) {
                                DatabaseObjects.products.append(product)
                            }
                        }
                    }
                    
                    if let provincesArray = json["Province"] as? [NSDictionary] {
                        DatabaseObjects.provinces = [Province]()
                        for provinceJson in provincesArray {
                            if let province = Province.init(dictionary: provinceJson) {
                                DatabaseObjects.provinces.append(province)
                            }
                        }
                    }
                    
                    if let refillsArray = json["Refill"] as? [NSDictionary] {
                        DatabaseObjects.refills = [Refill]()
                        for refillJson in refillsArray {
                            if let refill = Refill.init(dictionary: refillJson) {
                                DatabaseObjects.refills.append(refill)
                            }
                        }
                    }
                    
                    if let deliveryChargesArray = json["DeliveryCharge"] as? [NSDictionary] {
                        DatabaseObjects.deliveryCharges = [DeliveryCharge]()
                        for deliveryChargeJson in deliveryChargesArray {
                            if let deliveryCharge = DeliveryCharge.init(dictionary: deliveryChargeJson) {
                                DatabaseObjects.deliveryCharges.append(deliveryCharge)
                            }
                        }
                    }
                    
                    if let isInReview = json["is_review"] as? Int {
                        DatabaseObjects.IS_IN_REVIEW = isInReview == 1 ? true : false
                    }
                }
            }
        }
        
        if let data = UserDefaults.standard.data(forKey: "user"),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
            if let navTabBar = storyboard.instantiateViewController(withIdentifier: "mainNavBar") as? UINavigationController {
                DatabaseObjects.user = user
                self.window?.rootViewController = navTabBar
            }
        }
        
        return true
    }
    
    func initializeLocationManager() {
        if self.locationManager == nil {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
        }
        
        if #available(iOS 8.0, *) {
            if CLLocationManager.authorizationStatus() == .notDetermined {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DatabaseObjects.USER_LOCATION = location
        }
    }
    
    func registerForRemoteNotifications(application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        DatabaseObjects.FIREBASE_TOKEN = fcmToken
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        if let fcmToken = Messaging.messaging().fcmToken {
            DatabaseObjects.FIREBASE_TOKEN = fcmToken
        }
        
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        
        DispatchQueue.global(qos: .background).async {
            _ = Services.init().updateToken()
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

