//
//  OAuthSwiftCredential.swift
//  SNPs
//
//  Created by Sarah Anderson on 12/6/14.
//  Copyright (c) 2014 Sarah Anderson. All rights reserved.
//



class OAuthSwiftCredential {
    
    var consumer_key: String = String()
    var consumer_secret: String = String()
    var oauth_token: String = String()
    var oauth_token_secret: String = String()
    var oauth_verifier: String = String()
    init(){
        
    }
    init(consumer_key: String, consumer_secret: String){
        println("20")
        self.consumer_key = consumer_key
        self.consumer_secret = consumer_secret
    }
    init(oauth_token: String, oauth_token_secret: String){
        println("21")
        self.oauth_token = oauth_token
        self.oauth_token_secret = oauth_token_secret
    }
}
