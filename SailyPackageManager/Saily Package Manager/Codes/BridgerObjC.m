//
//  BridgerObjC.m
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/14.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BridgerObjC.h"
#import "MobileGestalt.h"
#import "mach/mach.h"

@implementation SailyCommonObject
    
- (void)testCall {
    NSLog(@"Saily Obj-C bridged successfully.");
}

- (NSString *)readUDID {
    
    CFPropertyListRef udid = MGCopyAnswer(kMGUniqueDeviceID);
    
    
    return [NSString alloc];
    
}

- (BOOL)has_tfp0_over_HSP4 {
    kern_return_t kErr;
    mach_port_t tfp0;
    kErr = host_get_special_port(mach_host_self(), 0, 4, &tfp0);
    if (kErr == KERN_SUCCESS && MACH_PORT_VALID(tfp0)) {
        return true;
    }else{
        return false;
    }
}

- (BOOL)isInRoot {
    if (getuid() == 0) {
        return YES;
    }else{
        return NO;
    }
}


@end
