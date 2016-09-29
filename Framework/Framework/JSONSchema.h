//
//  JSONSchema.h
//  Framework
//
//  Created by Dan Kalinin on 27/09/16.
//  Copyright © 2016 Dan Kalinin. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double JSONSchemaVersionNumber;
FOUNDATION_EXPORT const unsigned char JSONSchemaVersionString[];



@interface JSONSchema : NSObject

- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithString:(NSString *)string;
- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)validateURL:(NSURL *)URL error:(NSError **)error;
- (BOOL)validateString:(NSString *)string error:(NSError **)error;
- (BOOL)validateData:(NSData *)data error:(NSError **)error;
- (BOOL)validateObject:(id)object error:(NSError **)error;

@end
