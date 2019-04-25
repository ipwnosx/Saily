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
- (NSData *)unGzip:(NSData *)data;
- (NSData *)unBzip:(NSData *)data;

- (void)ensureDaemonSocketAt:(NSInteger)port :(NSString *)client_session_token :(NSString *)server_session_token_save_place;

@end

#endif /* BridgerObjC_h */


