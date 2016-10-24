//
//  JSONSchema.m
//  Framework
//
//  Created by Dan Kalinin on 27/09/16.
//  Copyright © 2016 Dan Kalinin. All rights reserved.
//

#import "JSONSchema.h"
#import <Helpers/Helpers.h>

static NSString *const JSONFragment = @"#";
static NSString *const JSONRoot = @"/";

#pragma mark - Type-specific keywords

static NSString *const JSONType = @"type";

static NSString *const JSONTypeURL = @"url";
static NSString *const JSONTypeString = @"string";
static NSString *const JSONTypeData = @"data";
static NSString *const JSONTypeObject = @"object";

// String

static NSString *const JSONString = @"string";
static NSString *const JSONMinLength = @"minLength";
static NSString *const JSONMaxLength = @"maxLength";
static NSString *const JSONPattern = @"pattern";
static NSString *const JSONFormat = @"format";
static NSString *const JSONDateTime = @"date-time";
static NSString *const JSONEmail = @"email";
static NSString *const JSONHostname = @"hostname";
static NSString *const JSONIPv4 = @"ipv4";
static NSString *const JSONIPv6 = @"ipv6";
static NSString *const JSONURI = @"uri";
static NSString *const JSONRegex = @"regex";

// Number

static NSString *const JSONInteger = @"integer";
static NSString *const JSONNumber = @"number";
static NSString *const JSONMultipleOf = @"multipleOf";
static NSString *const JSONMinimum = @"minimum";
static NSString *const JSONMaximum = @"maximum";
static NSString *const JSONExclusiveMinimum = @"exclusiveMinimum";
static NSString *const JSONExclusiveMaximum = @"exclusiveMaximum";

// Object

static NSString *const JSONObject = @"object";
static NSString *const JSONProperties = @"properties";
static NSString *const JSONAdditionalProperties = @"additionalProperties";
static NSString *const JSONRequired = @"required";
static NSString *const JSONMinProperties = @"minProperties";
static NSString *const JSONMaxProperties = @"maxProperties";
static NSString *const JSONDependencies = @"dependencies";
static NSString *const JSONPatternProperties = @"patternProperties";

// Array

static NSString *const JSONArray = @"array";
static NSString *const JSONItems = @"items";
static NSString *const JSONAdditionalItems = @"additionalItems";
static NSString *const JSONMinItems = @"minItems";
static NSString *const JSONMaxItems = @"maxItems";
static NSString *const JSONUniqueItems = @"uniqueItems";

// Boolean

static NSString *const JSONBoolean = @"boolean";

// Null

static NSString *const JSONNull = @"null";

#pragma mark - Generic keywords

// Matadata

static NSString *const JSONTitle = @"title";
static NSString *const JSONDescription = @"description";
static NSString *const JSONDefault = @"default";

// Enumerated values

static NSString *const JSONEnum = @"enum";

#pragma mark - Combining schemas

static NSString *const JSONAllOf = @"allOf";
static NSString *const JSONAnyOf = @"anyOf";
static NSString *const JSONOneOf = @"oneOf";
static NSString *const JSONNot = @"not";

#pragma mark - Schema keyword

static NSString *const JSONSchemaKey = @"$schema";

static NSString *const JSONSchemaCurrent = @"http://json-schema.org/schema#";
static NSString *const JSONSchemaHyperschemaCurrent = @"http://json-schema.org/hyper-schema#";

static NSString *const JSONSchemaDraftV4 = @"http://json-schema.org/draft-04/schema#";
static NSString *const JSONSchemaHyperschemaDraftV4 = @"http://json-schema.org/draft-04/hyper-schema#";

static NSString *const JSONSchemaDraftV3 = @"http://json-schema.org/draft-03/schema#";
static NSString *const JSONSchemaHyperschemaDraftV3 = @"http://json-schema.org/draft-03/hyper-schema#";

#pragma mark - Complex schema structure

static NSString *const JSONRefKey = @"$ref";
static NSString *const JSONDefinitions = @"definitions";
static NSString *const JSONID = @"id";

#pragma mark - Errors

NSString *const JSONErrorDomain = @"JSONErrorDomain";

static NSString *const JSONErrorsTable = @"Errors";
static NSString *const JSONErrorSchema = @"schema";
static NSString *const JSONErrorData = @"data";
static NSString *const JSONErrorNil = @"nil";
static NSString *const JSONErrorTimeout = @"timeout";










@protocol JSONValidating <NSObject>

- (BOOL)validateObject:(id)object originalSchema:(NSDictionary *)originalSchema error:(NSString **)error path:(NSString **)path;

@end










#pragma mark - Validators

// Base

@interface JSONValidator : NSObject <JSONValidating>

@end



@implementation JSONValidator

- (BOOL)validateObject:(id)object originalSchema:(NSDictionary *)originalSchema error:(NSString **)error path:(NSString **)path {
    return YES;
}

@end










@interface JSONTypeValidator : JSONValidator

@property NSString *type;
- (NSString *)errorWithError:(NSString *)error;

@end



@implementation JSONTypeValidator

- (NSString *)errorWithError:(NSString *)error {
    error = [NSString stringWithFormat:@"%@.%@", self.type, error];
    return error;
}

@end










@interface JSONCombinationValidator : JSONValidator

@property NSArray *subschemas;

@end



@implementation JSONCombinationValidator

@end










// string

@interface JSONStringValidator : JSONTypeValidator

@property NSNumber *minLength;
@property NSNumber *maxLength;
@property NSString *pattern;
@property NSString *format;

@end



@implementation JSONStringValidator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = JSONString;
    }
    return self;
}

- (BOOL)validateObject:(id)object originalSchema:(NSDictionary *)originalSchema error:(NSString **)error path:(NSString **)path {
    
    // type
    
    if (![object isKindOfClass:[NSString class]]) {
        *error = [self errorWithError:JSONType];
        return NO;
    }
    
    NSString *string = object;
    
    // minLength
    
    if (self.minLength) {
        if (string.length < self.minLength.unsignedIntegerValue) {
            *error = [self errorWithError:JSONMinLength];
            return NO;
        }
    }
    
    // maxLength
    
    if (self.maxLength) {
        if (string.length > self.maxLength.unsignedIntegerValue) {
            *error = [self errorWithError:JSONMaxLength];
            return NO;
        }
    }
    
    // pattern
    
    if (self.pattern) {
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:self.pattern options:0 error:nil];
        if (!regexp) {
            *error = [self errorWithError:JSONPattern];
            return NO;
        }
        
        NSUInteger matches = [regexp numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
        if (matches == 0) {
            *error = [self errorWithError:JSONPattern];
            return NO;
        }
    }
    
    // format
    
    if (self.format) {
        if ([self.format isEqualToString:JSONDateTime]) {
            
        } else if ([self.format isEqualToString:JSONEmail]) {
            
        } else if ([self.format isEqualToString:JSONHostname]) {
            
        } else if ([self.format isEqualToString:JSONIPv4]) {
            
        } else if ([self.format isEqualToString:JSONIPv6]) {
            
        } else if ([self.format isEqualToString:JSONURI]) {
            
        } else if ([self.format isEqualToString:JSONRegex]) {
            
        } else {
            *error = [self errorWithError:JSONFormat];
            return NO;
        }
    }
    
    return YES;
}

@end










// number

@interface JSONNumberValidator : JSONTypeValidator

@property NSNumber *multipleOf;
@property NSNumber *minimum;
@property NSNumber *maximum;
@property NSNumber *exclusiveMinimum;
@property NSNumber *exclusiveMaximum;

@end



@implementation JSONNumberValidator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = JSONNumber;
    }
    return self;
}

- (BOOL)validateObject:(id)object originalSchema:(NSDictionary *)originalSchema error:(NSString **)error path:(NSString **)path {
    
    // type
    
    if (![object isKindOfClass:[NSNumber class]]) {
        *error = [self errorWithError:JSONType];
        return NO;
    }
    
    NSNumber *number = object;
    
    // multipleOf
    
    if (self.multipleOf) {
        double n = number.doubleValue / self.multipleOf.doubleValue;
        if (n != round(n)) {
            *error = [self errorWithError:JSONMultipleOf];
            return NO;
        }
    }
    
    // minimum, exclusiveMinimum
    
    if (self.minimum) {
        
        if (self.exclusiveMinimum) {
            if (self.exclusiveMinimum.boolValue) {
                if (number.intValue <= self.minimum.intValue) {
                    *error = [self errorWithError:JSONExclusiveMinimum];
                    return NO;
                }
            }
        }
        
        if (number.intValue < self.minimum.intValue) {
            *error = [self errorWithError:JSONMinimum];
            return NO;
        }
    }
    
    // maximum, exclusiveMaximum
    
    if (self.maximum) {
        
        if (self.exclusiveMaximum) {
            if (self.exclusiveMaximum.boolValue) {
                if (number.intValue >= self.maximum.intValue) {
                    *error = [self errorWithError:JSONExclusiveMaximum];
                    return NO;
                }
            }
        }
        
        if (number.intValue > self.maximum.intValue) {
            *error = [self errorWithError:JSONMaximum];
            return NO;
        }
    }
    
    return YES;
}

@end










// object

@interface JSONObjectValidator : JSONTypeValidator

@property NSDictionary *properties;
@property id additionalProperties;
@property NSArray *required;
@property NSNumber *minProperties;
@property NSNumber *maxProperties;
@property NSDictionary *dependencies;
@property NSDictionary *patternProperties;

@end



@implementation JSONObjectValidator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = JSONObject;
    }
    return self;
}

- (BOOL)validateObject:(id)object originalSchema:(NSDictionary *)originalSchema error:(NSString **)error path:(NSString **)path {
    
    // type
    
    if (![object isKindOfClass:[NSDictionary class]]) {
        *error = [self errorWithError:JSONType];
        return NO;
    }
    
    NSDictionary *dictionary = [object mutableCopy];
    NSMutableDictionary *properties = self.properties ? self.properties.mutableCopy : [NSMutableDictionary dictionary];
    NSMutableArray *required = self.required ? self.required.mutableCopy : [NSMutableArray array];
    
    // patternProperties
    
    for (NSString *patternProperty in self.patternProperties.allKeys) {
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:patternProperty options:0 error:nil];
        if (!regexp) {
            *error = [self errorWithError:JSONPatternProperties];
            return NO;
        }
        
        for (NSString *property in dictionary.allKeys) {
            NSUInteger matches = [regexp numberOfMatchesInString:property options:0 range:NSMakeRange(0, property.length)];
            if (matches > 0) {
                properties[property] = self.patternProperties[patternProperty];
            };
        }
    }
    
    // dependencies
    
    for (NSString *property in self.dependencies.allKeys) {
        if ([dictionary.allKeys containsObject:property]) {
            id dependencies = self.dependencies[property];
            if ([dependencies isKindOfClass:[NSArray class]]) {
                
                for (NSString *dependency in dependencies) {
                    if (![required containsObject:dependency]) {
                        [required addObject:dependency];
                    }
                }
                
            } else if ([dependencies isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *ps = dependencies[JSONProperties];
                if (ps.count) {
                    [properties addEntriesFromDictionary:ps];
                }
                
                NSArray *rs = dependencies[JSONRequired];
                for (NSString *r in rs) {
                    if (![required containsObject:r]) {
                        [required addObject:r];
                    }
                }
                
            } else {
                
                *error = [self errorWithError:JSONDependencies];
                return NO;
                
            }
        }
    }
    
    // required
    
    for (NSString *requiredProperty in required) {
        if (![dictionary.allKeys containsObject:requiredProperty]) {
            *error = [self errorWithError:JSONRequired];
            return NO;
        }
    }
    
    // minProperties
    
    if (self.minProperties) {
        if (dictionary.count < self.minProperties.unsignedIntegerValue) {
            *error = [self errorWithError:JSONMinProperties];
            return NO;
        }
    }
    
    // maxProperties
    
    if (self.maxProperties) {
        if (dictionary.count > self.maxProperties.unsignedIntegerValue) {
            *error = [self errorWithError:JSONMaxProperties];
            return NO;
        }
    }
    
    // additionalProperties
    
    if (self.additionalProperties) {
        if ([self.additionalProperties isKindOfClass:[NSNumber class]]) {
            
            if (![self.additionalProperties boolValue]) {
                for (NSString *property in dictionary.allKeys) {
                    if (![properties.allKeys containsObject:property]) {
                        *error = [self errorWithError:JSONAdditionalProperties];
                        return NO;
                    }
                }
            }
            
        } else if ([self.additionalProperties isKindOfClass:[NSDictionary class]]) {
            
            for (NSString *property in dictionary.allKeys) {
                if (![properties.allKeys containsObject:property]) {
                    properties[property] = self.additionalProperties;
                }
            }
            
        } else {
            *error = [self errorWithError:JSONAdditionalProperties];
            return NO;
        }
    }
    
    // properties
    
    for (NSString *property in properties.allKeys) {
        NSDictionary *d = properties[property];
        id o = dictionary[property];
        
        if (o) {
            JSONSchema *s = [[JSONSchema alloc] initWithDictionary:d];
            BOOL valid = [(id)s validateObject:o originalSchema:originalSchema error:error path:path];
            if (!valid) {
                *path = [*path stringByAppendingPathComponent:property];
                return NO;
            }
        }
    }
    
    return YES;
}

@end










// array

@interface JSONArrayValidator : JSONTypeValidator

@property id items;
@property NSNumber *additionalItems;
@property NSNumber *minItems;
@property NSNumber *maxItems;
@property NSNumber *uniqueItems;

@end



@implementation JSONArrayValidator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = JSONArray;
    }
    return self;
}

- (BOOL)validateObject:(id)object originalSchema:(NSDictionary *)originalSchema error:(NSString **)error path:(NSString **)path {
    
    // type
    
    if (![object isKindOfClass:[NSArray class]]) {
        *error = [self errorWithError:JSONType];
        return NO;
    }
    
    NSArray *array = object;
    
    // minItems
    
    if (self.minItems) {
        if (array.count < self.minItems.unsignedIntegerValue) {
            *error = [self errorWithError:JSONMinItems];
            return NO;
        }
    }
    
    // maxItems
    
    if (self.maxItems) {
        if (array.count > self.maxItems.unsignedIntegerValue) {
            *error = [self errorWithError:JSONMaxItems];
            return NO;
        }
    }
    
    // uniqueItems
    
    if (self.uniqueItems) {
        if (self.uniqueItems.boolValue) {
            NSSet *set = [NSSet setWithArray:array];
            if (set.count < array.count) {
                *error = [self errorWithError:JSONUniqueItems];
                return NO;
            }
        }
    }
    
    // items
    
    if (self.items) {
        if ([self.items isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *d = self.items;
            JSONSchema *s = [[JSONSchema alloc] initWithDictionary:d];
            for (id o in array) {
                BOOL valid = [(id)s validateObject:o originalSchema:originalSchema error:error path:path];
                if (!valid) {
                    NSUInteger i = [array indexOfObject:o];
                    NSString *is = [NSString stringWithFormat:@"%i", (int)i];
                    *path = [*path stringByAppendingPathComponent:is];
                    
                    return NO;
                }
            }
            
        } else if ([self.items isKindOfClass:[NSArray class]]) {
            
            NSArray *items = self.items;
            
            for (NSUInteger index = 0; index < array.count; index++) {
                id o = array[index];
                if (index < items.count) {
                    NSDictionary *d = items[index];
                    JSONSchema *s = [[JSONSchema alloc] initWithDictionary:d];
                    BOOL valid = [(id)s validateObject:o originalSchema:originalSchema error:error path:path];
                    if (!valid) {
                        NSString *is = [NSString stringWithFormat:@"%i", (int)index];
                        *path = [*path stringByAppendingPathComponent:is];
                        
                        return NO;
                    }
                }
            }
            
            // additionalItems
            
            if (self.additionalItems) {
                if (!self.additionalItems.boolValue) {
                    if (array.count > items.count) {
                        *error = [self errorWithError:JSONAdditionalItems];
                        return NO;
                    }
                }
            }
            
        } else {
            
            *error = [self errorWithError:JSONItems];
            return NO;
            
        }
    }
    
    return YES;
}

@end










// boolean

@interface JSONBooleanValidator : JSONTypeValidator

@end



@implementation JSONBooleanValidator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = JSONBoolean;
    }
    return self;
}

- (BOOL)validateObject:(id)object originalSchema:(NSDictionary *)originalSchema error:(NSString **)error path:(NSString **)path {
    
    // type
    
    if (![object isKindOfClass:[NSNumber class]]) {
        *error = [self errorWithError:JSONType];
        return NO;
    }
    
    // value
    
    NSArray *values = @[@0, @1];
    if (![values containsObject:object]) {
        *error = [self errorWithError:JSONType];
        return NO;
    }
    
    return YES;
}

@end










// null

@interface JSONNullValidator : JSONTypeValidator

@end



@implementation JSONNullValidator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = JSONNull;
    }
    return self;
}

- (BOOL)validateObject:(id)object originalSchema:(NSDictionary *)originalSchema error:(NSString **)error path:(NSString **)path {
    
    // type
    
    if (object != nil && ![object isKindOfClass:[NSNull class]]) {
        *error = [self errorWithError:JSONType];
        return NO;
    }
    
    return YES;
}

@end










// enum

@interface JSONEnumValidator : JSONValidator

@property NSArray *enumeration;

@end



@implementation JSONEnumValidator

- (BOOL)validateObject:(id)object originalSchema:(NSDictionary *)originalSchema error:(NSString **)error path:(NSString **)path {
    
    if (![self.enumeration containsObject:object]) {
        *error = JSONEnum;
        return NO;
    }
    
    return YES;
}

@end










// allOf

@interface JSONAllOfValidator : JSONCombinationValidator

@end



@implementation JSONAllOfValidator

- (BOOL)validateObject:(id)object originalSchema:(NSDictionary *)originalSchema error:(NSString **)error path:(NSString **)path {
    
    for (NSDictionary *subschema in self.subschemas) {
        JSONSchema *schema = [[JSONSchema alloc] initWithDictionary:subschema];
        BOOL valid = [(id)schema validateObject:object originalSchema:originalSchema error:error path:path];
        if (!valid) {
            *error = JSONAllOf;
            return NO;
        }
    }
    
    return YES;
}

@end










// anyOf

@interface JSONAnyOfValidator : JSONCombinationValidator

@end



@implementation JSONAnyOfValidator

- (BOOL)validateObject:(id)object originalSchema:(NSDictionary *)originalSchema error:(NSString **)error path:(NSString **)path {
    
    for (NSDictionary *subschema in self.subschemas) {
        JSONSchema *schema = [[JSONSchema alloc] initWithDictionary:subschema];
        BOOL valid = [(id)schema validateObject:object originalSchema:originalSchema error:error path:path];
        if (valid) return YES;
    }
    
    *error = JSONAnyOf;
    return NO;
}

@end










// oneOf

@interface JSONOneOfValidator : JSONCombinationValidator

@end



@implementation JSONOneOfValidator

- (BOOL)validateObject:(id)object originalSchema:(NSDictionary *)originalSchema error:(NSString **)error path:(NSString **)path {
    
    int matches = 0;
    for (NSDictionary *subschema in self.subschemas) {
        JSONSchema *schema = [[JSONSchema alloc] initWithDictionary:subschema];
        BOOL valid = [(id)schema validateObject:object originalSchema:originalSchema error:error path:path];
        matches += valid;
        if (matches > 1) {
            *error = JSONOneOf;
            return NO;
        }
    }
    
    if (matches == 1) return YES;
    
    *error = JSONOneOf;
    return NO;
}

@end










// not

@interface JSONNotValidator : JSONValidator

@property NSDictionary *subschema;

@end



@implementation JSONNotValidator

- (BOOL)validateObject:(id)object originalSchema:(NSDictionary *)originalSchema error:(NSString **)error path:(NSString **)path {
    JSONSchema *schema = [[JSONSchema alloc] initWithDictionary:self.subschema];
    BOOL valid = [(id)schema validateObject:object originalSchema:originalSchema error:error path:path];
    if (valid) {
        *error = JSONNot;
        return NO;
    }
    
    return YES;
}

@end










#pragma mark - Schema

@interface JSONSchema () <JSONValidating>

@property NSDictionary *schema;

@end



@implementation JSONSchema

static NSMutableDictionary *_definitions = nil;

+ (BOOL)setDefinitionsURL:(NSURL *)URL forKey:(NSString *)key {
    NSData *data = [NSData dataWithContentsOfURL:URL];
    BOOL success = [self setDefinitionsData:data forKey:key];
    return success;
}

+ (BOOL)setDefinitionsString:(NSString *)string forKey:(NSString *)key {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    BOOL success = [self setDefinitionsData:data forKey:key];
    return success;
}

+ (BOOL)setDefinitionsData:(NSData *)data forKey:(NSString *)key {
    @try {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSAssert(dictionary, NSStringFromClass(self));
        [self setDefinitionsDictionary:dictionary forKey:key];
        return YES;
    } @catch (NSException *exception) {
        return NO;
    }
}

+ (void)setDefinitionsDictionary:(NSDictionary *)dictionary forKey:(NSString *)key {
    @synchronized (_definitions) {
        if (!_definitions) {
            _definitions = [NSMutableDictionary dictionary];
        }
        _definitions[key] = dictionary;
    }
}

- (instancetype)initWithURL:(NSURL *)URL {
    NSData *data = [NSData dataWithContentsOfURL:URL];
    self = [self initWithData:data];
    return self;
}

- (instancetype)initWithString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    self = [self initWithData:data];
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    @try {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSAssert(dictionary, NSStringFromClass([self class]));
        self = [self initWithDictionary:dictionary];
        return self;
    } @catch (NSException *exception) {
        return nil;
    }
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        BOOL isSpec = NO;
        
        NSString *schema = dictionary[JSONSchemaKey];
        if (schema) {
            
            NSString *identifier = dictionary[JSONID];
            isSpec = [identifier isEqualToString:schema];
            if (!isSpec) {
                
                NSURL *URL = [self.bundle URLForResource:JSONSchemaDraftV4.stringByDeletingLastPathComponent.lastPathComponent withExtension:JSONExtension];
                NSData *data = [NSData dataWithContentsOfURL:URL];
                
                if (![schema isEqualToString:JSONSchemaDraftV4]) {
                    URL = [NSURL URLWithString:schema];
                    NSData *d = [NSData dataWithContentsOfURL:URL];
                    if (![d isEqualToData:data]) return nil;
                }
                
                NSDictionary *specDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                JSONSchema *specSchema = [[JSONSchema alloc] initWithDictionary:specDict];
                BOOL valid = [specSchema validateObject:dictionary error:nil];
                if (!valid) return nil;
            }
        }
        
        if (!isSpec && _definitions.count) {
            NSMutableDictionary *schema = dictionary.mutableCopy;
            [schema addEntriesFromDictionary:_definitions];
            dictionary = schema;
        }
        
        self.schema = dictionary;
    }
    return self;
}

- (BOOL)validateURL:(NSURL *)URL error:(NSError **)error {
    NSData *data = [NSData dataWithContentsOfURL:URL];
    BOOL valid = [self validateData:data error:error];
    return valid;
}

- (BOOL)validateString:(NSString *)string error:(NSError **)error {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    BOOL valid = [self validateData:data error:error];
    return valid;
}

- (BOOL)validateData:(NSData *)data error:(NSError **)error {
    @try {
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        BOOL valid = [self validateObject:object error:error];
        return valid;
    } @catch (NSException *exception) {
        if (error) {
            *error = [self errorWithDescription:JSONErrorData atPath:JSONFragment];
        }
        return NO;
    }
}

- (BOOL)validateObject:(id)object error:(NSError **)error {
    NSString *description = nil;
    NSString *path = JSONFragment;
    BOOL valid = [self validateObject:object originalSchema:self.schema error:&description path:&path];
    if (!valid && error) {
        *error = [self errorWithDescription:description atPath:path];
    }
    return valid;
}

#pragma mark - Asynchronous validation

// URL

+ (void)validateURL:(NSURL *)URL withSchemaURL:(NSURL *)schemaURL timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:URL type:JSONTypeURL withSchema:schemaURL schemaType:JSONTypeURL timeout:timeout completion:completion];
}

+ (void)validateURL:(NSURL *)URL withSchemaString:(NSString *)schemaString timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:URL type:JSONTypeURL withSchema:schemaString schemaType:JSONTypeString timeout:timeout completion:completion];
}

+ (void)validateURL:(NSURL *)URL withSchemaData:(NSString *)schemaData timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:URL type:JSONTypeURL withSchema:schemaData schemaType:JSONTypeData timeout:timeout completion:completion];
}

+ (void)validateURL:(NSURL *)URL withSchemaDictionary:(NSString *)schemaDictionary timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:URL type:JSONTypeURL withSchema:schemaDictionary schemaType:JSONTypeObject timeout:timeout completion:completion];
}

// String

+ (void)validateString:(NSString *)string withSchemaURL:(NSURL *)schemaURL timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:string type:JSONTypeString withSchema:schemaURL schemaType:JSONTypeURL timeout:timeout completion:completion];
}

+ (void)validateString:(NSString *)string withSchemaString:(NSString *)schemaString timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:string type:JSONTypeString withSchema:schemaString schemaType:JSONTypeString timeout:timeout completion:completion];
}

+ (void)validateString:(NSString *)string withSchemaData:(NSString *)schemaData timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:string type:JSONTypeString withSchema:schemaData schemaType:JSONTypeData timeout:timeout completion:completion];
}

+ (void)validateString:(NSString *)string withSchemaDictionary:(NSString *)schemaDictionary timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:string type:JSONTypeString withSchema:schemaDictionary schemaType:JSONTypeObject timeout:timeout completion:completion];
}

// Data

+ (void)validateData:(NSData *)data withSchemaURL:(NSURL *)schemaURL timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:data type:JSONTypeData withSchema:schemaURL schemaType:JSONTypeURL timeout:timeout completion:completion];
}

+ (void)validateData:(NSData *)data withSchemaString:(NSString *)schemaString timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:data type:JSONTypeData withSchema:schemaString schemaType:JSONTypeString timeout:timeout completion:completion];
}

+ (void)validateData:(NSData *)data withSchemaData:(NSString *)schemaData timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:data type:JSONTypeData withSchema:schemaData schemaType:JSONTypeData timeout:timeout completion:completion];
}

+ (void)validateData:(NSData *)data withSchemaDictionary:(NSString *)schemaDictionary timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:data type:JSONTypeData withSchema:schemaDictionary schemaType:JSONTypeObject timeout:timeout completion:completion];
}

// Object

+ (void)validateObject:(id)object withSchemaURL:(NSURL *)schemaURL timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:object type:JSONTypeObject withSchema:schemaURL schemaType:JSONTypeURL timeout:timeout completion:completion];
}

+ (void)validateObject:(id)object withSchemaString:(NSString *)schemaString timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:object type:JSONTypeObject withSchema:schemaString schemaType:JSONTypeString timeout:timeout completion:completion];
}

+ (void)validateObject:(id)object withSchemaData:(NSString *)schemaData timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:object type:JSONTypeObject withSchema:schemaData schemaType:JSONTypeData timeout:timeout completion:completion];
}

+ (void)validateObject:(id)object withSchemaDictionary:(NSString *)schemaDictionary timeout:(NSTimeInterval)timeout completion:(JSONSchemaHandler)completion {
    [self validate:object type:JSONTypeObject withSchema:schemaDictionary schemaType:JSONTypeObject timeout:timeout completion:completion];
}

#pragma mark - Helpers

+ (void)validate:(id)o type:(NSString *)ot withSchema:(id)s schemaType:(NSString *)st timeout:(NSTimeInterval)t completion:(JSONSchemaHandler)c {
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSOperation *operation = [NSOperationQueue currentQueue].operations.firstObject;
        
        // Init schema
        
        JSONSchema *schema = nil;
        
        if ([st isEqualToString:JSONTypeURL]) {
            schema = [[JSONSchema alloc] initWithURL:s];
        } else if ([st isEqualToString:JSONTypeString]) {
            schema = [[JSONSchema alloc] initWithString:s];
        } else if ([st isEqualToString:JSONTypeData]) {
            schema = [[JSONSchema alloc] initWithData:s];
        } else if ([st isEqualToString:JSONTypeObject]) {
            schema = [[JSONSchema alloc] initWithDictionary:s];
        }
        
        if (operation.cancelled) return;
        
        if (!schema) {
            NSError *error = [self errorWithDescription:JSONErrorSchema];
            [self invokeHandler:c valid:NO error:error];
            return;
        }
        
        // Validate
        
        BOOL valid = NO;
        NSError *error = nil;
        
        if ([ot isEqualToString:JSONTypeURL]) {
            valid = [schema validateURL:o error:&error];
        } else if ([ot isEqualToString:JSONTypeString]) {
            valid = [schema validateString:o error:&error];
        } else if ([ot isEqualToString:JSONTypeData]) {
            valid = [schema validateData:o error:&error];
        } else if ([ot isEqualToString:JSONTypeObject]) {
            valid = [schema validateObject:o error:&error];
        }
        
        if (operation.cancelled) return;
        
        [self invokeHandler:c valid:valid error:error];
    }];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:operation];
    
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    currentQueue = currentQueue ? currentQueue : [NSOperationQueue mainQueue];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (operation.executing) {
            [operation cancel];
            
            NSError *error = [self errorWithDescription:JSONErrorTimeout];
            [currentQueue addOperationWithBlock:^{
                [self invokeHandler:c valid:NO error:error];
            }];
        }
    });
}

+ (NSError *)errorWithDescription:(NSString *)description {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[NSLocalizedDescriptionKey] = [self.bundle localizedStringForKey:description value:description table:JSONErrorsTable];
    NSError *error = [NSError errorWithDomain:JSONErrorDomain code:0 userInfo:userInfo];
    return error;
}

+ (void)invokeHandler:(JSONSchemaHandler)handler valid:(BOOL)valid error:(NSError *)error {
    if (handler) {
        handler(valid, error);
    }
}

- (BOOL)validateObject:(id)object originalSchema:(NSDictionary *)originalSchema error:(NSString **)error path:(NSString **)path {
    
    // $ref
    
    for (NSString *key in self.schema.allKeys) {
        if ([key isEqualToString:JSONRefKey]) {
            NSString *ref = self.schema[key];
            NSURL *URL = [NSURL URLWithString:ref];
            self.schema = originalSchema;
            for (NSString *component in URL.fragment.pathComponents) {
                if ([component isEqualToString:JSONRoot]) continue;
                self.schema = self.schema[component];
            }
        }
    }
    
    // type
    
    JSONValidator *validator = nil;
    
    id type = self.schema[JSONType];
    type = type ? type : [self resolvedType];
    
    if (type) {
        if ([type isKindOfClass:[NSString class]]) {
            
            if ([type isEqualToString:JSONString]) {
                JSONStringValidator *stringValidator = [JSONStringValidator new];
                stringValidator.minLength = self.schema[JSONMinLength];
                stringValidator.maxLength = self.schema[JSONMaxLength];
                stringValidator.pattern = self.schema[JSONPattern];
                stringValidator.format = self.schema[JSONFormat];
                validator = stringValidator;
            } else if ([@[JSONNumber, JSONInteger] containsObject:type]) {
                
                NSNumber *multipleOf = self.schema[JSONMultipleOf];
                if ([type isEqualToString:JSONInteger]) {
                    multipleOf = multipleOf ? @(multipleOf.intValue) : @1;
                }
                
                JSONNumberValidator *numberValidator = [JSONNumberValidator new];
                numberValidator.multipleOf = multipleOf;
                numberValidator.minimum = self.schema[JSONMinimum];
                numberValidator.maximum = self.schema[JSONMaximum];
                numberValidator.exclusiveMinimum = self.schema[JSONExclusiveMinimum];
                numberValidator.exclusiveMaximum = self.schema[JSONExclusiveMaximum];
                validator = numberValidator;
            } else if ([type isEqualToString:JSONObject]) {
                JSONObjectValidator *objectValidator = [JSONObjectValidator new];
                objectValidator.properties = self.schema[JSONProperties];
                objectValidator.additionalProperties = self.schema[JSONAdditionalProperties];
                objectValidator.required = self.schema[JSONRequired];
                objectValidator.minProperties = self.schema[JSONMinProperties];
                objectValidator.maxProperties = self.schema[JSONMaxProperties];
                objectValidator.dependencies = self.schema[JSONDependencies];
                objectValidator.patternProperties = self.schema[JSONPatternProperties];
                validator = objectValidator;
            } else if ([type isEqualToString:JSONArray]) {
                JSONArrayValidator *arrayValidator = [JSONArrayValidator new];
                arrayValidator.items = self.schema[JSONItems];
                arrayValidator.additionalItems = self.schema[JSONAdditionalItems];
                arrayValidator.minItems = self.schema[JSONMinItems];
                arrayValidator.maxItems = self.schema[JSONMaxItems];
                arrayValidator.uniqueItems = self.schema[JSONUniqueItems];
                validator = arrayValidator;
            } else if ([type isEqualToString:JSONBoolean]) {
                JSONBooleanValidator *booleanValidator = [JSONBooleanValidator new];
                validator = booleanValidator;
            } else if ([type isEqualToString:JSONNull]) {
                JSONNullValidator *nullValidator = [JSONNullValidator new];
                validator = nullValidator;
            }
            
            if (validator) {
                BOOL valid = [validator validateObject:object originalSchema:originalSchema error:error path:path];
                if (!valid) return NO;
            }
            
        } else if ([type isKindOfClass:[NSArray class]]) {
            
            NSArray *types = type;
            
            BOOL valid = NO;
            
            for (NSString *type in types) {
                NSMutableDictionary *dictionary = self.schema.mutableCopy;
                dictionary[JSONType] = type;
                
                JSONSchema *schema = [[JSONSchema alloc] initWithDictionary:dictionary];
                valid = [schema validateObject:object originalSchema:originalSchema error:error path:path];
                if (valid) break;
            }
            
            if (!valid) {
                *error = JSONType;
                return NO;
            }
            
        }
    }
    
    // enum
    
    NSArray *enumeration = self.schema[JSONEnum];
    if (enumeration) {
        JSONEnumValidator *enumValidator = [JSONEnumValidator new];
        enumValidator.enumeration = self.schema[JSONEnum];
        BOOL valid = [enumValidator validateObject:object originalSchema:originalSchema error:error path:path];
        if (!valid) return NO;
    }
    
    // combinations
    
    validator = nil;
    
    NSArray *allOf = self.schema[JSONAllOf];
    NSArray *anyOf = self.schema[JSONAnyOf];
    NSArray *oneOf = self.schema[JSONOneOf];
    NSDictionary *not = self.schema[JSONNot];
    
    if (allOf) {
        JSONAllOfValidator *allOfValidator = [JSONAllOfValidator new];
        allOfValidator.subschemas = allOf;
        validator = allOfValidator;
    } else if (anyOf) {
        JSONAnyOfValidator *anyOfValidator = [JSONAnyOfValidator new];
        anyOfValidator.subschemas = anyOf;
        validator = anyOfValidator;
    } else if (oneOf) {
        JSONOneOfValidator *oneOfValidator = [JSONOneOfValidator new];
        oneOfValidator.subschemas = oneOf;
        validator = oneOfValidator;
    } else if (not) {
        JSONNotValidator *notValidator = [JSONNotValidator new];
        notValidator.subschema = not;
        validator = notValidator;
    }
    
    if (validator) {
        BOOL valid = [validator validateObject:object originalSchema:originalSchema error:error path:path];
        if (!valid) return NO;
    }
    
    return YES;
}

- (NSString *)resolvedType {
    
    NSArray *keys = self.schema.allKeys;
    
    NSArray *keywords = @[JSONMinLength, JSONMaxLength, JSONPattern, JSONFormat];
    if ([keys firstObjectCommonWithArray:keywords]) return JSONString;
    
    keywords = @[JSONMultipleOf, JSONMinimum, JSONMaximum, JSONExclusiveMinimum, JSONExclusiveMaximum];
    if ([keys firstObjectCommonWithArray:keywords]) return JSONNumber;
    
    keywords = @[JSONProperties, JSONAdditionalProperties, JSONRequired, JSONMinProperties, JSONMaxProperties, JSONDependencies, JSONPatternProperties];
    if ([keys firstObjectCommonWithArray:keywords]) return JSONObject;
    
    keywords = @[JSONItems, JSONAdditionalItems, JSONMinItems, JSONMaxItems, JSONUniqueItems];
    if ([keys firstObjectCommonWithArray:keywords]) return JSONArray;
    
    return nil;
}

- (NSError *)errorWithDescription:(NSString *)description atPath:(NSString *)path {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[NSLocalizedDescriptionKey] = [self.bundle localizedStringForKey:description value:description table:JSONErrorsTable];
    userInfo[NSFilePathErrorKey] = path;
    NSError *error = [NSError errorWithDomain:JSONErrorDomain code:0 userInfo:userInfo];
    return error;
}

@end










@implementation NSObject (JSONSchema)

+ (JSONSchema *)JSONSchemaNamed:(NSString *)name {
    NSURL *URL = [self.bundle URLForResource:name withExtension:JSONExtension];
    JSONSchema *schema = [[JSONSchema alloc] initWithURL:URL];
    NSAssert(schema, name);
    return schema;
}

- (JSONSchema *)JSONSchemaNamed:(NSString *)name {
    JSONSchema *schema = [self.class JSONSchemaNamed:name];
    return schema;
}

@end
