//
//  APIManager.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 23/08/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

class APIManager: NSObject {

    let cacheSelectBook = YYCache.init(name: "SelectBookCache")//////////////////////////////////////

    let baseURL = "http://magentoapp.newsoftdemo.info/adminapp/"//http://magentoapp.newsoftdemo.info/adminapp/user/login/
    static let sharedInstance = APIManager()
    static let getPostsEndpoint = ""
    var websiteToken = ""
    var websiteId = ""
    var requestResponseBool = Bool()
    
    
    func postRequestWithId(appendParam: String,bodyData : String,presentingView : UIView, onSuccess: @escaping(AnyObject) -> Void, onFailure: @escaping(Error) -> Void){
        
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
        }
        else{
            print("disConnected")
            
            
            if (self.getParentViewController(subV: presentingView) != nil) {
                
                let vc = self.getParentViewController(subV: presentingView)
                
                ObjRef.sharedInstance.showAlertController(msg: "Please check your internet connection", superVC: vc!)
            }
            
            return
        }
        
        
        var vc = UIViewController()
        var homeVC = UIViewController()
        var showLoader = Bool()
        showLoader = true
        
        if presentingView is UIButton {
            showLoader = false
        }
        
        if showLoader == true {
            vc = self.getParentViewController(subV: presentingView)!

            if let vcHome = vc.parent?.parent?.parent as? HomeViewController {
                homeVC = vcHome
                vcHome.view.isUserInteractionEnabled = false
            }
            if let vcHome = vc.parent?.parent as? HomeViewController {
                homeVC = vcHome
                vcHome.view.isUserInteractionEnabled = false
            }
            if let vcHome = vc.parent as? HomeViewController {
                homeVC = vcHome
                vcHome.view.isUserInteractionEnabled = false
            }
            
            MBProgressHUD.showAdded(to: presentingView, animated: true)
        }

        
        //let url : String = baseURL + APIManager.getPostsEndpoint + String(postId)
        var url : String = baseURL + appendParam
        if appendParam == "scan" {
            url = "https://www.zedrox.com/webservice/register.php"
        }
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
       // request.timeoutInterval = 60
        //request.allHTTPHeaderFields = ["adf": "GL_DRAW_BUFFER0","adf": "GL_DRAW_BUFFER0"]
        // request.setValue("Client-ID <your_client_id>", forHTTPHeaderField: "Authorization")
        // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        
        
        request.httpBody = bodyData.data(using: String.Encoding.ascii, allowLossyConversion: true)
        
        let session = URLSession.shared
        
        //DispatchQueue.global(qos: .background).async {
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                
                if (self.getParentViewController(subV: presentingView) != nil) {
                    
                    let vc = self.getParentViewController(subV: presentingView)
                    
                    ObjRef.sharedInstance.showAlertController(msg: (error?.localizedDescription)!, superVC: vc!)
                }
                if showLoader == true {
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        MBProgressHUD.hide(for: presentingView, animated: true)
                        homeVC.view.isUserInteractionEnabled = true
                        
                    })
                }
                onFailure(error!)
            } else{
                do {
                    //let result = try JSON(data: data!)
                    if showLoader == true {
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            MBProgressHUD.hide(for: presentingView, animated: true)
                            homeVC.view.isUserInteractionEnabled = true
                            
                        })
                    }
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    // use jsonObject here
                    onSuccess(jsonObject as AnyObject)
                }
                catch {
                    if showLoader == true {
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            MBProgressHUD.hide(for: presentingView, animated: true)
                            homeVC.view.isUserInteractionEnabled = true
                            
                        })
                    }
                    if (self.getParentViewController(subV: presentingView) != nil) {
                        
                        let vc = self.getParentViewController(subV: presentingView)
                        
                        ObjRef.sharedInstance.showAlertController(msg: error.localizedDescription, superVC: vc!)
                    }
                    
                    onFailure(error)
                }
            }
        })
        task.resume()
        //}
    }
    
    func postRequestWithIdAndMultipart(appendParam: String,dataParam:NSMutableDictionary,presentingView : UIView, onSuccess: @escaping(AnyObject) -> Void, onFailure: @escaping(Error) -> Void){
        
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
        }
        else{
            print("disConnected")
            
            
            if (self.getParentViewController(subV: presentingView) != nil) {
                
                let vc = self.getParentViewController(subV: presentingView)
                
                ObjRef.sharedInstance.showAlertController(msg: "Please check your internet connection", superVC: vc!)
            }
            
            return
        }
        
        let vc = self.getParentViewController(subV: presentingView)
        var homeVC = UIViewController()
        if let vcHome = vc?.parent?.parent?.parent as? HomeViewController {
            homeVC = vcHome
            vcHome.view.isUserInteractionEnabled = false
        }
        if let vcHome = vc?.parent?.parent as? HomeViewController {
            homeVC = vcHome
            vcHome.view.isUserInteractionEnabled = false
        }
        if let vcHome = vc?.parent as? HomeViewController {
            homeVC = vcHome
            vcHome.view.isUserInteractionEnabled = false
        }
        
        MBProgressHUD.showAdded(to: presentingView, animated: true)
        
        
        //let url : String = baseURL + APIManager.getPostsEndpoint + String(postId)
        var url : String = baseURL + appendParam
        let boundary = generateBoundaryString()
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = createBodyWithParameters(parameters: dataParam, boundary: boundary) as Data
        
        let session = URLSession.shared
        
        //DispatchQueue.global(qos: .background).async {
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                
                if (self.getParentViewController(subV: presentingView) != nil) {
                    
                    let vc = self.getParentViewController(subV: presentingView)
                    
                    ObjRef.sharedInstance.showAlertController(msg: (error?.localizedDescription)!, superVC: vc!)
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    MBProgressHUD.hide(for: presentingView, animated: true)
                    homeVC.view.isUserInteractionEnabled = true
                    
                })
                onFailure(error!)
            } else{
                do {
                    //let result = try JSON(data: data!)
                    DispatchQueue.main.async(execute: { () -> Void in
                        MBProgressHUD.hide(for: presentingView, animated: true)
                        homeVC.view.isUserInteractionEnabled = true
                        
                    })
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    // use jsonObject here
                    onSuccess(jsonObject as AnyObject)
                }
                catch {
                    DispatchQueue.main.async(execute: { () -> Void in
                        MBProgressHUD.hide(for: presentingView, animated: true)
                        homeVC.view.isUserInteractionEnabled = true
                        
                    })
                    if (self.getParentViewController(subV: presentingView) != nil) {
                        
                        let vc = self.getParentViewController(subV: presentingView)
                        
                        ObjRef.sharedInstance.showAlertController(msg: error.localizedDescription, superVC: vc!)
                    }
                    
                    onFailure(error)
                }
            }
        })
        task.resume()
        //}
    }
    func createBodyWithParameters(parameters: NSMutableDictionary?,boundary: String) -> NSData {
        let body = NSMutableData()
        var strReq = "" as! NSString
        if parameters != nil {
            for (key, value) in parameters! {
                
                if(value is String || value is NSString){
                    strReq = strReq.appending("--\(boundary)\r\n") as NSString
                    body.appendString("--\(boundary)\r\n")
                    strReq = strReq.appending("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n") as NSString
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    strReq = strReq.appending("\(value)\r\n") as NSString
                    body.appendString("\(value)\r\n")
                }
                else if(value is [UIImage]){
                    var i = 0;
                    for image in value as! [UIImage]{
                        let filename = "image\(i).jpg"
                        let data = UIImageJPEGRepresentation(image,0.4);
                        let mimetype = mimeTypeForPath(path: filename)
                        strReq = strReq.appending("--\(boundary)\r\n") as NSString
                        body.appendString("--\(boundary)\r\n")
                        body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                        strReq = strReq.appending("Content-Disposition: form-data; name=\"images[\(i)]\"; filename=\"\(filename)\"\r\n") as NSString
                        //body.appendString("Content-Disposition: form-data; name=\"images[\(i)]\"; filename=\"\(filename)\"\r\n")
                        strReq = strReq.appending("Content-Type: \(mimetype)\r\n\r\n") as NSString
                        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                        body.append(data!)
                        strReq = strReq.appending("\r\n") as NSString
                        body.appendString("\r\n")
                        i+=1;
                    }
                    
                    
                }
            }
        }
        strReq = strReq.appending("--\(boundary)--\r\n") as NSString
        body.appendString("--\(boundary)--\r\n")
        //        NSLog("data %@",NSString(data: body, encoding: NSUTF8StringEncoding)!);
        print(strReq)
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
        
    }
    
    func mimeTypeForPath(path: String) -> String {
        let pathExtension = NSURL(string: path)?.pathExtension
        var stringMimeType = "application/octet-stream";
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as CFString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                stringMimeType = mimetype as NSString as String
            }
        }
        return stringMimeType;
    }
    func getParentViewController(subV : UIView) -> UIViewController? {
        var parentResponder: UIResponder? = subV
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
//    func callAPIWithParametersPostToUploadImage(image:UIImage,userName:String,apiUrl:NSString,token:NSString,studentId:NSString, completionBlock: @escaping (AnyObject?, NSError?) -> Void) ->Void {
//        //        let arrProfile = SingletonClass.sharedInstance().getProfileArr() as? [AnyHashable: Any]
//        //        var _params = [AnyHashable: Any]()
//        //        _params["upload"] = "upload"
//        //        _params["filetype"] = "png"
//        //        _params["oldprofileimage"] = arrProfile?["image"]
//        //[_params setObject:[NSString stringWithFormat:@"%@",title] forKey:[NSString stringWithString:@"title"]];
//        // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
//        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
//        // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
//        let FileParamConstant = "file"
//        // the server url to which the image (or the media) is uploaded. Use your server url here
//        let requestURL = URL(string: "\(baseURL)\(apiUrl)\(userName)\(token)\(studentId)")
//        // https://38a25644.ngrok.io/#/admin/login
//        // create request
//        var request = NSMutableURLRequest()
//        request.cachePolicy = .reloadIgnoringLocalCacheData
//        request.httpShouldHandleCookies = false
//        request.timeoutInterval = 30
//        request.httpMethod = "POST"
//        // set Content-Type in HTTP header
//        let contentType = "multipart/form-data; boundary=\(BoundaryConstant)"
//        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
//        // post body
//        var body = Data()
//        // add params (all params are strings)
//        //    for (NSString *param in _params) {
//        //        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
//        //        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
//        //        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
//        //    }
//        // add image data
//        let imageData = UIImageJPEGRepresentation(image, 1.0)
//        if imageData != nil {
//            body.append("--\(BoundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(FileParamConstant)\"; filename=\"image.jpg\"\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
//            // [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//            body.append(imageData!)
//            body.append("\r\n".data(using: String.Encoding.utf8)!)
//        }
//        body.append("--\(BoundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
//        // setting the body of the post to the reqeust
//        request.httpBody = body
//        // set the content-length
//        let postLength = "\(UInt(body.count))"
//        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
//        // set URL
//        request.url = requestURL
//        let newRequest = request as URLRequest
//        //  let task = URLSession.shared.dataTask(with: newRequest) { (data, response, error) in
//        //
//        //  }
//        //      let config = URLSessionConfiguration.default
//        //      let session = URLSession()
//        
//        let task = URLSession.shared.dataTask(with: newRequest, completionHandler: {
//            (data, response, error) in
//            
//            //    hideAllHuds(true)
//            
//            if error != nil {
//                
//                print("\n\n error  >>>>>>\n\(error)")
//                DispatchQueue.main.async(execute: {
//                    completionBlock(nil,error as NSError?)
//                })
//                
//            } else {
//                
//                let httpResponse = response as! HTTPURLResponse
//                let responseCode = httpResponse.statusCode
//                
//                //let responseHeaderDict = httpResponse.allHeaderFields as NSDictionary
//                //logInfo("\n\n Response Header >>>>>> \n\(responseHeaderDict)")
//                
//                let responseString = NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue)
//                print("\n\n Response Code >>>>>> \n\(responseCode) \nResponse String>>>> \n \(responseString)")
//                
//                do {
//                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
//                    
//                    //>>>> Check if authentication error
//                    
//                    if let dataDict = result as? Dictionary<String, AnyObject> {
//                        let allKeysArray = dataDict.keys
//                        if allKeysArray.contains(pStatusCodeError) {
//                            
//                            if let errorDict = result as? Dictionary<String, AnyObject> {
//                                let statusCode = (errorDict[pStatusCodeError] as! NSString).integerValue
//                                if (statusCode == 401) {
//                                    // go to login screen
//                                    //  kAppDelegate.logOut()
//                                    
//                                    //                                    DispatchQueue.main.async(execute: {
//                                    //                                       //  let _ = AlertViewController.alert("Authentication Error!", message: "Please login and try again.")
//                                    //
//                                    //                                    })
//                                    DispatchQueue.main.async(execute: {
//                                        completionBlock(result as AnyObject?,nil)
//                                    })
//                                    
//                                } else {
//                                    DispatchQueue.main.async(execute: {
//                                        completionBlock(result as AnyObject?,nil)
//                                    })
//                                }
//                            } else {
//                                DispatchQueue.main.async(execute: {
//                                    completionBlock(result as AnyObject?,nil)
//                                })
//                            }
//                            
//                        } else {
//                            DispatchQueue.main.async(execute: {
//                                completionBlock(result as AnyObject?,nil)
//                            })
//                        }
//                    } else {
//                        DispatchQueue.main.async(execute: {
//                            completionBlock(result as AnyObject?,nil)
//                        })
//                    }
//                } catch {
//                    
//                    print("\n\n error in JSONSerialization")
//                    print("\n\n error  >>>>>>\n\(error)")
//                    
//                    if responseCode == 200 {
//                        let result = ["responseCode":"200"]
//                        DispatchQueue.main.async(execute: {
//                            completionBlock(result as AnyObject?,nil)
//                        })
//                    }
//                    
//                }
//            }
//            
//        })
//        task.resume()
//    }

    func getRequestWithId(appendParam: String,presentingView : UIView,showLoader : Bool, onSuccess: @escaping(AnyObject) -> Void, onFailure: @escaping(Error) -> Void){

        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
        }
        else{
            if (self.getParentViewController(subV: presentingView) != nil) {

                let vc = self.getParentViewController(subV: presentingView)

                ObjRef.sharedInstance.showAlertController(msg: "Please check your internet connection", superVC: vc!)
            }

            let cacheKey = appendParam
            if (cacheSelectBook?.containsObject(forKey: cacheKey))!{
                let resp = cacheSelectBook?.object(forKey: cacheKey) as! String
                //                var bookinf = self.responseToBook(responseString: resp as String)
                //                self.textView.text = bookinf.bookTitle
                let data = resp.data(using: String.Encoding.utf8, allowLossyConversion: true)
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: (data! as NSData) as Data, options: .allowFragments) // SwiftyJSON
                    
                    print(jsonObject) // Test if it works
                    onSuccess(jsonObject as AnyObject)
                }
                catch {
                    
                }
            }
            
            print("disConnected")
            return
        }
        let vc = self.getParentViewController(subV: presentingView)
        var homeVC = HomeViewController()


        if showLoader == true {
            if let vcHome = vc?.parent?.parent?.parent as? HomeViewController {
                homeVC = vcHome
                vcHome.view.isUserInteractionEnabled = false
            }
            if let vcHome = vc?.parent?.parent as? HomeViewController {
                homeVC = vcHome
                vcHome.view.isUserInteractionEnabled = false
            }
            if let vcHome = vc?.parent as? HomeViewController {
                homeVC = vcHome
                vcHome.view.isUserInteractionEnabled = false
            }

            MBProgressHUD.showAdded(to: presentingView, animated: true)
        }


        //let url : String = baseURL + APIManager.getPostsEndpoint + String(postId)7
        let url : String = baseURL + appendParam
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.timeoutInterval = 60
        request.httpMethod = "GET"

        let session = URLSession.shared

       // DispatchQueue.global(qos: .background).async {

            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                if(error != nil){
                    if (self.getParentViewController(subV: presentingView) != nil) {

                        let vc = self.getParentViewController(subV: presentingView)

                        ObjRef.sharedInstance.showAlertController(msg: (error?.localizedDescription)!, superVC: vc!)
                    }
                    if showLoader == true {

                        DispatchQueue.main.async(execute: { () -> Void in
                            MBProgressHUD.hide(for: presentingView, animated: true)
                            homeVC.view.isUserInteractionEnabled = true

                        })
                    }

                    onFailure(error!)
                } else{
                    do {
                        //let result = try JSON(data: data!)
                        if showLoader == true {

                            DispatchQueue.main.async(execute: { () -> Void in
                                MBProgressHUD.hide(for: presentingView, animated: true)
                                homeVC.view.isUserInteractionEnabled = true

                            })
                        }
                        do {
                            if data != nil {
                                
                                let strResponse:NSString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                                
                                self.cacheSelectBook?.setObject(strResponse, forKey: appendParam)
                                
                            }
                            let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                            // use jsonObject here
                            onSuccess(jsonObject as AnyObject)

                            
                            
                        } catch {
                            print("json error: \(error)")
                            if (self.getParentViewController(subV: presentingView) != nil) {

                                let vc = self.getParentViewController(subV: presentingView)

                                ObjRef.sharedInstance.showAlertController(msg: (error.localizedDescription), superVC: vc!)
                            }

                            onFailure(error)

                        }
                    }
                    catch {
                        if showLoader == true {

                            DispatchQueue.main.async(execute: { () -> Void in
                                MBProgressHUD.hide(for: presentingView, animated: true)
                                homeVC.view.isUserInteractionEnabled = true

                            })
                        }
                        if (self.getParentViewController(subV: presentingView) != nil) {

                            let vc = self.getParentViewController(subV: presentingView)

                            ObjRef.sharedInstance.showAlertController(msg: (error.localizedDescription), superVC: vc!)
                        }

                        onFailure(error)
                    }
                }
            })
            task.resume()

       // }
    }
    func getRequestWithIdForPdf(appendParam: String,presentingView : UIView,showLoader : Bool, onSuccess: @escaping(AnyObject) -> Void, onFailure: @escaping(Error) -> Void){

        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
        }
        else{
            if (self.getParentViewController(subV: presentingView) != nil) {

                let vc = self.getParentViewController(subV: presentingView)

                ObjRef.sharedInstance.showAlertController(msg: "Please check your internet connection", superVC: vc!)
            }

            print("disConnected")
            return
        }
        let vc = self.getParentViewController(subV: presentingView)
        var homeVC = HomeViewController()


        if showLoader == true {
            if let vcHome = vc?.parent?.parent?.parent as? HomeViewController {
                homeVC = vcHome
                vcHome.view.isUserInteractionEnabled = false
            }
            if let vcHome = vc?.parent?.parent as? HomeViewController {
                homeVC = vcHome
                vcHome.view.isUserInteractionEnabled = false
            }
            if let vcHome = vc?.parent as? HomeViewController {
                homeVC = vcHome
                vcHome.view.isUserInteractionEnabled = false
            }

            MBProgressHUD.showAdded(to: presentingView, animated: true)
        }


        //let url : String = baseURL + APIManager.getPostsEndpoint + String(postId)7
        let url : String = baseURL + appendParam
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        //request.timeoutInterval = 120
        request.httpMethod = "GET"

        let session = URLSession.shared

        // DispatchQueue.global(qos: .background).async {

        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                if (self.getParentViewController(subV: presentingView) != nil) {

                    let vc = self.getParentViewController(subV: presentingView)

                    ObjRef.sharedInstance.showAlertController(msg: (error?.localizedDescription)!, superVC: vc!)
                }
                if showLoader == true {

                    DispatchQueue.main.async(execute: { () -> Void in
                        MBProgressHUD.hide(for: presentingView, animated: true)
                        homeVC.view.isUserInteractionEnabled = true

                    })
                }

                onFailure(error!)
            } else{

                    //let result = try JSON(data: data!)
                    if showLoader == true {

                        DispatchQueue.main.async(execute: { () -> Void in
                            MBProgressHUD.hide(for: presentingView, animated: true)
                            homeVC.view.isUserInteractionEnabled = true

                        })
                    }
                       // let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        // use jsonObject here
                        onSuccess(data as AnyObject)


            }
        })
        task.resume()

        // }
}
//    func getRequestWithId(appendParam: String,presentingView : UIView,showLoader : Bool, onSuccess: @escaping(AnyObject) -> Void, onFailure: @escaping(Error) -> Void){
//
//        if ConnectionCheck.isConnectedToNetwork() {
//            print("Connected")
//        }
//        else{
//            if (self.getParentViewController(subV: presentingView) != nil) {
//
//                let vc = self.getParentViewController(subV: presentingView)
//
//                ObjRef.sharedInstance.showAlertController(msg: "Please check your internet connection", superVC: vc!)
//            }
//
//            let cacheKey = appendParam
//            if (cacheSelectBook?.containsObject(forKey: cacheKey))!{
//                let resp = cacheSelectBook?.object(forKey: cacheKey) as! String
//                //                var bookinf = self.responseToBook(responseString: resp as String)
//                //                self.textView.text = bookinf.bookTitle
//                let data = resp.data(using: String.Encoding.utf8, allowLossyConversion: true)
//
//                do {
//                    let jsonObject = try JSONSerialization.jsonObject(with: (data! as NSData) as Data, options: .allowFragments) // SwiftyJSON
//
//                    print(jsonObject) // Test if it works
//                    onSuccess(jsonObject as AnyObject)
//                }
//                catch {
//
//                }
//            }
//
//            print("disConnected")
//             return
//        }
//        let vc = self.getParentViewController(subV: presentingView)
//        var homeVC = HomeViewController()
//
//
//        if showLoader == true {
//            if let vcHome = vc?.parent?.parent?.parent as? HomeViewController {
//                homeVC = vcHome
//                vcHome.view.isUserInteractionEnabled = false
//            }
//            else if let vcHome = vc?.parent?.parent as? HomeViewController {
//                homeVC = vcHome
//                vcHome.view.isUserInteractionEnabled = false
//            }
//            else if let vcHome = vc?.parent as? HomeViewController {
//                homeVC = vcHome
//                vcHome.view.isUserInteractionEnabled = false
//            }
//
//            MBProgressHUD.showAdded(to: presentingView, animated: true)
//        }
//
//        let query_url : String = baseURL + appendParam
//
//
//        // escape your URL
//        let urlAddressEscaped = query_url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//
//
//        //Request with caching policy
//        var request = URLRequest(url: URL(string: urlAddressEscaped!)!)
//
//
//        Alamofire.request(request)
//            .responseJSON { (response) in
//
////                if ConnectionCheck.isConnectedToNetwork() {
////                    let cachedURLResponse = CachedURLResponse(response: response.response!, data: (response.data! as NSData) as Data, userInfo: nil, storagePolicy: .allowed)
////                    URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
////                }
//
//                if response.result.error == nil {
//                    if showLoader == true {
//                        DispatchQueue.main.async(execute: { () -> Void in
//                            MBProgressHUD.hide(for: presentingView, animated: true)
//                            homeVC.view.isUserInteractionEnabled = true
//
//                        })
//                    }
//                }
//                else {
//                    if (self.getParentViewController(subV: presentingView) != nil) {
//
//                        let vc = self.getParentViewController(subV: presentingView)
//
//                        ObjRef.sharedInstance.showAlertController(msg: (response.result.error!.localizedDescription), superVC: vc!)
//                    }
//                    if showLoader == true {
//                        DispatchQueue.main.async(execute: { () -> Void in
//                            MBProgressHUD.hide(for: presentingView, animated: true)
//                            homeVC.view.isUserInteractionEnabled = true
//
//                        })
//                    }
//                    // got an error in getting the data, need to handle it
//                    print("error fetching data from url")
//                    print(response.result.error!)
//                    onFailure(response.result.error!)
//
//                    return
//
//                }
//                do {
//
//
//
//                    let jsonObject = try JSONSerialization.jsonObject(with: (response.data! as NSData) as Data, options: .allowFragments) // SwiftyJSON
//
//                    print(jsonObject) // Test if it works
//                    onSuccess(jsonObject as AnyObject)
//
//                    if response.data != nil {
//
//                        let strResponse:NSString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!
//
//                        self.cacheSelectBook?.setObject(strResponse, forKey: appendParam)
//
//                    }
//                }
//                catch {
//                    print(error) // Test if it works
//                }
//
//                // do whatever you want with your data here
//
//        }
//    }
    
    //func getRequestWithIdForPdf(appendParam: String,presentingView : UIView,showLoader : Bool, onSuccess: @escaping(AnyObject) -> Void, onFailure: @escaping(Error) -> Void)
//    {
//
//        if ConnectionCheck.isConnectedToNetwork() {
//            print("Connected")
//        }
//        else{
//            if (self.getParentViewController(subV: presentingView) != nil) {
//
//                let vc = self.getParentViewController(subV: presentingView)
//
//                ObjRef.sharedInstance.showAlertController(msg: "Please check your internet connection", superVC: vc!)
//            }
//
//            print("disConnected")
//            // return
//        }
//        let vc = self.getParentViewController(subV: presentingView)
//        var homeVC = HomeViewController()
//
//
//        if showLoader == true {
//            if let vcHome = vc?.parent?.parent?.parent as? HomeViewController {
//                homeVC = vcHome
//                vcHome.view.isUserInteractionEnabled = false
//            }
//            if let vcHome = vc?.parent?.parent as? HomeViewController {
//                homeVC = vcHome
//                vcHome.view.isUserInteractionEnabled = false
//            }
//            if let vcHome = vc?.parent as? HomeViewController {
//                homeVC = vcHome
//                vcHome.view.isUserInteractionEnabled = false
//            }
//
//            MBProgressHUD.showAdded(to: presentingView, animated: true)
//        }
//
//        let query_url : String = baseURL + appendParam
//
//
//        // escape your URL
//        let urlAddressEscaped = query_url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//
//
//        //Request with caching policy
//        let request = URLRequest(url: URL(string: urlAddressEscaped!)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20)
//
//        Alamofire.request(request)
//            .responseJSON { (response) in
//                let cachedURLResponse = CachedURLResponse(response: response.response!, data: (response.data! as NSData) as Data, userInfo: nil, storagePolicy: .allowed)
//                URLCache.shared.storeCachedResponse(cachedURLResponse, for: response.request!)
//
//                if response.result.error == nil {
//                    if showLoader == true {
//
//                        DispatchQueue.main.async(execute: { () -> Void in
//                            MBProgressHUD.hide(for: presentingView, animated: true)
//                            homeVC.view.isUserInteractionEnabled = true
//
//                        })
//                    }
//                }
//                else {
//                    if (self.getParentViewController(subV: presentingView) != nil) {
//
//                        let vc = self.getParentViewController(subV: presentingView)
//
//                        ObjRef.sharedInstance.showAlertController(msg: (response.result.error!.localizedDescription), superVC: vc!)
//                    }
//                    DispatchQueue.main.async(execute: { () -> Void in
//                        MBProgressHUD.hide(for: presentingView, animated: true)
//                        homeVC.view.isUserInteractionEnabled = true
//
//                    })
//                    // got an error in getting the data, need to handle it
//                    print("error fetching data from url")
//                    print(response.result.error!)
//                    onFailure(response.result.error!)
//
//                    return
//
//                }
//                do {
//
//                    let jsonObject = try JSONSerialization.jsonObject(with: cachedURLResponse.data, options: .allowFragments) // SwiftyJSON
//
//                    print(jsonObject) // Test if it works
//                    onSuccess(jsonObject as AnyObject)
//
//                }
//                catch {
//                    print(error) // Test if it works
//                }
//
//                // do whatever you want with your data here
//
//        }
//    }
}





    
    /*
     
     let url: NSURL = NSURL(string: APIBaseURL + "&login=1951&pass=1234")!
     var params = ["login":"1951", "pass":"1234"]
     request = NSMutableURLRequest(URL:url)
     request.HTTPMethod = "POST"
     var err: NSError?
     request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
     request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     request.addValue("application/json", forHTTPHeaderField: "Accept")
     
     */
    
    /*
     
     let headers = [
     "content-type": "application/json",
     "cache-control": "no-cache",
     "postman-token": "66df587c-262f-27a6-79fc-94b4b6dc7537"
     ]
     let parameters = [
     "username": "antony2@a.com",
     "password": "12345"
     ] as [String : Any]
     
     let postData = JSONSerialization.data(withJSONObject: parameters, options: [])
     
     let request = NSMutableURLRequest(url: NSURL(string: "https://www.fibodo.com/testing/api/v2.5/login")! as URL,
     cachePolicy: .useProtocolCachePolicy,
     timeoutInterval: 10.0)
     request.httpMethod = "POST"
     request.allHTTPHeaderFields = headers
     request.httpBody = postData as Data
     
     let session = URLSession.shared
     let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
     if (error != nil) {
     print(error)
     } else {
     let httpResponse = response as? HTTPURLResponse
     print(httpResponse)
     }
     })
     
     dataTask.resume()
     
     */


