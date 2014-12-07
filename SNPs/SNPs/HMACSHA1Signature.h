//
//  HMACSHA1Signature.h
//  SNPs
//
//  Created by Sarah Anderson on 12/6/14.
//  Copyright (c) 2014 Sarah Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMACSHA1Signature : NSObject

+ (NSData *)signatureForKey:(NSData *)keyData data:(NSData *)data;

@end
