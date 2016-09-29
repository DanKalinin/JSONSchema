//
//  ViewController.m
//  App
//
//  Created by Dan Kalinin on 29/09/16.
//  Copyright © 2016 Dan Kalinin. All rights reserved.
//

#import "ViewController.h"
#import <JSONSchema/JSONSchema.h>



@interface ViewController ()

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"String" withExtension:@"json"];
    JSONSchema *schema = [[JSONSchema alloc] initWithURL:URL];
    
    NSError *error = nil;
    BOOL valid = [schema validateObject:@1 error:&error];
    NSLog(@"valid - %i", valid);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
