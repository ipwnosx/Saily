//
//  BridgerObjC.h
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/14.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BridgerObjC_h
#define BridgerObjC_h

@interface SailyCommonObject : NSObject

- (void)testCall;
- (void)callToDaemonWith:(NSString *)Str;
- (void)redirectConsoleLogToDocumentFolder;
- (void)doUDID:(NSString *)UDIDSavePath;

@end

#endif /* BridgerObjC_h */


