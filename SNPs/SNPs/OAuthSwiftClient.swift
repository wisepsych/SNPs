//
//  OAuthSwiftClient.swift
//  SNPs
//
//  Created by Sarah Anderson on 12/6/14.
//  Copyright (c) 2014 Sarah Anderson. All rights reserved.
//

import Foundation
import Accounts

var dataEncoding: NSStringEncoding = NSUTF8StringEncoding

class OAuthSwiftClient {
    
    struct OAuth {
        static let version = "1.0"
        static let signatureMethod = "HMAC-SHA1"
    }
    
    var credential: OAuthSwiftCredential
    
    init(consumerKey: String, consumerSecret: String) {
        println("14")
        self.credential = OAuthSwiftCredential(consumer_key: consumerKey, consumer_secret: consumerSecret)
    }
    
    init(consumerKey: String, consumerSecret: String, accessToken: String, accessTokenSecret: String) {
        println("15")
        self.credential = OAuthSwiftCredential(oauth_token: accessToken, oauth_token_secret: accessTokenSecret)
        self.credential.consumer_key = consumerKey
        self.credential.consumer_secret = consumerSecret
        
    }
    
    func get(urlString: String, parameters: Dictionary<String, AnyObject>, success: OAuthSwiftHTTPRequest.SuccessHandler?, failure: OAuthSwiftHTTPRequest.FailureHandler?) {
        println("16")
        
        let url = NSURL(string: urlString)
        
        let method = "GET"
        
        let request = OAuthSwiftHTTPRequest(URL: url!, method: method, parameters: parameters)
        request.headers = ["Authorization": OAuthSwiftClient.authorizationHeaderForMethod(method, url: url!, parameters: parameters, credential: self.credential)]
        
        println(request.headers)
        
        request.successHandler = success
        request.failureHandler = failure
        request.dataEncoding = dataEncoding
        
        request.start()
    }
    
    func post(urlString: String, parameters: Dictionary<String, AnyObject>, success: OAuthSwiftHTTPRequest.SuccessHandler?, failure: OAuthSwiftHTTPRequest.FailureHandler?) {
        println("17")
        let url = NSURL(string: urlString)
        
        let method = "POST"
        
        var localParameters = parameters
        
        let request = OAuthSwiftHTTPRequest(URL: url!, method: method, parameters: localParameters)
        
        request.headers = ["Authorization": OAuthSwiftClient.authorizationHeaderForMethod(method, url: url!, parameters: localParameters, credential: self.credential)]
        
        request.successHandler = success
        request.failureHandler = failure
        request.dataEncoding = dataEncoding
        
        request.encodeParameters = true
        
        request.start()
    }
    
    class func authorizationHeaderForMethod(method: String, url: NSURL, parameters: Dictionary<String, AnyObject>, credential: OAuthSwiftCredential) -> String {
        println("18")
        var authorizationParameters = Dictionary<String, AnyObject>()
 //       authorizationParameters["oauth_version"] = OAuth.version
 //       authorizationParameters["oauth_signature_method"] =  OAuth.signatureMethod
 //       authorizationParameters["oauth_consumer_key"] = credential.consumer_key
 //       authorizationParameters["oauth_timestamp"] = String(Int64(NSDate().timeIntervalSince1970))
 //       authorizationParameters["oauth_nonce"] = (NSUUID().UUIDString as NSString).substringToIndex(8)
        
        if (credential.oauth_token != ""){
            authorizationParameters["Bearer"] = credential.oauth_token
        } else {
            authorizationParameters["Bearer"] = credential.oauth_token
        }
        
        for (key, value: AnyObject) in parameters {
            if key.hasPrefix("oauth_") {
                authorizationParameters.updateValue(value, forKey: key)
            }
        }
        
        let combinedParameters = authorizationParameters.join(parameters)
        
        let finalParameters = combinedParameters
        
//        authorizationParameters["oauth_signature"] = self.oauthSignatureForMethod(method, url: url, parameters: finalParameters, credential: credential)
        
        var authorizationParameterComponents = authorizationParameters.urlEncodedQueryStringWithEncoding(dataEncoding).componentsSeparatedByString("&") as [String]
        authorizationParameterComponents.sort { $0 < $1 }
        
        var headerComponents = [String]()
        for component in authorizationParameterComponents {
            let subcomponent = component.componentsSeparatedByString("=") as [String]
            if subcomponent.count == 2 {
                headerComponents.append("\(subcomponent[0])  \(subcomponent[1])")
            }
        }
        
        return " " + ", ".join(headerComponents)
    }
    
    class func oauthSignatureForMethod(method: String, url: NSURL, parameters: Dictionary<String, AnyObject>, credential: OAuthSwiftCredential) -> String {
        println("19")
        var tokenSecret: NSString = ""
        tokenSecret = credential.oauth_token_secret.urlEncodedStringWithEncoding(dataEncoding)
        
        let encodedConsumerSecret = credential.consumer_secret.urlEncodedStringWithEncoding(dataEncoding)
        
        let signingKey = "\(encodedConsumerSecret)&\(tokenSecret)"
        let signingKeyData = signingKey.dataUsingEncoding(dataEncoding)
        
        var parameterComponents = parameters.urlEncodedQueryStringWithEncoding(dataEncoding).componentsSeparatedByString("&") as [String]
        parameterComponents.sort { $0 < $1 }
        
        let parameterString = "&".join(parameterComponents)
        let encodedParameterString = parameterString.urlEncodedStringWithEncoding(dataEncoding)
        
        let encodedURL = url.absoluteString!.urlEncodedStringWithEncoding(dataEncoding)
        
        let signatureBaseString = "\(method)&\(encodedURL)&\(encodedParameterString)"
        let signatureBaseStringData = signatureBaseString.dataUsingEncoding(dataEncoding)
        
        return HMACSHA1Signature.signatureForKey(signingKeyData, data: signatureBaseStringData).base64EncodedStringWithOptions(nil)
    }
}
