//
//  JSONSchema.m
//  Framework
//
//  Created by Dan Kalinin on 27/09/16.
//  Copyright © 2016 Dan Kalinin. All rights reserved.
//

#import "JSONSchema.h"

static NSString *const JSONErrorsTable = @"Errors";
static NSString *const JSONErrorDomain = @"JSONErrorDomain";

#pragma mark - Type-specific keywords

static NSString *const JSONType = @"type";

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
























#pragma mark - Validators

// Base

@interface JSONValidator : NSObject

@property id object;
@property NSString *error;
- (BOOL)validate;

@end



@implementation JSONValidator

- (BOOL)validate {
    return YES;
}

@end










// String

@interface JSONStringValidator : JSONValidator

@property NSNumber *minLength;
@property NSNumber *maxLength;
@property NSString *pattern;
@property NSString *format;

@end



@implementation JSONStringValidator

- (BOOL)validate {
    
    // type
    
    if (![self.object isKindOfClass:[NSString class]]) {
        self.error = JSONType;
        return NO;
    }
    
    NSString *string = self.object;
    
    // minLength
    
    if (self.minLength) {
        if (string.length < self.minLength.unsignedIntegerValue) {
            self.error = JSONMinLength;
            return NO;
        }
    }
    
    // maxLength
    
    if (self.maxLength) {
        if (string.length > self.maxLength.unsignedIntegerValue) {
            self.error = JSONMaxLength;
            return NO;
        }
    }
    
    // pattern
    
    if (self.pattern) {
        NSError *error = nil;
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:self.pattern options:0 error:&error];
        if (!regexp) {
            self.error = JSONPattern;
            return NO;
        }
        
        NSUInteger matches = [regexp numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
        if (matches == 0) {
            self.error = JSONPattern;
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
            
        } else {
            self.error = JSONFormat;
            return NO;
        }
    }
    
    return YES;
}

- (void)setError:(NSString *)error {
    error = [NSString stringWithFormat:@"%@.%@", JSONString, error];
    [super setError:error];
}

@end










// Number

@interface JSONNumberValidator : JSONValidator

@property NSNumber *multipleOf;
@property NSNumber *minimum;
@property NSNumber *maximum;
@property NSNumber *exclusiveMinimum;
@property NSNumber *exclusiveMaximum;

@end



@implementation JSONNumberValidator

- (BOOL)validate {
    
    // type
    
    if (![self.object isKindOfClass:[NSNumber class]]) {
        self.error = JSONType;
        return NO;
    }
    
    NSNumber *number = self.object;
    
    // multipleOf
    
    if (self.multipleOf) {
        int remainder = number.intValue % self.multipleOf.intValue;
        if (remainder != 0) {
            self.error = JSONMultipleOf;
            return NO;
        }
    }
    
    // minimum, exclusiveMinimum
    
    if (self.minimum) {
        
        if (self.exclusiveMinimum) {
            if (self.exclusiveMinimum.boolValue) {
                if (number.intValue <= self.minimum.intValue) {
                    self.error = JSONExclusiveMinimum;
                    return NO;
                }
            }
        }
        
        if (number.intValue < self.minimum.intValue) {
            self.error = JSONMinimum;
            return NO;
        }
    }
    
    // maximum, exclusiveMaximum
    
    if (self.maximum) {
        
        if (self.exclusiveMaximum) {
            if (self.exclusiveMaximum.boolValue) {
                if (number.intValue >= self.maximum.intValue) {
                    self.error = JSONExclusiveMaximum;
                    return NO;
                }
            }
        }
        
        if (number.intValue > self.maximum.intValue) {
            self.error = JSONMaximum;
            return NO;
        }
    }
    
    return YES;
}

- (void)setError:(NSString *)error {
    error = [NSString stringWithFormat:@"%@.%@", JSONNumber, error];
    [super setError:error];
}

@end










// Object

@interface JSONObjectValidator : JSONValidator

@property NSDictionary *properties;
@property id additionalProperties;
@property NSArray *required;
@property NSNumber *minProperties;
@property NSNumber *maxProperties;
@property NSDictionary *dependencies;
@property NSDictionary *patternProperties;

@end



@implementation JSONObjectValidator

- (BOOL)validate {
    
    // type
    
    if (![self.object isKindOfClass:[NSDictionary class]]) {
        self.error = JSONType;
        return NO;
    }
    
    NSDictionary *object = [self.object mutableCopy];
    NSMutableDictionary *properties = self.properties ? self.properties.mutableCopy : [NSMutableDictionary dictionary];
    NSMutableArray *required = self.required ? self.required.mutableCopy : [NSMutableArray array];
    
    // patternProperties
    
    for (NSString *patternProperty in self.patternProperties.allKeys) {
        NSError *error = nil;
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:patternProperty options:0 error:&error];
        if (!regexp) {
            self.error = JSONPatternProperties;
            return NO;
        }
        
        for (NSString *property in object.allKeys) {
            NSUInteger matches = [regexp numberOfMatchesInString:property options:0 range:NSMakeRange(0, property.length)];
            if (matches > 0) {
                properties[property] = self.patternProperties[patternProperty];
                break;
            };
        }
    }
    
    // dependencies
    
    for (NSString *property in self.dependencies.allKeys) {
        if ([object.allKeys containsObject:property]) {
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
                
                self.error = JSONDependencies;
                return NO;
                
            }
        }
    }
    
    // required
    
    for (NSString *requiredProperty in required) {
        if (![object.allKeys containsObject:requiredProperty]) {
            self.error = JSONRequired;
            return NO;
        }
    }
    
    // minProperties
    
    if (self.minProperties) {
        if (object.count < self.minProperties.unsignedIntegerValue) {
            self.error = JSONMinProperties;
            return NO;
        }
    }
    
    // maxProperties
    
    if (self.maxProperties) {
        if (object.count > self.maxProperties.unsignedIntegerValue) {
            self.error = JSONMaxProperties;
            return NO;
        }
    }
    
    // additionalProperties
    
    if (self.additionalProperties) {
        if ([self.additionalProperties isKindOfClass:[NSNumber class]]) {
            
            if (![self.additionalProperties boolValue]) {
                for (NSString *property in object.allKeys) {
                    if (![properties.allKeys containsObject:property]) {
                        self.error = JSONAdditionalProperties;
                        return NO;
                    }
                }
            }
            
        } else if ([self.additionalProperties isKindOfClass:[NSDictionary class]]) {
            
            for (NSString *property in object.allKeys) {
                if (![properties.allKeys containsObject:property]) {
                    properties[property] = self.additionalProperties;
                }
            }
            
        } else {
            self.error = JSONAdditionalProperties;
            return NO;
        }
    }
    
    // properties
    
    for (NSString *property in properties.allKeys) {
        NSDictionary *d = properties[property];
        id o = object[property];
        
        if (o) {
            JSONSchema *s = [[JSONSchema alloc] initWithDictionary:d];
            BOOL valid = [s validateObject:o error:nil];
            if (!valid) {
                self.error = JSONProperties;
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)setError:(NSString *)error {
    error = [NSString stringWithFormat:@"%@.%@", JSONObject, error];
    [super setError:error];
}

@end










// Array

@interface JSONArrayValidator : JSONValidator

@property id items;
@property NSNumber *additionalItems;
@property NSNumber *minItems;
@property NSNumber *maxItems;
@property NSNumber *uniqueItems;

@end



@implementation JSONArrayValidator

- (BOOL)validate {
    
    // type
    
    if (![self.object isKindOfClass:[NSArray class]]) {
        self.error = JSONType;
        return NO;
    }
    
    NSArray *array = self.object;
    
    // minItems
    
    if (self.minItems) {
        if (array.count < self.minItems.unsignedIntegerValue) {
            self.error = JSONMinItems;
            return NO;
        }
    }
    
    // maxItems
    
    if (self.maxItems) {
        if (array.count > self.maxItems.unsignedIntegerValue) {
            self.error = JSONMaxItems;
            return NO;
        }
    }
    
    // uniqueItems
    
    if (self.uniqueItems) {
        if (self.uniqueItems.boolValue) {
            NSSet *set = [NSSet setWithArray:array];
            if (set.count < array.count) {
                self.error = JSONUniqueItems;
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
                BOOL valid = [s validateObject:o error:nil];
                if (!valid) {
                    self.error = JSONItems;
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
                    BOOL valid = [s validateObject:o error:nil];
                    if (!valid) {
                        self.error = JSONItems;
                        return NO;
                    }
                }
            }
            
            // additionalItems
            
            if (self.additionalItems) {
                if (!self.additionalItems.boolValue) {
                    if (array.count > items.count) {
                        self.error = JSONAdditionalItems;
                        return NO;
                    }
                }
            }
            
        } else {
            
            self.error = JSONItems;
            return NO;
            
        }
    }
    
    return YES;
}

- (void)setError:(NSString *)error {
    error = [NSString stringWithFormat:@"%@.%@", JSONArray, error];
    [super setError:error];
}

@end










// Boolean

@interface JSONBooleanValidator : JSONValidator

@end



@implementation JSONBooleanValidator

- (BOOL)validate {
    
    // type
    
    if (![self.object isKindOfClass:[NSNumber class]]) {
        self.error = JSONType;
        return NO;
    }
    
    // value
    
    NSArray *values = @[@0, @1];
    if (![values containsObject:self.object]) {
        self.error = JSONType;
        return NO;
    }
    
    return YES;
}

- (void)setError:(NSString *)error {
    error = [NSString stringWithFormat:@"%@.%@", JSONBoolean, error];
    [super setError:error];
}

@end










// Null

@interface JSONNullValidator : JSONValidator

@end



@implementation JSONNullValidator

- (BOOL)validate {
    
    // type
    
    if (self.object != nil && ![self.object isKindOfClass:[NSNull class]]) {
        self.error = JSONType;
        return NO;
    }
    
    return YES;
}

- (void)setError:(NSString *)error {
    error = [NSString stringWithFormat:@"%@.%@", JSONNull, error];
    [super setError:error];
}

@end










// Enum

@interface JSONEnumValidator : JSONValidator

@property NSArray *enumeration;

@end



@implementation JSONEnumValidator

- (BOOL)validate {
    
    if (![self.enumeration containsObject:self.object]) {
        self.error = JSONEnum;
        return NO;
    }
    
    return YES;
}

@end










#pragma mark - Schema

@interface JSONSchema ()

@property NSDictionary *schema;

@end



@implementation JSONSchema

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
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    self = [self initWithDictionary:dictionary];
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
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
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
    BOOL valid = [self validateObject:object error:error];
    return valid;
}

- (BOOL)validateObject:(id)object error:(NSError **)error {
    
    // type
    
    JSONValidator *validator = nil;
    
    NSString *type = self.schema[JSONType];
    if (type) {
        if ([type isEqualToString:JSONString]) {
            JSONStringValidator *stringValidator = [JSONStringValidator new];
            stringValidator.minLength = self.schema[JSONMinLength];
            stringValidator.maxLength = self.schema[JSONMaxLength];
            stringValidator.pattern = self.schema[JSONPattern];
            stringValidator.format = self.schema[JSONFormat];
            validator = stringValidator;
        } else if ([type isEqualToString:JSONNumber]) {
            JSONNumberValidator *numberValidator = [JSONNumberValidator new];
            numberValidator.multipleOf = self.schema[JSONMultipleOf];
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
    }
    
    if (validator) {
        validator.object = object;
        BOOL valid = [validator validate];
        if (!valid) {
            if (error) {
                *error = [self errorWithDescription:validator.error];
            }
            return NO;
        }
    }
    
    // enum
    
    validator = nil;
    
    NSArray *enumeration = self.schema[JSONEnum];
    if (enumeration) {
        JSONEnumValidator *enumValidator = [JSONEnumValidator new];
        enumValidator.enumeration = self.schema[JSONEnum];
        validator = enumValidator;
    }
    
    if (validator) {
        validator.object = object;
        BOOL valid = [validator validate];
        if (!valid) {
            if (error) {
                *error = [self errorWithDescription:validator.error];
            }
            return NO;
        }
    }
    
    return YES;
    
//    BOOL valid = YES;
//    
//    JSONValidator *validator;
//    NSArray *keys;
//    
//    // type
//    
//    NSString *type = self.schema[JSONType];
//    if (type) {
//        if ([type isEqualToString:JSONString]) {
//            keys = @[JSONMinLength, JSONMaxLength, JSONPattern, JSONFormat];
//            validator = [JSONStringValidator new];
//        } else if ([type isEqualToString:JSONNumber]) {
//            keys = @[JSONMultipleOf, JSONMinimum, JSONMaximum, JSONExclusiveMinimum, JSONExclusiveMaximum];
//            validator = [JSONNumberValidator new];
//        } else if ([type isEqualToString:JSONBoolean]) {
//            keys = @[];
//            validator = [JSONBooleanValidator new];
//        } else if ([type isEqualToString:JSONNull]) {
//            keys = @[];
//            validator = [JSONNullValidator new];
//        }
//        
//        valid = [self validateObject:object withValidator:validator forKeys:keys];
//    }
//    
//    // enum
//    
//    NSArray *enumeration = self.schema[JSONEnum];
//    if (enumeration) {
//        keys = @[JSONEnum];
//        validator = [JSONEnumValidator new];
//        
//        valid = [self validateObject:object withValidator:validator forKeys:keys];
//    }
    
    
    
    
    
    
    
    
//    return YES;
}

#pragma mark - Helpers

- (NSError *)errorWithDescription:(NSString *)description {
    return nil;
}

//- (BOOL)validateObject:(id)object withValidator:(JSONValidator *)validator forKeys:(NSArray *)keys {
//    
//    validator.object = object;
//    
//    for (NSString *key in keys) {
//        id value = self.schema[key];
//        [validator setValue:value forKey:key];
//    }
//    
//    BOOL valid = [validator validate];
//    return valid;
//}
//
//- (NSError *)errorWithDescription:(NSString *)description {
//    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    userInfo[NSLocalizedDescriptionKey] = [bundle localizedStringForKey:description value:description table:JSONErrorsTable];
//    NSError *error = [NSError errorWithDomain:JSONErrorDomain code:0 userInfo:userInfo];
//    return error;
//}

@end
