//
//  MyApi.swift
//  مجالس
//
//  Created by ibra on 10/12/16.
//  Copyright © 2016 ibra. All rights reserved.
//

import Foundation
import Alamofire

class MyApi
{
    static let api = MyApi()
    
    static public var apiMainURL = "http://scalenmore.com/api/" as String
    static public var PhotoURL = "http://scalenmore.com/" as String

    func PostEditUser(name:String,email:String ,mobile:String,image:Data,
                      civil_id:String,images:[UIImage],is_24:String,video:Data , company_name:String,category_id:[Int], completion:((DataResponse<Any>,Error?)->Void)!) {
        
        
        
        
        let headers: HTTPHeaders =
            [
                "Accept": "application/json",
                "Accept-Language" :  MyTools.tools.getMyLang(),
                "Authorization" :  "Bearer "+MyTools.tools.getMyToken(),
            ]
        
        Alamofire.upload(
            multipartFormData:
            {
                multipartFormData in
                
                multipartFormData.append(image, withName: "profile_image",fileName: "img.png", mimeType: "image/png")
                
                multipartFormData.append(name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "name")
                
                multipartFormData.append(mobile.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "mobile")
                
                
                multipartFormData.append(email.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "email")
                
                multipartFormData.append("2".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "device_type")
                
//                multipartFormData.append(FCM_token.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "token")
                
                
                
                if(MyTools.tools.getUserType() == "contractor" || MyTools.tools.getUserType()  == "handyman")
                {
//                    var myData = category_id.withUnsafeBufferPointer {Data(buffer: $0)}
//                    multipartFormData.append(myData, withName: "category_id")
                
                    multipartFormData.append("\(category_id)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "category_id")

                    
                    for index in 0..<images.count
                    {
                        let image = UIImageJPEGRepresentation(images[index], 0.8) as? Data
                        let name = "images["+String(index)+"]"
                        multipartFormData.append(image!, withName: name,fileName: "img.png", mimeType: "image/png")
                    }
                    
    multipartFormData.append(video, withName: "video",fileName: "video.mp4", mimeType: "video/mp4")
                    
                }
                
                if(MyTools.tools.getUserType() == "contractor")
                {
                    multipartFormData.append(company_name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "company_name")
                    multipartFormData.append(civil_id.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "civil_id")
                }
                
                if(MyTools.tools.getUserType() == "handyman")
                {
                    multipartFormData.append(is_24.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "is_24")
                }
        },
            to: String(format:"%@%@",MyApi.apiMainURL,"user/update"),
            headers:headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if(response.result.isSuccess)
                        {
                            completion(response,nil)
                        }
                        else
                        {
                            completion(response,response.result.error)
                        }
                    }
                case .failure(_): break
                }
        })
    }
    
    
    
    func PostUpdateUser(name:String,email:String ,mobile:String ,is_24:String , company_name:String,category_id:[Int] , profile_image:Data ,images:[Data],token:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken(),
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.upload(
            multipartFormData:
            {
                multipartFormData in
                
                var myData = category_id.withUnsafeBufferPointer {Data(buffer: $0)}
                
                multipartFormData.append(token.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "token")
                
                multipartFormData.append(profile_image, withName: "profile_image",fileName: "img.png", mimeType: "image/png")
                
                multipartFormData.append(name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "name")
                
                multipartFormData.append(email.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "email")
                
                multipartFormData.append(mobile.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "mobile")
                
                multipartFormData.append(company_name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "company_name")
                
                multipartFormData.append(myData, withName: "category_id")
                
                multipartFormData.append(images[0], withName: "images[0]",fileName: "img.png", mimeType: "image/png")
                
                multipartFormData.append(is_24.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "is_24")
                
                multipartFormData.append("\(2)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "device_type")
                
                
        },
            to: String(format:"%@%@",MyApi.apiMainURL,"user/update"),
            headers:headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if(response.result.isSuccess)
                        {
                            completion(response,nil)
                        }
                        else
                        {
                            completion(response,response.result.error)
                        }
                    }
                case .failure(_): break
                }
        })
    }
    
    func PostNewUser(email:String,name:String,mobile:String,password:String,confirm_password:String,gender:Int,country_id:Int,date_of_birth:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"signUp"), method: .post, parameters:["email":email , "name":name, "mobile":mobile,"password":password,"confirm_password":confirm_password, "gender":gender,"country_id":country_id,"date_of_birth":date_of_birth],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func Postlogout(token:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken(),
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/logout"), method: .post, parameters:["token":token , "device_type":2],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func LoginGoogle(token:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" : MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"google_login"), method: .post,
                          parameters:["token":token,"type":"ios"],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    
    func LoginFB(token:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"facebook_login"), method: .post,
                          parameters:["token":token],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    
    func PostLoginUser(email:String ,password:String  ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"login"), method: .post,
                          parameters:["email":email , "password":password],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }

    
    //
    func checkCoupon(coupon_code:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders =
            [
                "Accept": "application/json",
                "Accept-Language" :  MyTools.tools.getMyLang(),
                "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"checkCoupon"), method: .post,
                          parameters:["coupon_code":coupon_code],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    func postAppointment(type:Int,date:String,time:String , coupon_code:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders =
            [
                "Accept": "application/json",
                "Accept-Language" :  MyTools.tools.getMyLang(),
                "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"appointments"), method: .post,
                          parameters:["type":type, "date":date , "time":time, "coupon_code":coupon_code ],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    
    func addPlanMeals(package_id:Int,weight:Int ,height:Int,health_conditions:String , notes:String , allergies:String,coupon_code:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders =
            [
                "Accept": "application/json",
                "Accept-Language" :  MyTools.tools.getMyLang(),
                "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"addPlanMeals"), method: .post,
                          parameters:["package_id":package_id, "weight":weight, "height":height, "health_conditions":health_conditions,"notes":notes ,"allergies":allergies ,  "coupon_code":coupon_code ],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    func postPurshase(package_id:Int,coupon_code:String ,payment:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders =
            [
                "Accept": "application/json",
                "Accept-Language" :  MyTools.tools.getMyLang(),
                "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"purchasePackages"), method: .post,
                          parameters:["package_id":package_id, "coupon_code":coupon_code, "payment":payment ],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    
    
    func PostAddPlan(plan_name:String , day_name:String , day_id:Int,note:String,vedio_id:Int,number:Int,frequent:Int , plan_id:Int , planday_id:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders =
            [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
            ]
    
        var parms:[String:Any] = [:]
            parms = ["plan_name":plan_name, "day_name":day_name, "day_id":day_id,"note":note ,"vedio_id":vedio_id ,"number":number ,"frequent": frequent ,"plan_id":plan_id , "planday_id":planday_id]

        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"addPlan"), method: .post,
                          parameters:parms,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    //
    
    
    func PostFcmToken(token:String ,type:String  ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()

        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"fcm_token"), method: .post,
                          parameters:["token":token , "type":"ios"],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }

    
    func postAcceptorRejectByHandyMan(job_id:Int,offer_id:Int ,status:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken(),
            
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"offer/WorkerResponse"), method: .post,
                          parameters:["job_id":job_id , "offer_id":offer_id , "status":status],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    //offer/CustomerResponse
    func postAcceptorRejectBbCustomer(job_id:Int,offer_id:Int ,status:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken(),
            
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"offer/CustomerResponse"), method: .post,
                          parameters:["job_id":job_id , "offer_id":offer_id , "status":status],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    
    func PostRate(provider_id:Int ,rate:Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken(),
            
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"offer/rate"), method: .post,
                          parameters:["provider_id":provider_id , "rate":rate],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    

    func PostPayment(amount:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken(),
            
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/payment"), method: .post,
                          parameters:["amount":amount],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    func PostMakeOffer(job_id:Int ,budget:Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken(),
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"offer"), method: .post,
                          parameters:["job_id":job_id , "budget":budget],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    
    
    func PostChangePassword(old_password:String , password:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken(),
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"changePassword"), method: .post,
                          parameters:["old_password":old_password , "password":password],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
                            if(response.result.isSuccess)
                            {
                                completion(response,nil)
                            }
                            else
                            {
                                completion(response,response.result.error)
                            }
        }
    }
    
    func PostForgetPassword(email:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" : MyTools.tools.getMyLang()
        ]
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"forgetpassword"), method: .post,parameters:["email":email],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostCheckCode(code:String,mobile:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/checkCode"), method: .post,parameters:["code":code , "mobile":mobile],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostRequestNewCode(code:String , mobile:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/requestNewCode"), method: .post,parameters:["code":code , "mobile":mobile],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostupdatePassword(password:String ,password_confirmation:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken(),
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/password"), method: .post,parameters:["password":password , "password_confirmation":password_confirmation],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostCahngePassword(password:String ,password_confirmation:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" : "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/password"), method: .post,parameters:["password_confirmation":password_confirmation , "password":password],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func PostSendToken(token:String ,type:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/token"), method: .post,parameters:["type":type , "token":token],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostContact(fullname:String ,email:String , comment:String, mobile:String , type:Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"contact2"), method: .post,parameters:["fullname":fullname , "email":email , "type":type , "comment":comment , "mobile":mobile],encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    
    func DeleteImage(ID:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/deleteImage/"+ID), method: .post,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func postEditPlanVideo(plan_id:Int,plan_day_id:Int,vedio_id:Int,number:Int,frequent:Int,planVideo_id:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"editPlanVideo"), method: .post, parameters:["plan_id":plan_id , "plan_day_id":plan_day_id,"vedio_id":vedio_id,"number":number,"frequent":frequent, "planVideo_id":planVideo_id],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func postEditPlanDay(plan_id:Int,day_name:String,day_id:Int,note:String,planDay_id:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"editPlanDay"), method: .post, parameters:["plan_id":plan_id , "day_name":day_name,"day_id":day_id,"note":note,"planDay_id":planDay_id],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func postEditPlan(plan_id:Int,name:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"editPlan"), method: .post, parameters:["plan_id":plan_id , "name":name],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func DeletePlanVideo(ID:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"deletePlanVedio/"+String(ID)), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
  //  getAvailableTime
    func getAvailableTime(type:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getAvailableTime?type="+String(type)), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }

    func GetPlanDays(plan_id:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getPlanDays?plan_id="+String(plan_id)), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func DeleteDay(ID:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"deletePlanDay/"+String(ID)), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func DeletePlan(PlanID:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Accept-Language" : MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"deletePlan/"+String(PlanID)), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
//    func GetSearchVideos(submuscale_id:Int,completion:((DataResponse<Any>,Error?)->Void)!)
//    {
//        let headers: HTTPHeaders = [
//            "Accep": "application/json",
//            "Accept-Language" :  "en",
//            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
//        ]
//
//        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getVideo?video_id=&submuscale_id="+String(submuscale_id)), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
//            if(response.result.isSuccess)
//            {
//                completion(response,nil)
//            }
//            else
//            {
//                completion(response,response.result.error)
//            }
//        }
//    }
//
    func GetVideos(submuscale_id:Int,name:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
//            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getVideo?video_id=&submuscale_id="+String(submuscale_id)+"&name="+name), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetPans(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getPlan"), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    func GetAppointments(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getAppointments"), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    //
    func getInformationMeal(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getInformationMeal"), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func addRate(day_id:Int,rate:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"addRate"), method: .post, parameters:["day_id":day_id , "rate":rate],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func PauseDay(date:String,pause:String,plan_id:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"editPlanMeals"), method: .post, parameters:["date":date , "pause":pause,"plan_id":plan_id],encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func editPlanMeals(date:String,category_id:Int,meal_id:[Int],pause:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.upload(
            multipartFormData:
            {
                multipartFormData in
                
                multipartFormData.append(date.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "date")

                multipartFormData.append("\(category_id)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "category_id")

                
                multipartFormData.append("\(meal_id)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "meal_id")
                
                multipartFormData.append("\(pause)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "pause")
        },
            to: String(format:"%@%@",MyApi.apiMainURL,"editPlanMeals"),
            headers:headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if(response.result.isSuccess)
                        {
                            completion(response,nil)
                        }
                        else
                        {
                            completion(response,response.result.error)
                        }
                    }
                case .failure(_): break
                }
        })
    }
        
    
    func getPlanMeals(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getPlanMeals"), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func getCategoryMeals(date:String, completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getCategoryMeals?date="+date), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func getCategoryMeals2(date:String, completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getCategoryMeals2?date="+date), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    
    func GetPackages(ID:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getPackages?type="+String(ID)), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetProviderProfile(userId:String, completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accep": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/"+userId), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetDeduction(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/deduction"), method: .get,encoding: JSONEncoding.default ,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetNotificationList(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/notifications"), method: .get,encoding: JSONEncoding.default ,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetCharge(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"user/charge"), method: .get,encoding: JSONEncoding.default ,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetCategories(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"categories"), method: .get,encoding: JSONEncoding.default ,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetTerms(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
            ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"terms"), method: .get,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func Logout(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" : MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
            
        ]
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"logout"), method: .get,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }

    func GetProfile(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" : MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()

        ]
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"profile"), method: .get,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    func GetConfig(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" : MyTools.tools.getMyLang()
            
        ]
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getConfig"), method: .get,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetAbout(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
      
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"about"), method: .get,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetPrivacy(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"privacy"), method: .get,encoding: JSONEncoding.default,headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    func GetAds(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"ad"), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetJobs(page:String ,title:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"job?page="+page+"&title="+title), method: .get,encoding: JSONEncoding.default , headers:headers).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostNewJob(title_en:String,details_en:String ,address_en:String ,title_ar:String,details_ar:String ,address_ar:String, lat :Double , lan:Double,budget:Int , building_material:Int,category_id:Int , image:Data ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" :  MyTools.tools.getMyLang(),
            "Authorization" :  "Bearer "+MyTools.tools.getMyToken()
        ]
        
        Alamofire.upload(
            multipartFormData:
            {
                multipartFormData in
                multipartFormData.append(title_en.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "title_en")
                
                multipartFormData.append(details_en.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "details_en")
                
                multipartFormData.append(address_en.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "address_en")
                
                multipartFormData.append(title_ar.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "title_ar")
                
                multipartFormData.append(details_ar.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "details_ar")
                
                multipartFormData.append(address_ar.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "address_ar")
                
                multipartFormData.append("\(lat)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "lat")
                
                multipartFormData.append("\(lan)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "lan")
                
                multipartFormData.append("\(budget)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "budget")
                
                multipartFormData.append("\(category_id)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "category_id")
                
                multipartFormData.append("\(building_material)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "building_material")
                
                multipartFormData.append(image, withName: "image",fileName: "img.png", mimeType: "image/png")
                
        },
            to: String(format:"%@%@",MyApi.apiMainURL,"job"),
            headers:headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if(response.result.isSuccess)
                        {
                            completion(response,nil)
                        }
                        else
                        {
                            completion(response,response.result.error)
                        }
                    }
                case .failure(_): break
                }
        })
    }
}
