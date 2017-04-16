//
//  AppDelegate.swift
//  Space
//
//  Created by Mustafa Yusuf on 15/04/17.
//  Copyright © 2017 Mustafa Yusuf. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		UIApplication.shared.isStatusBarHidden = false
		UIApplication.shared.statusBarStyle = .lightContent
		UIApplication.shared.isStatusBarHidden = false
		FIRApp.configure()
		
		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.clear], for: UIControlState.normal)
		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.clear], for: UIControlState.selected)
		if #available(iOS 10.0, *) {
			let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
			UNUserNotificationCenter.current().requestAuthorization(
				options: authOptions,
				completionHandler: {_, _ in })
			
			// For iOS 10 display notification (sent via APNS)
			
			UNUserNotificationCenter.current().delegate = self
			// For iOS 10 data message (sent via FCM)
			//FIRMessaging.messaging().remoteMessageDelegate = self
			
		} else {
			let settings: UIUserNotificationSettings =
				UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
			application.registerUserNotificationSettings(settings)
		}
		
		application.registerForRemoteNotifications()
		
		return true
	}
	
	func tokenRefreshNotification(_ notification: Notification) {
		if let refreshedToken = FIRInstanceID.instanceID().token() {
			print("InstanceID token: \(refreshedToken)")
		}
		
		// Connect to FCM since connection may have failed when attempted before having a token.
		connectToFcm()
	}
	
	func connectToFcm() {
		// Won't connect since there is no token
		guard FIRInstanceID.instanceID().token() != nil else {
			return;
		}
		
		// Disconnect previous FCM connection if it exists.
		FIRMessaging.messaging().disconnect()
		
		FIRMessaging.messaging().connect { (error) in
			if error != nil {
				print("Unable to connect with FCM. \(error)")
			} else {
				print("Connected to FCM.")
			}
		}
	}
	
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		
		FIRInstanceID.instanceID().setAPNSToken(deviceToken as Data, type: FIRInstanceIDAPNSTokenType.sandbox)
	}
	
	
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		FIRMessaging.messaging().disconnect()
		print("Disconnected from FCM.")
	}
	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
		// If you are receiving a notification message while your app is in the background,
		// this callback will not be fired till the user taps on the notification launching the application.
		// TODO: Handle data of notification
		
		// Print message ID.
		if let messageID = userInfo["gcmMessageIDKey"] {
			print("Message ID: \(messageID)")
		}
		
		// Print full message.
		print(userInfo)
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		// If you are receiving a notification message while your app is in the background,
		// this callback will not be fired till the user taps on the notification launching the application.
		// TODO: Handle data of notification
		
		// Print message ID.
		if let messageID = userInfo["gcmMessageIDKey"] {
			print("Message ID: \(messageID)")
		}
		
		// Print full message.
		print(userInfo)
		
		completionHandler(UIBackgroundFetchResult.newData)
	}
	
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
		// Let FCM know about the message for analytics etc.
		FIRMessaging.messaging().appDidReceiveMessage(userInfo)
		// handle your message
	}


	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {
	    /*
	     The persistent container for the application. This implementation
	     creates and returns a container, having loaded the store for the
	     application to it. This property is optional since there are legitimate
	     error conditions that could cause the creation of the store to fail.
	    */
	    let container = NSPersistentContainer(name: "Space")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	             
	            /*
	             Typical reasons for an error here include:
	             * The parent directory does not exist, cannot be created, or disallows writing.
	             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
	             * The device is out of space.
	             * The store could not be migrated to the current model version.
	             Check the error message to determine what the actual problem was.
	             */
	            fatalError("Unresolved error \(error), \(error.userInfo)")
	        }
	    })
	    return container
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}

}

