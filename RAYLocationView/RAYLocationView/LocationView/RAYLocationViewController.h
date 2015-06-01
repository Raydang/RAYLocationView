//
//  RAYLocationViewController.h
//  RAYLocationView
//
//  Created by richerpay on 15/6/1.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RAYLocationViewController : UIViewController

- (void)InitLocationManager;
- (void)StartUpdateLocationWithTitle:(NSString *)title message:(NSString *)message;

@end
