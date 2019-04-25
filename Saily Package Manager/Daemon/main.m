//
//  main.m
//  Daemon
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright (c) 2019 Lakr233. All rights reserved.
//

@import Foundation;

#include <spawn.h>

extern char **environ;

void run_cmd(char *cmd)
{
    pid_t pid;
    char *argv[] = {"sh", "-c", cmd, NULL};
    int status;
    
    status = posix_spawn(&pid, "/bin/sh", NULL, NULL, argv, environ);
    if (status == 0) {
        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid");
        }
    }
}

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSLog(@"Saily: respring");
    run_cmd("killall SpringBoard");
}

int main(int argc, char **argv, char **envp)
{
    NSLog(@"Saily: rootdaemond is launched!");
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, respring, CFSTR("com.Saily.respring"), NULL,         CFNotificationSuspensionBehaviorCoalesce);
    
    CFRunLoopRun(); // keep it running in background
    return 0;
}
