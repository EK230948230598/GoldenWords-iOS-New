//
//  AppDelegate.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-10.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var shortcutItem = UIApplicationShortcutItem?.self
    var specificArticleObject = NSMutableOrderedSet(capacity: 1)
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        NSUserDefaults.standardUserDefaults().setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        var performShortcutDelegate = true
        
        application.statusBarStyle = .LightContent
        
        UINavigationBar.appearance().barTintColor = UIColor.goldenWordsYellow()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 22 )!, NSForegroundColorAttributeName: UIColor.whiteColor()]
//      UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]

        performShortcutDelegate = false
        handleShortcut(shortcutItem)
        
        return performShortcutDelegate
    }
    
    // Code to directly show the right view when opening a specific article's URL from www.goldenwords.ca. Still can't figure out how to correctly parse the JSON.
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        var detailViewControllerFromURL = storyboard.instantiateViewControllerWithIdentifier("CurrentIssueDetailViewControllerIdentifier") as! CurrentIssueDetailViewController
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let stringFromURL = String(url)
        let location = stringFromURL.characters.count - 38
        let articleID = stringFromURL.substringFromIndex(stringFromURL.startIndex.advancedBy(location))
        print(articleID)
        
        Alamofire.request(GWNetworking.Router.SpecificArticle(Int(articleID)!)).responseJSON() { response in
            let JSON = response.result.value as! Dictionary<String,AnyObject>
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                
                if let specificArticleElement : IssueElement = IssueElement(title: "Just another Golden Words article", nodeID: 0, timeStamp: 1442239200, imageURL: "http://goldenwords.ca/sites/all/themes/custom/gw/logo.png", author: "Staff", issueNumber: "Issue # error", volumeNumber: "Volume # error", articleContent: "Looks like the server is acting up again!", coverImageInteger: "init", coverImage: UIImage()) {
                    
                    // get all the JSON values required to display the artile properly
                    
                    
                    
                    self.specificArticleObject.addObject(specificArticleElement)
    
                }
            }
        }
        
        if let object = specificArticleObject.objectAtIndex(0) as? IssueElement {
            
            detailViewControllerFromURL.currentIssueArticleTitleThroughSegue = object.title ?? ""
            detailViewControllerFromURL.currentIssueTimeStampThroughSegue = object.timeStamp ?? 1442239200
            detailViewControllerFromURL.currentIssueAuthorThroughSegue = object.author ?? "Staff"
            detailViewControllerFromURL.currentIssueArticleContentThroughSegue = object.articleContent ?? "Looks like the server is acting up again!"
            detailViewControllerFromURL.currentIssueNodeIDThroughSegue = object.nodeID ?? 0
            detailViewControllerFromURL.currentIssueIssueIndexThroughSegue = object.issueNumber ?? "Issue # error"
            detailViewControllerFromURL.currentIssueVolumeIndexThroughSegue = object.volumeNumber ?? "Volume # error"
            
        }
        
        self.window?.rootViewController = detailViewControllerFromURL // I would maybe need to create a separate navigation controller, and then display the detailViewControllerFromURL from there ? If I don't, I'm worried about the possibility of the back button not appearing properly.
        self.window?.makeKeyAndVisible()
    
        return true
    }
//    */
    
    func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        var succeeded = false
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        if (shortcutItem.type == "com.LeonardBonfils.GoldenWords.Pictures") {
            
            let rootViewController = storyboard.instantiateViewControllerWithIdentifier("revealViewController")
            let navigationController = storyboard.instantiateViewControllerWithIdentifier("PicturesNavigationControllerIdentifier")
//            let navigationController = storyboard.instantiateViewControllerWithIdentifier("Pictures") as! PhotoBrowserCollectionViewController
            
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        
            print("Pictures shortcut loaded")
            succeeded = true
        }
        
        else if (shortcutItem.type == "com.LeonardBonfils.GoldenWords.Videos") {
            
            let navigationController = storyboard.instantiateViewControllerWithIdentifier("VideosNavigationControllerIdentifier")
            
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
            
            print("Videos shortcut loaded")
            succeeded = true
        }
        
        else if (shortcutItem.type == "com.LeonardBonfils.GoldenWords.SavedArticles") {
            
            let navigationController = storyboard.instantiateViewControllerWithIdentifier("SavedArticlesNavigationControllerIdentifier")
            
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
            
            print("Saved Articles shortcut loaded")
            succeeded = true
        }
        
        else {
            print("No shortcut item type detected")
            
            succeeded = true
        }
        
        return succeeded
        
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem))
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var photoViewController = storyboard.instantiateViewControllerWithIdentifier("Pictures") as! PhotoBrowserCollectionViewController
//        
//        var rootViewController = self.window?.rootViewController
//        var revealViewController = self.window?.rootViewController?.revealViewController()
//        
//        if MyGlobalVariables.viewControllerToDisplay == "Pictures" {
//            rootViewController?.presentViewController(photoViewController, animated: true, completion: nil)
//        }
    }

//    func applicationDidBecomeActive(application: UIApplication) {
//        
//        guard let shortcut = shortcutItem else { return }
//        
//        handleShortcut(shortcut)
//        
//        self.shortcutItem = nil
//        
//        
//        
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "LB.CoreDataDemo" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("GWDatabaseModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    
    
}