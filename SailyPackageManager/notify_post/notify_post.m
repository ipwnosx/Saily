//
//  notify_post.m
//  notify_post
//
//  Created by Lakr Aream on 2019/4/15.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//


#import "notify_post.h"

@implementation thisObject

- (void)callNotify:(NSString *)withStr {
    const char *str = [withStr UTF8String];
    notify_post(str);
}


@end
