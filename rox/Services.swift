//
//  Services.swift
//  rox
//
//  Created by MR.CHEMALY on 10/17/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

struct ServiceName {
    
    static let userRegistration = "/users"
    static let login = "/login"
    static let changePassword = "/changePassword"
    static let editProfile = "/users"
    static let getPOS = "/pos"
    static let getGlobalVariables = "/getGlobalVariables"
    static let forgotPassword = "/forgotPassword"
    static let sendOrder = "/sendOrder"
    static let logout = "/logout"
    static let getNotifications = "/getNotifications"
    static let getHistory = "/getHistory"
    static let getHistoryDetailed = "/getHistoryDetailed"
    static let updateToken = "/updateToken"
    static let checkPendingOrders = "/checkPendingOrders"
    
}

enum ResponseStatus: Int {
    
    case SUCCESS = 1
    case FAILURE = 0
    case CONNECTION_TIMEOUT = -1
    
}

enum ResponseMessage: String {
    
    case SERVER_UNREACHABLE = "An error has occured. try again later."
    case CONNECTION_TIMEOUT = "Check your internet connection."
    
}

class ResponseData {
    
    var status: Int = ResponseStatus.SUCCESS.rawValue
    var message: String = String()
    var jsonArray: [NSDictionary]? = [NSDictionary]()
    var jsonObject: JSON? = JSON((Any).self)
    
}

class Services {
    
    private let BaseUrl = "http://rox.cyberchisel.com/Api"
    private var ACCESS_TOKEN: String {
        get {
            if let token = UserDefaults.standard.string(forKey: Keys.Access_Token.rawValue) {
                return token
            }
            
            return "UNAUTHORIZED"
        }
    }
    
    func login(user: User) -> ResponseData? {
        let parameters: Parameters = [
            "email": user.email!,
            "password": user.password!
        ]

        return makeHttpRequest(method: .post, serviceName: ServiceName.login, parameters: parameters)
    }
    
    func checkEmailConfirmation(id: String, email: String) -> ResponseData? {
        let parameters: Parameters = [
            "id": id,
            "email": email
        ]
        
        return makeHttpRequest(method: .post, serviceName: ServiceName.login, parameters: parameters)
    }
    
    func register(user: User) -> ResponseData? {
        let parameters: Parameters = [
            "firstName": user.firstName ?? "",
            "lastName": user.lastName ?? "",
            "phone": user.phone ?? "",
            "province": user.province ?? "",
            "city": user.city ?? "",
            "street": user.street ?? "",
            "building": user.building ?? "",
            "floor": user.floor ?? "",
            "email": user.email ?? "",
            "password": user.password ?? "",
            "latitude": user.latitude ?? "",
            "longitude": user.longitude ?? ""
        ]
        
        return makeHttpRequest(method: .post, serviceName: ServiceName.userRegistration, parameters: parameters)
    }
    
    func changePassword(oldPassword: String, newPassword: String) -> ResponseData? {
        let parameters: Parameters = [
            Keys.Access_Token.rawValue : ACCESS_TOKEN,
            "old_password": oldPassword,
            "new_password": newPassword
        ]
        
        return makeHttpRequest(method: .post, serviceName: ServiceName.changePassword, parameters: parameters)
    }
    
    func editProfile(user: User) -> ResponseData? {
        let parameters: Parameters = [
            Keys.Access_Token.rawValue : ACCESS_TOKEN,
            "firstName": user.firstName ?? "",
            "lastName": user.lastName ?? "",
            "phone": user.phone ?? "",
            "province": user.province ?? "",
            "city": user.city ?? "",
            "street": user.street ?? "",
            "building": user.building ?? "",
            "floor": user.floor ?? "",
            "latitude": user.latitude ?? "",
            "longitude": user.longitude ?? ""
        ]
        
        return makeHttpRequest(method: .post, serviceName: ServiceName.editProfile, parameters: parameters)
    }
    
    func getPOS() -> ResponseData? {
        let parameters: Parameters = [
            Keys.Access_Token.rawValue : ACCESS_TOKEN
        ]
        
        return makeHttpRequest(method: .get, serviceName: ServiceName.getPOS, parameters: parameters)
    }
    
    func getGlobalVariables() -> ResponseData? {
        return makeHttpRequest(method: .get, serviceName: ServiceName.getGlobalVariables)
    }
    
    func forgotPassword(email: String) -> ResponseData? {
        let parameters: Parameters = [
            "email": email
        ]
        
        return makeHttpRequest(method: .post, serviceName: ServiceName.changePassword, parameters: parameters)
    }
    
    func sendOrder(sendOrder: SendOrder) -> ResponseData? {
        sendOrder.access_token = ACCESS_TOKEN
        let parameters: Parameters = sendOrder.toDict()
        
        do {
            let jsonData: NSData = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)!
            print(jsonString)
        } catch  {
            
        }
        
        return makeHttpRequest(method: .post, serviceName: ServiceName.sendOrder, parameters: parameters, encoding: JSONEncoding.default)
    }
    
    func logout(userId: String) -> ResponseData? {
        let parameters: Parameters = [
            Keys.Access_Token.rawValue : ACCESS_TOKEN,
            "user_id": userId
        ]

        return makeHttpRequest(method: .post, serviceName: ServiceName.logout, parameters: parameters)
    }
    
    func getNotifications() -> ResponseData? {
        let parameters: Parameters = [
            Keys.Access_Token.rawValue : ACCESS_TOKEN
        ]
        
        return makeHttpRequest(method: .post, serviceName: ServiceName.getNotifications, parameters: parameters)
    }
    
    func getHistory() -> ResponseData? {
        let parameters: Parameters = [
            Keys.Access_Token.rawValue : ACCESS_TOKEN
        ]
        
        return makeHttpRequest(method: .post, serviceName: ServiceName.getHistoryDetailed, parameters: parameters)
    }
    
    func updateToken() -> ResponseData? {
        let parameters: Parameters = [
            Keys.Access_Token.rawValue : ACCESS_TOKEN,
            "firebase_token": DatabaseObjects.FIREBASE_TOKEN
        ]
        
        return makeHttpRequest(method: .post, serviceName: ServiceName.updateToken, parameters: parameters)
    }
    
    func checkPendingOrders() -> ResponseData? {
        
        let parameters: Parameters = [
            Keys.Access_Token.rawValue : ACCESS_TOKEN
        ]
        
        return makeHttpRequest(method: .post, serviceName: ServiceName.checkPendingOrders, parameters: parameters)
    }
    
    // MARK: /************* SERVER REQUEST *************/
    
    private func makeHttpRequest(method: HTTPMethod, serviceName: String, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> ResponseData {
        
        let response = Alamofire.request(BaseUrl + serviceName, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(options: .allowFragments)
        let responseData = ResponseData()
        responseData.status = ResponseStatus.FAILURE.rawValue
        responseData.message = ResponseMessage.SERVER_UNREACHABLE.rawValue
        if let token = response.response?.allHeaderFields[Keys.AccessToken.rawValue] as? String{
            UserDefaults.standard.set(token, forKey: Keys.Access_Token.rawValue)
        }
        if let jsonArray = response.result.value as? [NSDictionary] {
            let json = jsonArray.first
            if let status = json!["status"] as? Int {
                let boolStatus = status == 1 ? true : false
                switch boolStatus {
                case true:
                    responseData.status = ResponseStatus.SUCCESS.rawValue
                    break
                default:
                    responseData.status = ResponseStatus.FAILURE.rawValue
                    break
                }
            }
            if let message = json!["message"] as? String {
                responseData.message = message
            }
            if let message = json!["message"] as? Bool {
                responseData.message = String(message)
            }
            
            if let json = jsonArray.last {
                if json.count > 0 {
                    responseData.jsonArray = [json]
                }
            }
            
        } else if let json = response.result.value as? NSDictionary {
            if let status = json["status"] as? Int {
                let boolStatus = status == 1 ? true : false
                switch boolStatus {
                case true:
                    responseData.status = ResponseStatus.SUCCESS.rawValue
                    break
                default:
                    responseData.status = ResponseStatus.FAILURE.rawValue
                    break
                }
            }
            if let message = json["message"] as? String {
                responseData.message = message
            }
            if let message = json["message"] as? Bool {
                responseData.message = String(message)
            }
            
            if let json = json["data"] as? NSDictionary {
                if json.count > 0 {
                    responseData.jsonArray = [json]
                }
            }
            else if let jsonArray = json["data"] as? [NSDictionary] {
                responseData.jsonArray = jsonArray
            }
            
        } else if let jsonArray = response.result.value as? NSArray {
            if let jsonStatus = jsonArray.firstObject as? NSDictionary {
                if let status = jsonStatus["status"] as? Int {
                    responseData.status = status
                }
            }
            
            if let jsonData = jsonArray.lastObject as? NSArray {
                responseData.jsonArray = [NSDictionary]()
                for jsonObject in jsonData {
                    if let json = jsonObject as? NSDictionary {
                        if json.count > 0 {
                            responseData.jsonArray?.append(json)
                        }
                    }
                }
            }
        } else {
            responseData.status = ResponseStatus.FAILURE.rawValue
            responseData.message = ResponseMessage.SERVER_UNREACHABLE.rawValue
            responseData.jsonArray = nil
        }
        
        return responseData
        
    }
    
    let manager: SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return SessionManager(configuration: configuration)
        
    }()
    
    func getBaseUrl() -> String {
        return self.BaseUrl
    }
}
