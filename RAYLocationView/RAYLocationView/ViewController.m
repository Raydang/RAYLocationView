//
//  ViewController.m
//  RAYLocationView
//
//  Created by richerpay on 15/5/29.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import "ViewController.h"
#import "RAYLocationViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
            RAYLocationViewController *locationViewController = [[RAYLocationViewController alloc]init];
            [self presentViewController:locationViewController animated:NO completion:nil];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
