//
//  WebRequests.swift
//  Eshtrakat
//
//  Created by ramez adnan on 04/02/2019.
//  Copyright © 2019 ramez adnan. All rights reserved.
//


import Foundation
import Alamofire
import SKActivityIndicatorView

struct StatusStruct : Codable{
    let status: Bool?
    let code: Int?
    let message: String?
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}

enum DataType: String {
    case json
    case serialize
}
class WebRequests: NSObject {
    private static var controller: UIViewController?
    private static var headers = [String : String]()
    var parameters = [String : Any]()
    var ReqMethod: HTTPMethod = HTTPMethod.get
    private var isAuth: Bool = false
    var UrlString: String?
    
    
    
    override init() {}
    static func setup(controller: UIViewController, headers : [String : String]? = [:]) -> WebRequests {
        print("\r\n---- START OF REQUEST HEADER ----")
        WebRequests.controller = controller
        if headers!.count > 0 {
            for (key, value) in headers! {
                WebRequests.headers[key] = value
                print("\(key)=\(value)\r\n")
                
            }
        }
     //   print("Accept-Language=\(Language.currentLanguage())\r\n")
        WebRequests.headers["Accept-Language"] = MyTools.tools.getMyLang()
        WebRequests.headers["Accept"] = "application/json"
        WebRequests.headers["Authorization"] = "Bearer "+MyTools.tools.getMyToken()
        return WebRequests.init()
    }
    
    
    func post(query: String, isAuthRequired: Bool = true) -> WebRequests {
        return prepare(query: query, method: HTTPMethod.post, parameters: [:], isAuthRequired: isAuthRequired)
    }
    
    func get(query: String, isAuthRequired: Bool = true) -> WebRequests {
        return prepare(query: query, method: HTTPMethod.get, parameters: [:], isAuthRequired: isAuthRequired)
    }
    func prepare(query: String, method: HTTPMethod, parameters: [String: Any]? = nil, dataType: DataType = .serialize, isAuthRequired: Bool = true) -> WebRequests {
        print("\r\n\r\n---- START OF REQUEST URL ----")
        UrlString =  TAConstant.main + query
        print(UrlString as Any)
        
        ReqMethod = method
        if isAuthRequired {
            self.isAuth = true
        }
        if parameters != nil {
            self.generateParametersForHttpBody(parameters: parameters!, dataType: dataType)
        }
        return self
        
    }
    private func generateParametersForHttpBody(parameters: [String: Any]?, dataType: DataType = .serialize) {
        print("\r\n---- START OF REQUEST PARAMETERS ----")
        
        for (key, value) in parameters! {
            //            postString += "\(key)=\(value)&"
            self.parameters[key] = value
            print("\(key)=\(value)\r\n")
            
        }
    }
    func start(completion: @escaping ((DataResponse<Any>,Error?)->Void)) -> WebRequests? {
        var headers: HTTPHeaders!
        headers = WebRequests.headers
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.statusTextColor(UIColor.black)
        SKActivityIndicator.spinnerStyle(.defaultSpinner)
        SKActivityIndicator.show("", userInteractionStatus: false)

        if ReqMethod == HTTPMethod.post{
            //URLEncoding.default
            Alamofire.request(self.UrlString!, method: .post, parameters: self.parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                SKActivityIndicator.dismiss()
                if(response.result.isSuccess){
                    completion(response,nil)
                    do {
                        let Status =  try JSONDecoder().decode(StatusStruct.self, from: response.data!)
                        if Status.status! == false {
                            WebRequests.controller?.alert(message: Status.message!)
                        }
                    } catch let jsonErr {
                        print("Error serializing  respone json", jsonErr)
                    }
                    
                    print("Success : \r\n----\(response) ----")
                    
                }else{
                    completion(response,response.result.error)
                    print("Error : \r\n----\(response) ----")
                    
                }
            }
        }else{
            //URLEncoding.default
            Alamofire.request(self.UrlString!, method: .get, parameters: self.parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                WebRequests.controller?.hideIndicator()
                if(response.result.isSuccess){
                    completion(response,nil)
                    do {
                        let Status =  try JSONDecoder().decode(StatusStruct.self, from: response.data!)
                        if Status.status! == false {
                            WebRequests.controller?.alert(message: Status.message!)
                        }
                    } catch let jsonErr {
                        print("Error serializing  respone json", jsonErr)
                    }
                    
                    print("Success : \r\n----\(response) ----")
                    
                }else{
                    completion(response,response.result.error)
                    print("Error : \r\n----\(response) ----")
                    
                }
            }
        }
        return self
}

//
//    static func sendPostMultipartWithImages(url: String, parameters: [String:String], imgs: [UIImage], withName: String,img:UIImage,logoName:String, completion: @escaping ((Any,Error?)->Void)){
//
//        var imagesData: [Data] = []
//
//        for i in imgs{
//            let imageData = i.jpegData(compressionQuality: 0.5)
//            imagesData.append(imageData!)
//        }
//
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            var indx: Int = 0
//            for imageData in imagesData {
//                multipartFormData.append(imageData, withName: "\(withName)[\(indx)]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
//                indx += 1
//            }
//
//            for (key, value) in parameters {
//                multipartFormData.append(value.data(using: .utf8)!, withName: key)
//            }
//            let imageLogo = img.jpegData(compressionQuality: 0.4)
//
//            multipartFormData.append(imageLogo!, withName: logoName, fileName: "image_\(Date().toMillis() ?? 0).jpeg", mimeType: "image/jpeg")
//
//        }, to: url,method: .post,
//           headers: ["Authorization": "Bearer " + MyTools.tools.getMyToken(), "Accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"])
//        //    ,"Accept-Language": Language.currentLanguage()])
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.uploadProgress(closure: { (Progress) in
//                    print("Upload Progress: \(Progress.fractionCompleted)")
//                })
//
//                upload.responseJSON { response in
//                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
//                        completion(JSON, nil)
//                    }else{
//                        completion("", response.error)
//                        print(response.error?.localizedDescription ?? "" )
//                    }
//                }
//
//            case .failure(let encodingError):
//                completion(NSNull(), encodingError)
//                print(encodingError)
//            }
//        }
//    }
//
//
//

}


