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

extern NSString *const JSONExtension;










@interface JSONSchema : NSObject

typedef void (^JSONSchemaHandler)(BOOL valid, NSError *error);

+ (BOOL)setDefinitionsURL:(NSURL *)URL forKey:(NSString *)key;
+ (BOOL)setDefinitionsString:(NSString *)string forKey:(NSString *)key;
+ (BOOL)setDefinitionsData:(NSData *)data forKey:(NSString *)key;
+ (void)setDefinitionsDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithString:(NSString *)string;
- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)validateURL:(NSURL *)URL error:(NSError **)error;
- (BOOL)validateString:(NSString *)string error:(NSError **)error;
- (BOOL)validateData:(NSData *)data error:(NSError **)error;
- (BOOL)validateObject:(id)object error:(NSError **)error;

+ (void)validateURL:(NSURL *)URL withSchemaURL:(NSURL *)schemaURL timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;
+ (void)validateURL:(NSURL *)URL withSchemaString:(NSString *)schemaString timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;
+ (void)validateURL:(NSURL *)URL withSchemaData:(NSString *)schemaData timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;
+ (void)validateURL:(NSURL *)URL withSchemaDictionary:(NSString *)schemaDictionary timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;

+ (void)validateString:(NSString *)string withSchemaURL:(NSURL *)schemaURL timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;
+ (void)validateString:(NSString *)string withSchemaString:(NSString *)schemaString timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;
+ (void)validateString:(NSString *)string withSchemaData:(NSString *)schemaData timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;
+ (void)validateString:(NSString *)string withSchemaDictionary:(NSString *)schemaDictionary timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;

+ (void)validateData:(NSData *)data withSchemaURL:(NSURL *)schemaURL timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;
+ (void)validateData:(NSData *)data withSchemaString:(NSString *)schemaString timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;
+ (void)validateData:(NSData *)data withSchemaData:(NSString *)schemaData timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;
+ (void)validateData:(NSData *)data withSchemaDictionary:(NSString *)schemaDictionary timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;

+ (void)validateObject:(id)object withSchemaURL:(NSURL *)schemaURL timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;
+ (void)validateObject:(id)object withSchemaString:(NSString *)schemaString timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;
+ (void)validateObject:(id)object withSchemaData:(NSString *)schemaData timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;
+ (void)validateObject:(id)object withSchemaDictionary:(NSString *)schemaDictionary timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion;

@end










@interface NSObject (JSONSchema)

+ (JSONSchema *)JSONSchemaNamed:(NSString *)name;
- (JSONSchema *)JSONSchemaNamed:(NSString *)name;

@end
