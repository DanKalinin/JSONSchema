//
//  JSONSchemaTests.m
//  JSONSchemaTests
//
//  Created by Dan Kalinin on 29/09/16.
//  Copyright © 2016 Dan Kalinin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSONSchema.h"



@interface JSONSchemaTests : XCTestCase

@end



@implementation JSONSchemaTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testString {
    
    // String - length
    
    NSURL *URL = [self URLForSchema:@"String-length"];
    JSONSchema *schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"1.0");
    
    BOOL valid = [schema validateObject:@"A" error:nil];
    XCTAssertFalse(valid, @"1.1");
    
    valid = [schema validateObject:@"AB" error:nil];
    XCTAssertTrue(valid, @"1.2");
    
    valid = [schema validateObject:@"ABC" error:nil];
    XCTAssertTrue(valid, @"1.3");
    
    valid = [schema validateObject:@"ABCD" error:nil];
    XCTAssertFalse(valid, @"1.4");
    
    // String - regexp
    
    URL = [self URLForSchema:@"String-regexp"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"2.0");
    
    valid = [schema validateObject:@"555-1212" error:nil];
    XCTAssertTrue(valid, @"2.1");
    
    valid = [schema validateObject:@"(888)555-1212" error:nil];
    XCTAssertTrue(valid, @"2.2");
    
    valid = [schema validateObject:@"(888)555-1212 ext. 532" error:nil];
    XCTAssertFalse(valid, @"2.3");
    
    valid = [schema validateObject:@"(800)FLOWERS" error:nil];
    XCTAssertFalse(valid, @"2.4");
    
    // String - format
    
    // TODO: implement
}

- (void)testNumber {
    
    // Number - multiple
    
    NSURL *URL = [self URLForSchema:@"Number-multiple"];
    JSONSchema *schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"1.0");
    
    BOOL valid = [schema validateObject:@0 error:nil];
    XCTAssertTrue(valid, @"1.1");
    
    valid = [schema validateObject:@10 error:nil];
    XCTAssertTrue(valid, @"1.2");
    
    valid = [schema validateObject:@20 error:nil];
    XCTAssertTrue(valid, @"1.3");
    
    valid = [schema validateObject:@23 error:nil];
    XCTAssertFalse(valid, @"1.4");
    
    // Number - range
    
    URL = [self URLForSchema:@"Number-range"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"2.0");
    
    valid = [schema validateObject:@-1 error:nil];
    XCTAssertFalse(valid, @"2.1");
    
    valid = [schema validateObject:@0 error:nil];
    XCTAssertTrue(valid, @"2.2");
    
    valid = [schema validateObject:@10 error:nil];
    XCTAssertTrue(valid, @"2.3");
    
    valid = [schema validateObject:@99 error:nil];
    XCTAssertTrue(valid, @"2.4");
    
    valid = [schema validateObject:@100 error:nil];
    XCTAssertFalse(valid, @"2.5");
}

- (void)testObject {
    
    // Object - properties
    
    NSURL *URL = [self URLForSchema:@"Object-properties"];
    JSONSchema *schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"1.0");
    
    BOOL valid = [schema validateString:@"{ \"number\": 1600, \"street_name\": \"Pennsylvania\", \"street_type\": \"Avenue\" }" error:nil];
    XCTAssertTrue(valid, @"1.1");
    
    valid = [schema validateString:@"{ \"number\": \"1600\", \"street_name\": \"Pennsylvania\", \"street_type\": \"Avenue\" }" error:nil];
    XCTAssertFalse(valid, @"1.2");
    
    valid = [schema validateString:@"{ \"number\": 1600, \"street_name\": \"Pennsylvania\" }" error:nil];
    XCTAssertTrue(valid, @"1.3");
    
    valid = [schema validateString:@"{ }" error:nil];
    XCTAssertTrue(valid, @"1.4");
    
    valid = [schema validateString:@"{ \"number\": 1600, \"street_name\": \"Pennsylvania\", \"street_type\": \"Avenue\", \"direction\": \"NW\" }" error:nil];
    XCTAssertTrue(valid, @"1.5");
    
    // Object - additionalProperties1
    
    URL = [self URLForSchema:@"Object-additionalProperties1"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"2.0");
    
    valid = [schema validateString:@"{ \"number\": 1600, \"street_name\": \"Pennsylvania\", \"street_type\": \"Avenue\" }" error:nil];
    XCTAssertTrue(valid, @"2.1");
    
    valid = [schema validateString:@"{ \"number\": 1600, \"street_name\": \"Pennsylvania\", \"street_type\": \"Avenue\", \"direction\": \"NW\" }" error:nil];
    XCTAssertFalse(valid, @"2.2");
    
    // Object - additionalProperties2
    
    URL = [self URLForSchema:@"Object-additionalProperties2"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"3.0");
    
    valid = [schema validateString:@"{ \"number\": 1600, \"street_name\": \"Pennsylvania\", \"street_type\": \"Avenue\" }" error:nil];
    XCTAssertTrue(valid, @"3.1");
    
    valid = [schema validateString:@"{ \"number\": 1600, \"street_name\": \"Pennsylvania\", \"street_type\": \"Avenue\", \"direction\": \"NW\" }" error:nil];
    XCTAssertTrue(valid, @"3.2");
    
    valid = [schema validateString:@"{ \"number\": 1600, \"street_name\": \"Pennsylvania\", \"street_type\": \"Avenue\", \"office_number\": 201  }" error:nil];
    XCTAssertFalse(valid, @"3.3");
    
    // Object - required
    
    URL = [self URLForSchema:@"Object-required"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"4.0");
    
    valid = [schema validateString:@"{ \"name\": \"William Shakespeare\", \"email\": \"bill@stratford-upon-avon.co.uk\" }" error:nil];
    XCTAssertTrue(valid, @"4.1");
    
    valid = [schema validateString:@"{ \"name\": \"William Shakespeare\", \"email\": \"bill@stratford-upon-avon.co.uk\", \"address\": \"Henley Street, Stratford-upon-Avon, Warwickshire, England\", \"authorship\": \"in question\" }" error:nil];
    XCTAssertTrue(valid, @"4.2");
    
    valid = [schema validateString:@"{ \"name\": \"William Shakespeare\", \"address\": \"Henley Street, Stratford-upon-Avon, Warwickshire, England\", }" error:nil];
    XCTAssertFalse(valid, @"4.3");
    
    // Object - size
    
    URL = [self URLForSchema:@"Object-size"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"5.0");
    
    valid = [schema validateString:@"{ }" error:nil];
    XCTAssertFalse(valid, @"5.1");
    
    valid = [schema validateString:@"{ \"a\": 0 }" error:nil];
    XCTAssertFalse(valid, @"5.2");
    
    valid = [schema validateString:@"{ \"a\": 0, \"b\": 1 }" error:nil];
    XCTAssertTrue(valid, @"5.3");
    
    valid = [schema validateString:@"{ \"a\": 0, \"b\": 1, \"c\": 2 }" error:nil];
    XCTAssertTrue(valid, @"5.4");
    
    valid = [schema validateString:@"{ \"a\": 0, \"b\": 1, \"c\": 2, \"d\": 3 }" error:nil];
    XCTAssertFalse(valid, @"5.5");
    
    // Object - propertyDependencies1
    
    URL = [self URLForSchema:@"Object-propertyDependencies1"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"6.0");
    
    valid = [schema validateString:@"{ \"name\": \"John Doe\", \"credit_card\": 5555555555555555, \"billing_address\": \"555 Debtor's Lane\" }" error:nil];
    XCTAssertTrue(valid, @"6.1");
    
    valid = [schema validateString:@"{ \"name\": \"John Doe\", \"credit_card\": 5555555555555555 }" error:nil];
    XCTAssertFalse(valid, @"6.2");
    
    valid = [schema validateString:@"{ \"name\": \"John Doe\" }" error:nil];
    XCTAssertTrue(valid, @"6.3");
    
    valid = [schema validateString:@"{ \"name\": \"John Doe\", \"billing_address\": \"555 Debtor's Lane\" }" error:nil];
    XCTAssertTrue(valid, @"6.4");
    
    // Object - propertyDependencies2
    
    URL = [self URLForSchema:@"Object-propertyDependencies2"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"7.0");
    
    valid = [schema validateString:@"{ \"name\": \"John Doe\", \"credit_card\": 5555555555555555 }" error:nil];
    XCTAssertFalse(valid, @"7.1");
    
    valid = [schema validateString:@"{ \"name\": \"John Doe\", \"billing_address\": \"555 Debtor's Lane\" }" error:nil];
    XCTAssertFalse(valid, @"7.2");
    
    // Object - schemaDependencies
    
    URL = [self URLForSchema:@"Object-schemaDependencies"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"8.0");
    
    valid = [schema validateString:@"{ \"name\": \"John Doe\", \"credit_card\": 5555555555555555, \"billing_address\": \"555 Debtor's Lane\" }" error:nil];
    XCTAssertTrue(valid, @"8.1");
    
    valid = [schema validateString:@"{ \"name\": \"John Doe\", \"credit_card\": 5555555555555555 }" error:nil];
    XCTAssertFalse(valid, @"8.2");
    
    valid = [schema validateString:@"{ \"name\": \"John Doe\", \"billing_address\": \"555 Debtor's Lane\" }" error:nil];
    XCTAssertTrue(valid, @"8.3");
    
    // Object - patternProperties1
    
    URL = [self URLForSchema:@"Object-patternProperties1"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"9.0");
    
    valid = [schema validateString:@"{ \"S_25\": \"This is a string\" }" error:nil];
    XCTAssertTrue(valid, @"9.1");
    
    valid = [schema validateString:@"{ \"I_0\": 42 }" error:nil];
    XCTAssertTrue(valid, @"9.2");
    
    valid = [schema validateString:@"{ \"S_0\": 42 }" error:nil];
    XCTAssertFalse(valid, @"9.3");
    
    valid = [schema validateString:@"{ \"I_42\": \"This is a string\" }" error:nil];
    XCTAssertFalse(valid, @"9.4");
    
    valid = [schema validateString:@"{ \"keyword\": \"value\" }" error:nil];
    XCTAssertFalse(valid, @"9.5");
    
    // Object - patternProperties2
    
    URL = [self URLForSchema:@"Object-patternProperties2"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"10.0");
    
    valid = [schema validateString:@"{ \"builtin\": 42 }" error:nil];
    XCTAssertTrue(valid, @"10.1");
    
    valid = [schema validateString:@"{ \"keyword\": \"value\" }" error:nil];
    XCTAssertTrue(valid, @"10.2");
    
    valid = [schema validateString:@"{ \"keyword\": 42 }" error:nil];
    XCTAssertFalse(valid, @"10.3");
}

- (void)testArray {
    
    // Array - list
    
    NSURL *URL = [self URLForSchema:@"Array-list"];
    JSONSchema *schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"1.0");
    
    BOOL valid = [schema validateString:@"[1, 2, 3, 4, 5]" error:nil];
    XCTAssertTrue(valid, @"1.1");
    
    valid = [schema validateString:@"[1, 2, \"3\", 4, 5]" error:nil];
    XCTAssertFalse(valid, @"1.2");
    
    valid = [schema validateString:@"[ ]" error:nil];
    XCTAssertTrue(valid);
    
    // Array - tuple 1
    
    URL = [self URLForSchema:@"Array-tuple1"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"2.0");
    
    valid = [schema validateString:@"[1600, \"Pennsylvania\", \"Avenue\", \"NW\"]" error:nil];
    XCTAssertTrue(valid, @"2.1");
    
    valid = [schema validateString:@"[24, \"Sussex\", \"Drive\"]" error:nil];
    XCTAssertFalse(valid, @"2.2");
    
    valid = [schema validateString:@"[\"Palais de l'Élysée\"]" error:nil];
    XCTAssertFalse(valid, @"2.3");
    
    valid = [schema validateString:@"[10, \"Downing\", \"Street\"]" error:nil];
    XCTAssertTrue(valid, @"2.4");
    
    valid = [schema validateString:@"[1600, \"Pennsylvania\", \"Avenue\", \"NW\", \"Washington\"]" error:nil];
    XCTAssertTrue(valid);
    
    // Array - tuple 2
    
    URL = [self URLForSchema:@"Array-tuple2"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"3.0");
    
    valid = [schema validateString:@"[1600, \"Pennsylvania\", \"Avenue\", \"NW\"]" error:nil];
    XCTAssertTrue(valid, @"3.1");
    
    valid = [schema validateString:@"[1600, \"Pennsylvania\", \"Avenue\"]" error:nil];
    XCTAssertTrue(valid, @"3.2");
    
    valid = [schema validateString:@"[1600, \"Pennsylvania\", \"Avenue\", \"NW\", \"Washington\"]" error:nil];
    XCTAssertFalse(valid, @"3.3");
    
    // Array - length
    
    URL = [self URLForSchema:@"Array-length"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"4.0");
    
    valid = [schema validateString:@"[ ]" error:nil];
    XCTAssertFalse(valid, @"4.1");
    
    valid = [schema validateString:@"[1]" error:nil];
    XCTAssertFalse(valid, @"4.2");
    
    valid = [schema validateString:@"[1, 2]" error:nil];
    XCTAssertTrue(valid, @"4.3");
    
    valid = [schema validateString:@"[1, 2, 3]" error:nil];
    XCTAssertTrue(valid, @"4.4");
    
    valid = [schema validateString:@"[1, 2, 3, 4]" error:nil];
    XCTAssertFalse(valid, @"4.5");
    
    // Array - uniqueness
    
    URL = [self URLForSchema:@"Array-uniqueness"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"5.0");
    
    valid = [schema validateString:@"[1, 2, 3, 4, 5]" error:nil];
    XCTAssertTrue(valid, @"5.1");
    
    valid = [schema validateString:@"[1, 2, 3, 3, 4]" error:nil];
    XCTAssertFalse(valid, @"5.2");
    
    valid = [schema validateString:@"[ ]" error:nil];
    XCTAssertTrue(valid, @"5.3");
    
    valid = [schema validateString:@"[ {\"a\" : 1}, {\"a\" : 1} ]" error:nil];
    XCTAssertFalse(valid);
}

- (void)testBoolean {
    
    JSONSchema *schema = [[JSONSchema alloc] initWithString:@"{\"type\" : \"boolean\"}"];
    XCTAssertNotNil(schema, @"1.0");
    
    BOOL valid = [schema validateString:@"true" error:nil];
    XCTAssertTrue(valid, @"1.1");
    
    valid = [schema validateString:@"false" error:nil];
    XCTAssertTrue(valid, @"1.2");
    
    valid = [schema validateString:@"\"true\"" error:nil];
    XCTAssertFalse(valid, @"1.3");
}

- (void)testNull {
    
    JSONSchema *schema = [[JSONSchema alloc] initWithString:@"{ \"type\": \"null\" }"];
    XCTAssertNotNil(schema, @"1.0");
    
    BOOL valid = [schema validateString:@"null" error:nil];
    XCTAssertTrue(valid, @"1.1");
    
    valid = [schema validateString:@"false" error:nil];
    XCTAssertFalse(valid, @"1.2");
    
    valid = [schema validateString:@"0" error:nil];
    XCTAssertFalse(valid, @"1.3");
    
    valid = [schema validateString:@"{\"a\" : \"b\"}" error:nil];
    XCTAssertFalse(valid, @"1.4");
}

- (void)testCombination {
    
    // Combination - allOf 1
    
    NSURL *URL = [self URLForSchema:@"Combination-allOf1"];
    JSONSchema *schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"1.0");

    BOOL valid = [schema validateObject:@"short" error:nil];
    XCTAssertTrue(valid, @"1.1");
    
    valid = [schema validateObject:@"too long" error:nil];
    XCTAssertFalse(valid, @"1.2");
    
    // Combination - allOf 2
    
    URL = [self URLForSchema:@"Combination-allOf2"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"2.0");
    
    valid = [schema validateObject:@"No way" error:nil];
    XCTAssertFalse(valid, @"2.1");
    
    valid = [schema validateObject:@-1 error:nil];
    XCTAssertFalse(valid, @"2.2");
    
    // Combination - anyOf
    
    URL = [self URLForSchema:@"Combination-anyOf"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"3.0");
    
    valid = [schema validateObject:@"short" error:nil];
    XCTAssertTrue(valid, @"3.1");
    
    valid = [schema validateObject:@"too long" error:nil];
    XCTAssertFalse(valid, @"3.2");
    
    valid = [schema validateObject:@12 error:nil];
    XCTAssertTrue(valid, @"3.3");
    
    valid = [schema validateObject:@-5 error:nil];
    XCTAssertFalse(valid, @"3.4");
    
    // Combination - oneOf 1
    
    URL = [self URLForSchema:@"Combination-oneOf1"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"4.0");
    
    valid = [schema validateObject:@10 error:nil];
    XCTAssertTrue(valid, @"4.1");
    
    valid = [schema validateObject:@9 error:nil];
    XCTAssertTrue(valid, @"4.2");
    
    valid = [schema validateObject:@2 error:nil];
    XCTAssertFalse(valid, @"4.3");
    
    valid = [schema validateObject:@15 error:nil];
    XCTAssertFalse(valid, @"4.4");
    
    // Combination - oneOf 2
    
    URL = [self URLForSchema:@"Combination-oneOf2"];
    schema = [[JSONSchema alloc] initWithURL:URL];
    XCTAssertNotNil(schema, @"5.0");
    
    valid = [schema validateObject:@10 error:nil];
    XCTAssertTrue(valid, @"5.1");
    
    valid = [schema validateObject:@9 error:nil];
    XCTAssertTrue(valid, @"5.2");
    
    valid = [schema validateObject:@2 error:nil];
    XCTAssertFalse(valid, @"5.3");
    
    valid = [schema validateObject:@15 error:nil];
    XCTAssertFalse(valid, @"5.4");
    
    // Combination - not
    
    schema = [[JSONSchema alloc] initWithString:@"{ \"not\": { \"type\": \"string\" } }"];
    XCTAssertNotNil(schema, @"6.0");
    
    valid = [schema validateObject:@42 error:nil];
    XCTAssertTrue(valid, @"6.1");
    
    valid = [schema validateString:@"{ \"key\": \"value\" }" error:nil];
    XCTAssertTrue(valid, @"6.2");
    
    valid = [schema validateObject:@"I am a string" error:nil];
    XCTAssertFalse(valid, @"6.3");
}

#pragma mark - Helpers

- (NSURL *)URLForSchema:(NSString *)schema {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *URL = [bundle URLForResource:schema withExtension:@"json"];
    return URL;
}

@end
