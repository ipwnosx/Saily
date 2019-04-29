//
//  main.m
//  Daemon
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright (c) 2019 Lakr233. All rights reserved.
//

// http://walfield.org/pub/people/neal/papers/hurd-misc/ipc-hello.c

@import Foundation;

#include <spawn.h>
#include <mach/mach.h>

// DONT USE MACH MSG BECAUSE I DONT WANT ANY KERNEL PANIC

int port = 0;
NSString *session_token = @"";
NSString *saily_root    = @"";

extern char **environ;
void run_cmd(char *cmd)
{
    pid_t pid;
    char *argv[] = {"sh", "-c", cmd, NULL, NULL};
    int status;
    
    status = posix_spawn(&pid, "/bin/sh", NULL, NULL, argv, environ);
    if (status == 0) {
        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid");
        }
    }
}
static void fix_permission()
{
    NSString *com = [[NSString alloc] initWithFormat:@"chmod -R 0777 %@/daemon.call", saily_root];
    run_cmd([com UTF8String]);
    com = [[NSString alloc] initWithFormat:@"chown -R 501:501 %@/daemon.call", saily_root];
    run_cmd([com UTF8String]);
}

NSString *read_data_with_url(NSString *url) { // making a GET request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __block NSString *read_data;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSLog(@"Data received: %@", myString);
          read_data = myString;
          dispatch_semaphore_signal(sema);
      }] resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return read_data;
}

static void send_message_to_Saily(NSString *msg) { // making a POST request to /init
    NSString *targetUrl = [NSString stringWithFormat:@"http://127.0.0.1:%d/daemoncallback", port];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //Make an NSDictionary that would be converted to an NSData object sent over as JSON with the request body
    NSError *error;
    NSData *postData = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:targetUrl]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSLog(@"Data received: %@", responseStr);
      }] resume];
}

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSLog(@"Saily: respring");
    run_cmd("killall SpringBoard");
}
static void add_port_1(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    port = port * 10 + 1;
}
static void add_port_2(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    port = port * 10 + 2;
}
static void add_port_3(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    port = port * 10 + 3;
}
static void add_port_4(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    port = port * 10 + 4;
}
static void add_port_5(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    port = port * 10 + 5;
}
static void add_port_6(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    port = port * 10 + 6;
}
static void add_port_7(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    port = port * 10 + 7;
}
static void add_port_8(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    port = port * 10 + 8;
}
static void add_port_9(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    port = port * 10 + 9;
}
static void add_port_0(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    port = port * 10 + 0;
}
static void begin_port(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    port = 0;
}
static void end_port(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef uslauncherInfo)
{
    NSLog(@"[*] End reading port with result %d", port);
    usleep(50000);
    session_token = read_data_with_url([[NSString alloc] initWithFormat: @"http://127.0.0.1:%d/session_token_query", port]);
    NSLog(@"[*] End reading session token with result %@", session_token);
    NSString *sendback = [[NSString alloc] initWithFormat:@"[*] Received session token: |%@|", session_token];
    send_message_to_Saily(sendback);
    saily_root = read_data_with_url([[NSString alloc] initWithFormat: @"http://127.0.0.1:%d/sandbox_location_query", port]);
}
static void run_command(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSString *com = [[NSString alloc] initWithContentsOfFile:[[NSString alloc]initWithFormat:@"%@/queue.submit/command", saily_root] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"[*] End reading command with result %@", com);
    NSLog(@"[E] Run command notify is deprecated.");
    //    run_cmd([com UTF8String]);
}
static void list_dpkg(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSString *com = [[NSString alloc] initWithFormat:@"dpkg -l &> %@/daemon.call/dpkgl.out", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    fix_permission();
}
static void apt_install_list(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSLog(@"[*] APT is not working. use dpkg instead.");
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSArray *dirContents = [fm contentsOfDirectoryAtPath:[[NSString alloc] initWithFormat: @"%@/queue.submit/install.submit/", saily_root] error:nil];
//    NSString *cmd_files = @"";
//    for (int i = 0; i < [dirContents count]; i ++) {
//        cmd_files = [cmd_files stringByAppendingString:@" "];
//        cmd_files = [cmd_files stringByAppendingString:saily_root];
//        cmd_files = [cmd_files stringByAppendingString:@"/"];
//        cmd_files = [cmd_files stringByAppendingString: dirContents[i]];
//    }
//    NSString *com = [[NSString alloc] initWithFormat:@"apt-get --allow-unauthenticated --just-print install %@ &> %@/daemon.call/install.list", cmd_files, saily_root];
//    NSLog(@"[*] End reading command with result %@", com);
//    run_cmd([com UTF8String]);
//    fix_permission();
}
static void dpkg_install_perform(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:[[NSString alloc] initWithFormat: @"%@/queue.submit/install.submit/", saily_root] error:nil];
    NSString *cmd_files = @"";
    for (int i = 0; i < [dirContents count]; i ++) {
        cmd_files = [cmd_files stringByAppendingString:@" "];
        cmd_files = [cmd_files stringByAppendingString:saily_root];
        cmd_files = [cmd_files stringByAppendingString:@"/queue.submit/install.submit/"];
        cmd_files = [cmd_files stringByAppendingString: dirContents[i]];
    }
    NSString *com = [[NSString alloc] initWithFormat:@"dpkg -i %@ &>> %@/daemon.call/cmd.out", cmd_files, saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    com = [[NSString alloc] initWithFormat:@"echo \"SAILY_DONE\" &>> %@/daemon.call/status", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    fix_permission();
}
static void apt_remove_list(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    // 获取文件地址
    NSString *path = [[NSString alloc] initWithFormat:@"%@/queue.submit/removes.submit", saily_root];
    NSLog(@"[*] Read from: %@", path);
    // 将文件用cp拷贝到我们能读取的地方
    NSString *cpcmd = [[NSString alloc] initWithFormat:@"cp %@/queue.submit/removes.submit /var/root/", saily_root];
    run_cmd([cpcmd UTF8String]);
    NSString *list_str = [NSString stringWithContentsOfFile:@"/var/root/removes.submit" encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"[*] Read with result: %@", list_str);
    NSArray *packages = [list_str componentsSeparatedByString:@"\n"];
    NSString *cmd_files = @"";
    for (int i = 0; i < [packages count]; i ++) {
        cmd_files = [cmd_files stringByAppendingString:@" "];
        cmd_files = [cmd_files stringByAppendingString: packages[i]];
        NSLog(@"[*] Add a package: %@", packages[i]);
    }
    NSLog(@"[*] Package Array STR: %@", cmd_files);
    NSString *com = [[NSString alloc] initWithFormat:@"apt-get --allow-unauthenticated --just-print remove %@ &>> %@/daemon.call/cmd.out", cmd_files, saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    com = [[NSString alloc] initWithFormat:@"echo \"SAILY_DONE\" &>> %@/daemon.call/status", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
        run_cmd([com UTF8String]);
    fix_permission();
}
static void apt_remove_perform(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    // 获取文件地址
    NSString *path = [[NSString alloc] initWithFormat:@"%@/queue.submit/removes.submit", saily_root];
    NSLog(@"[*] Read from: %@", path);
    // 将文件用cp拷贝到我们能读取的地方
    NSString *cpcmd = [[NSString alloc] initWithFormat:@"cp %@/queue.submit/removes.submit /var/root/", saily_root];
    run_cmd([cpcmd UTF8String]);
    NSString *list_str = [NSString stringWithContentsOfFile:@"/var/root/removes.submit" encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"[*] Read with result: %@", list_str);
    NSArray *packages = [list_str componentsSeparatedByString:@"\n"];
    NSString *cmd_files = @"";
    for (int i = 0; i < [packages count]; i ++) {
        cmd_files = [cmd_files stringByAppendingString:@" "];
        cmd_files = [cmd_files stringByAppendingString: packages[i]];
        NSLog(@"[*] Add a package: %@", packages[i]);
    }
    NSLog(@"[*] Package Array STR: %@", cmd_files);
    NSString *com = [[NSString alloc] initWithFormat:@"apt-get --allow-unauthenticated -y remove %@ &>> %@/daemon.call/cmd.out", cmd_files, saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    com = [[NSString alloc] initWithFormat:@"echo \"SAILY_DONE\" &>> %@/daemon.call/status", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    fix_permission();
}
static void apt_autoremove_list(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSString *com = [[NSString alloc] initWithFormat:@"apt-get --allow-unauthenticated --just-print  auto-remove &>> %@/daemon.call/cmd.out", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    com = [[NSString alloc] initWithFormat:@"echo \"SAILY_DONE\" &>> %@/daemon.call/status", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    fix_permission();
}
static void apt_autoremove_perform(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSString *com = [[NSString alloc] initWithFormat:@"apt-get --allow-unauthenticated -y auto-remove &>> %@/daemon.call/cmd.out", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    com = [[NSString alloc] initWithFormat:@"echo \"SAILY_DONE\" &>> %@/daemon.call/status", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    fix_permission();
}

int main(int argc, char **argv, char **envp)
{
    NSLog(@"Saily: rootdaemond is launched!");
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, respring, CFSTR("com.Saily.respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_port_1, CFSTR("com.Saily.addport_1"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_port_2, CFSTR("com.Saily.addport_2"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_port_3, CFSTR("com.Saily.addport_3"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_port_4, CFSTR("com.Saily.addport_4"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_port_5, CFSTR("com.Saily.addport_5"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_port_6, CFSTR("com.Saily.addport_6"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_port_7, CFSTR("com.Saily.addport_7"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_port_8, CFSTR("com.Saily.addport_8"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_port_9, CFSTR("com.Saily.addport_9"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_port_0, CFSTR("com.Saily.addport_0"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, begin_port, CFSTR("com.Saily.begin_port"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, end_port, CFSTR("com.Saily.end_port"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, run_command, CFSTR("com.Saily.run_command"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, list_dpkg, CFSTR("com.Saily.list_dpkg"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, dpkg_install_perform, CFSTR("com.Saily.dpkg.install.perform"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, apt_remove_list, CFSTR("com.Saily.apt.remove.list"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, apt_remove_perform, CFSTR("com.Saily.apt.remove.perform"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, apt_autoremove_list, CFSTR("com.Saily.apt.autoremove.list"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, apt_autoremove_perform, CFSTR("com.Saily.apt.autoremove.perform"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    
    CFRunLoopRun(); // keep it running in background
    return 0;
}
