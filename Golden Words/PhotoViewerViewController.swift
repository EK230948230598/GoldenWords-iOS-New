//
//  PhotoViewerViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-09-21.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import AlamofireImage

class PhotoViewerViewController: UIViewController, UIScrollViewDelegate {
    
    var imageURLForViewerController: String = ""
    var imageToStore = UIImage()
    
    var photoInfo: PictureElement?
    
    var spinner = UIActivityIndicatorView()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    
    var lastZoomScale: CGFloat = 0
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        view.addGestureRecognizer(doubleTapRecognizer)
        
        self.imageView.image = self.imageToStore
        self.spinner.stopAnimating()
        scrollView.delegate = self
        updateZoom()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor.blackColor()
        self.scrollView.backgroundColor = UIColor.blackColor()
        
        spinner.center = self.view.center
        spinner.color = UIColor.goldenWordsYellow()
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        view.addSubview(spinner)
        
        updateZoom()
        updateConstraints()
        
        
//        self.imageView.center = self.scrollView.center
        
        loadPhoto()
    }
    
    func loadPhoto() {
        
        Alamofire.request(.GET, imageURLForViewerController).responseImage { response in
            
            if let image = response.result.value {
                print("image downloaded : \(image)")
                
                self.imageToStore = image
//                                self.imageView.frame = self.scrollView.frame
                //                self.spinner.stopAnimating()
                //                self.centerScrollViewContents()
            }
        }
    }
    
    // Update zoom scale and constraints with animation.
    override func viewWillTransitionToSize(size: CGSize,
        withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
            
            super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
            
            coordinator.animateAlongsideTransition({ [weak self] _ in
                self?.updateZoom()
                }, completion: nil)
    }
    
    //
    // Update zoom scale and constraints with animation on iOS 7.
    //
    // DEPRECATION NOTICE:
    //
    // This method is deprecated in iOS 8.0 and it is here just for iOS 7.
    // You can safely remove this method if you are not supporting iOS 7.
    // Or if you do support iOS 7 you can leave it here as it will be ignored by the newer iOS versions.
    //
//    override func willAnimateRotationToInterfaceOrientation(
//        toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
//            
//            super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
//            updateZoom()
//    }
    
    func updateConstraints() {
        if let image = imageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            let viewWidth = scrollView.bounds.size.width
            let viewHeight = scrollView.bounds.size.height
            
            // center image if it is smaller than the scroll view
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }
            
            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }
            
            imageConstraintLeft.constant = hPadding
            imageConstraintRight.constant = hPadding
            
            imageConstraintTop.constant = vPadding
            imageConstraintBottom.constant = vPadding
            
            view.layoutIfNeeded()
        }
    }
    
    // Zoom to show as much image as possible unless image is smaller than the scroll view
    private func updateZoom() {
        if let image = imageView.image {
            var minZoom = min(scrollView.bounds.size.width / image.size.width,
                scrollView.bounds.size.height / image.size.height)
            
            if minZoom > 1 { minZoom = 1 }
            
            scrollView.minimumZoomScale = minZoom
            
            // Force scrollViewDidZoom fire if zoom did not change
            if minZoom == lastZoomScale { minZoom += 0.000001 }
            
            scrollView.zoomScale = minZoom
            lastZoomScale = minZoom
        }
    }
    
    // UIScrollViewDelegate
    // -----------------------
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        
        let savePicture = UIPreviewAction(title: "Save", style: .Default) { (action, viewController) -> Void in
        }
        
        let sharePicture = UIPreviewAction(title: "Share", style: .Default) { (action, viewController) -> Void in
        }
        
        return [savePicture, sharePicture]
    }
    
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
////        setupView()
////        loadPhoto()
//        
//        
//        
//        
//        
//        
//        
//    }
    

//    func setupView() {
//        spinner.center = self.imageView.center
////        spinner.center = CGPoint(x: view.center.x, y: view.center.y - view.bounds.origin.y / 2.0)
//        spinner.color = UIColor.goldenWordsYellow()
//        spinner.hidesWhenStopped = true
//        spinner.startAnimating()
//        view.addSubview(spinner)
//        
//        scrollView.frame = view.bounds
//        scrollView.delegate = self
//        scrollView.minimumZoomScale = 1.0
//        scrollView.maximumZoomScale = 3.0
//        scrollView.zoomScale = 1.0
//        view.addSubview(scrollView)
//        
//        imageView.contentMode = .ScaleAspectFit
//        scrollView.addSubview(imageView)
//        
//        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
//        doubleTapRecognizer.numberOfTapsRequired = 2
//        doubleTapRecognizer.numberOfTouchesRequired = 1
//        view.addGestureRecognizer(doubleTapRecognizer)
//    }
        
//        self.imageView.frame = self.view.frame
//        self.view.bringSubviewToFront(imageView)
//        self.spinner.stopAnimating()
//        self.centerScrollViewContents()

//
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        if photoInfo != nil {
//            navigationController?.setToolbarHidden(false, animated: true)
//        }
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setToolbarHidden(true, animated: true)
//    }
    
    /*
    func addButtonBar() {
        var items = [UIBarButtonItem]()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        items.append(barButtonItemWithImageNamed("hamburger", title: nil, action: "showDetails"))
        
//        if (photoInfo?.commentsCount > 0) {
//            items.append(barButtonItemWithImageNamed("bubble", title: "\(photoInfo?.commentsCount ?? 0)", action: "showComments"))
//        }
        
        items.append(flexibleSpace)
        items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "showActions"))
        items.append(flexibleSpace)
        
        self.setToolbarItems(items, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
    } */
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.OverCurrentContext
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style:UIModalPresentationStyle) -> UIViewController? {
        let navController = UINavigationController(rootViewController: controller.presentedViewController)
        
        return navController
    }
    
    func barButtonItemWithImageNamed(imageName: String?, title: String?, action: Selector? = nil) -> UIBarButtonItem {
        let button = UIButton(type: .Custom)
        
        if imageName != nil {
            button.setImage(UIImage(named: imageName!)!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        }
        
        if title != nil {
            button.setTitle(title, forState: .Normal)
            button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
            
            let font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
            button.titleLabel?.font = font
        }
        
        let size = button.sizeThatFits(CGSize(width: 90.0, height: 30.0))
        button.frame.size = CGSize(width: min(size.width + 10.0, 60), height: size.height)
        
        if action != nil {
            button.addTarget(self, action: action!, forControlEvents: .TouchUpInside)
        }
        
        let barButton = UIBarButtonItem(customView: button)
        
        return barButton
    }
    
    func showActions() {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Download Photo")
        actionSheet.showFromToolbar(((navigationController?.toolbar)!)!)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            downloadPhoto()
        }
    } */
    
    
    
    
    // MARK: Zooming
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer!) {
        let pointInView = recognizer.locationInView(self.imageView)
        self.zoomInZoomOut(pointInView)
    }
//
//    func centerFrameFromImage(image: UIImage?) -> CGRect {
//        if image == nil {
//            return CGRectZero
//        }
//        
//        let scaleFactor = scrollView.frame.size.width / image!.size.width
//        let newHeight = image!.size.height * scaleFactor
//        
//        var newImageSize = CGSize(width: scrollView.frame.size.width, height: newHeight)
//        
//        newImageSize.height = min(scrollView.frame.size.height, newImageSize.height)
//        
//        let centerFrame = CGRect(x: 0.0, y: scrollView.frame.size.height/2 - newImageSize.height/2 , width: newImageSize.height, height: newImageSize.height)
//        
//        return centerFrame
//    }
//    
//    func scrollViewDidZoom(scrollView: UIScrollView) {
//        self.centerScrollViewContents()
//    }
//    
//    func centerScrollViewContents() {
//        let boundsSize = scrollView.frame
//        var contentsFrame = self.imageView.frame
//        
//        if contentsFrame.size.width < boundsSize.width {
//            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
//        } else {
//            contentsFrame.origin.x = 0.0
//        }
//        
//        if contentsFrame.size.height < boundsSize.height {
//            contentsFrame.origin.y = (boundsSize.height - scrollView.scrollIndicatorInsets.top - scrollView.scrollIndicatorInsets.bottom - contentsFrame.size.height) / 2.0
//        } else {
//            contentsFrame.origin.y = 0.0
//        }
//        
//        self.imageView.frame = contentsFrame
//    }
//    
//    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//        return self.imageView
//    }
//    
    // Zooming function
    func zoomInZoomOut(point: CGPoint!) {
        let newZoomScale = self.scrollView.zoomScale > (self.scrollView.maximumZoomScale/2) ? self.scrollView.minimumZoomScale : self.scrollView.maximumZoomScale
        
        let scrollViewSize = self.scrollView.bounds.size
        
        let width = scrollViewSize.width / newZoomScale
        let height = scrollViewSize.height / newZoomScale
        let x = point.x - (width / 2.0)
        let y = point.y - (height / 2.0)
        
        let rectToZoom = CGRect(x: x, y: y, width: width, height: height)
        
        self.scrollView.zoomToRect(rectToZoom, animated: true)
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
