//
//  GWNetworking.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-09-21.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import Alamofire

//@objc public protocol ResponseObjectSerializable {
//    init?(response: NSHTTPURLResponse, representation: AnyObject)
//}
//
//extension Alamofire.Request {
//    public func responseObject<T: ResponseObjectSerializable>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, T?, NSError?) -> Void) -> Self {
//        let responseSerializer = GenericResponseSerializer<T> { request, response, data in
//            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
//            let (JSON: AnyObject?, serializationError) = JSONResponseSerializer.serializeResponse(request, response, data)
//            
//            if let response = response, JSON: AnyObject = JSON {
//                return (T(response: response, representation: JSON), nil)
//            } else {
//                return (nil, serializationError)
//            }
//        }
//        
//        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
//    }
//}

extension Alamofire.Request {
    
    class func imageResponseSerializer() -> GenericResponseSerializer<UIImage> {
        return GenericResponseSerializer { request, response, data in
            
            guard let validData = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(data, error)
            }
            
            if let image = UIImage(data: validData, scale: UIScreen.mainScreen().scale) {
                return Result<UIImage>.Success(image)
            } else {
                return .Failure(data, Error.errorWithCode(.DataSerializationFailed, failureReason: "Unable to create image"))
            }
        
        }
    }
        
        func responseImage(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<UIImage>) -> Void) -> Self {
            return response(responseSerializer: Request.imageResponseSerializer(), completionHandler: completionHandler)
        }
}

struct GWNetworking {
    enum ImageSize: Int {
        case Tiny = 1
        case Small = 2
        case Medium = 3
        case Large = 4
        case XLarge = 5
    }



enum Router : URLRequestConvertible {
    static let baseURLString = MyGlobalVariables.baseURL
    
    case Issue
    case Editorials(Int)
    case News(Int)
    case Random(Int)
    case Pictures(Int)
    
    var URLRequest: NSMutableURLRequest {
        let path : String
        let parameters: [String: AnyObject]
//        (path, parameters) = {
        (path) = {
            switch self {
//            case .Issue (let volume, let issue):
//                return ("/issue/\(volume)/\(issue)")
            case .Issue:
                return ("/issue")
            case .Editorials (let editorialsSection): // If section == 0, this will return the first ten editorials. If section == 1, then section * 10 = 10, and we will get the ten editorials after that.
                return ("/list/editorials/\(editorialsSection * 10)")
            case .News (let newsSection):
                return ("/list/news/\(newsSection * 10)")
            case .Random (let randomSection):
                return ("/list/random/\(randomSection * 10)")
            case .Pictures (let page):
                return ("/list/pictures/\(page)")
            }
        }()
        
        let URL = NSURL(string: Router.baseURLString)
        let GoldenWordsURLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
        let encoding = Alamofire.ParameterEncoding.URL
        
        return GoldenWordsURLRequest as! NSMutableURLRequest

//        return encoding.encode(URLRequest, parameters: parameters).0
        }
    }
}


class IssueElement: NSObject {
    
    // All JSON variable name equivalents are commented to the right of each Swift variable
    
    var title: String           // title
    let nodeID: Int          // nid
    let timeStamp: String       // revision_timestamp
    let imageURL: String?       // image_url
    let author: String          // author
    
    let issueNumber: String     // issue_int
    let volumeNumber: String    // volume_int
    
    let articleContent: String? // html_content
    
    let coverImage: String // Variable that indicates whether this is the cover page or not (1 for cover, 0 for everything else)
    
    // To get an NSDate objec from Unix timestamp
    // var date = NSDate(timeIntervalSince1970: timeStamp)
    
    init(title: String, nodeID: Int, timeStamp: String, imageURL: String?, author: String, issueNumber: String, volumeNumber: String, articleContent: String, coverImage: String) {
        self.title = title
        self.nodeID = nodeID
        self.timeStamp = timeStamp
        self.imageURL = imageURL
        self.author = author
        self.issueNumber = issueNumber
        self.volumeNumber = volumeNumber
        self.articleContent = articleContent
        self.coverImage = coverImage
    }
    
    override func isEqual(object: AnyObject!) -> Bool {
        return (object as! IssueElement).nodeID == self.nodeID
    }
    
    override var hash: Int {
        return (self as IssueElement).nodeID
    }
    
}

class EditorialElement: NSObject {
    
    var title: String           // title
    let nodeID: Int             // nid
    let timeStamp: String       // revision_timestamp
    let imageURL: String?       // image_url
    let author: String          // author
    
    let issueNumber: String     // issue_int
    let volumeNumber: String    // volume_int
    
    let articleContent: String // html_content
    
    // To get an NSDate objec from Unix timestamp
    // var date = NSDate(timeIntervalSince1970: timeStamp)
    
    init(title: String, nodeID: Int, timeStamp: String, imageURL: String, author: String, issueNumber: String, volumeNumber: String, articleContent: String) {
        self.title = title
        self.nodeID = nodeID
        self.timeStamp = timeStamp
        self.imageURL = imageURL
        self.author = author
        self.issueNumber = issueNumber
        self.volumeNumber = volumeNumber
        self.articleContent = articleContent
    }
    
    override func isEqual(object: AnyObject!) -> Bool {
        return (object as! EditorialElement).nodeID == self.nodeID
    }
    
    override var hash: Int {
        return (self as EditorialElement).nodeID
    }
    
}

class NewsElement: NSObject {
    
    var title: String           // title
    let nodeID: Int          // nid
    let timeStamp: String       // revision_timestamp
    let imageURL: String?       // image_url
    let author: String          // author
    
    let issueNumber: String     // issue_int
    let volumeNumber: String    // volume_int
    
    let articleContent: String // html_content
    
    // To get an NSDate objec from Unix timestamp
    // var date = NSDate(timeIntervalSince1970: timeStamp)
    
    init(title: String, nodeID: Int, timeStamp: String, imageURL: String, author: String, issueNumber: String, volumeNumber: String, articleContent: String) {
        self.title = title
        self.nodeID = nodeID
        self.timeStamp = timeStamp
        self.imageURL = imageURL
        self.author = author
        self.issueNumber = issueNumber
        self.volumeNumber = volumeNumber
        self.articleContent = articleContent
    }
    
    override func isEqual(object: AnyObject!) -> Bool {
        return (object as! NewsElement).nodeID == self.nodeID
    }
    
    override var hash: Int {
        return (self as NewsElement).nodeID
    }
    
}

class RandomElement: NSObject {
    
    var title: String           // title
    let nodeID: Int             // nid
    let timeStamp: String       // revision_timestamp
    let imageURL: String?       // image_url
    let author: String          // author
    
    let issueNumber: String     // issue_int
    let volumeNumber: String    // volume_int
    
    let articleContent: String // html_content
    
    // To get an NSDate objec from Unix timestamp
    // var date = NSDate(timeIntervalSince1970: timeStamp)
    
    init(title: String, nodeID: Int, timeStamp: String, imageURL: String, author: String, issueNumber: String, volumeNumber: String, articleContent: String) {
        self.title = title
        self.nodeID = nodeID
        self.timeStamp = timeStamp
        self.imageURL = imageURL
        self.author = author
        self.issueNumber = issueNumber
        self.volumeNumber = volumeNumber
        self.articleContent = articleContent
        
    }
    
    override func isEqual(object: AnyObject!) -> Bool {
        return (object as! RandomElement).nodeID == self.nodeID
    }
    
    override var hash: Int {
        return (self as RandomElement).nodeID
    }
    
}

class PictureElement: NSObject {
    
    
    var title: String           // title
    let nodeID: Int             // nid
    let timeStamp: String       // revision_timestamp
    let imageURL: String        // image_url
    let author: String          // author
    
    let issueNumber: String     // issue_int
    let volumeNumber: String    // volume_int
    
//    let articleContent: String? // html_content
    
    // To get an NSDate objec from Unix timestamp
    // var date = NSDate(timeIntervalSince1970: timeStamp)
    
    init(title: String, nodeID: Int, timeStamp: String, imageURL: String,  author: String, issueNumber: String, volumeNumber: String) {
        self.title = title
        self.nodeID = nodeID
        self.timeStamp = timeStamp
        self.imageURL = imageURL
        self.author = author
        self.issueNumber = issueNumber
        self.volumeNumber = volumeNumber
        
    }

}