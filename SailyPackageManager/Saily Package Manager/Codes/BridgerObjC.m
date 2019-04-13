//
//  BridgerObjC.m
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/14.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BridgerC.hpp"
#import "BridgerObjC.h"

@implementation SailyCommonObject
    
- (void)testCall {
    NSLog(@"Saily Obj-C bridged successfully.");
}
    
@end
