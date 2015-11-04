//
//  AboutViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-18.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire
import SwiftyJSON

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    
    var loadingIndicator = UIActivityIndicatorView()
    
    var aboutGoldenWordsSummary = ""
  /*  var aboutGoldenWordsSummary = "Golden Words, founded in 1967, is a non-profit satirical newspaper published by the Engineering Society of Queen’s University. It addresses relevant campus issues whenever applicable with a humorous perspective. We work with volunteers of students from all faculties to produce 26 issues per annual volume. The opinions expressed herein are not necessarily those of the Queen's Engineering Society or of its members. Unless otherwise stated, all submitted material is the property of Golden Words and is reviewed by the editors in accordance with the 2014 editorial policy, which is availiable upon request. The editors reserve the right to make final editing decisions. Any informal complaints or issues regarding the content of the paper should be forwarded to the editors (see below). Any formal complaints or issues should be forwarded to the chair of the Engineering Society Board of Directors (see below)." */

    @IBOutlet weak var aboutWebView: UIWebView!
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingIndicator.backgroundColor = goldenWordsYellow
        self.loadingIndicator.hidesWhenStopped = true
        self.loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.loadingIndicator.color = goldenWordsYellow
        let indicatorCenter = self.view.center
        self.loadingIndicator.center = indicatorCenter
        self.view.addSubview(loadingIndicator)
        self.view.bringSubviewToFront(loadingIndicator)
        
        self.aboutWebView.dataDetectorTypes = UIDataDetectorTypes.Link
        
        loadLatestSummary()
        
        
//        aboutScrollView = UIScrollView(frame: view.bounds)
//        aboutScrollView.contentSize = CGSize(width: self.aboutGoldenWordsLabel.bounds.size.width, height: self.aboutGoldenWordsLabel.bounds.size.height * 2.0)
//        view.addSubview(aboutScrollView)
        
        
    
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLatestSummary() {
        
        self.loadingIndicator.startAnimating()
        
        Alamofire.request(.GET, "http://goldenwords.ca/contentasjson/node/9").responseJSON { response in
            if let JSON = response.result.value {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                    
                    if (JSON .isKindOfClass(NSDictionary)) {
                        
                        if let summary = JSON["body"]!!["und"]!![0]["value"] as? String {
                            self.aboutGoldenWordsSummary = summary
                        } else {
                            self.aboutGoldenWordsSummary = "Golden Words, founded in 1967, is a non-profit satirical newspaper published by the Engineering Society of Queen’s University. It addresses relevant campus issues whenever applicable with a humorous perspective. We work with volunteers of students from all faculties to produce 26 issues per annual volume. The opinions expressed herein are not necessarily those of the Queen's Engineering Society or of its members. Unless otherwise stated, all submitted material is the property of Golden Words and is reviewed by the editors in accordance with the 2014 editorial policy, which is availiable upon request. The editors reserve the right to make final editing decisions. Any informal complaints or issues regarding the content of the paper should be forwarded to the editors (see below). Any formal complaints or issues should be forwarded to the chair of the Engineering Society Board of Directors (see below)."
                        }
                        
                    }
                    
                    self.loadingIndicator.stopAnimating()
                    self.aboutWebView.loadHTMLString(self.aboutGoldenWordsSummary, baseURL: nil)

                    
                    
                }
                
            }
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
