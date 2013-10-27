//     THE ORIGINAL CODE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
/*
 #import <UIKit/UIKit.h>
 
 #import "AppDelegate.h"
 
 int main(int argc, char *argv[])
 {
 @autoreleasepool {
 return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
 }
 }
 
 */

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#pragma mark - console output cleaning

typedef int (*PYStdWriter)(void *, const char *, int);
static PYStdWriter _oldStdWrite;

int __pyStderrWrite(void *inFD, const char *buffer, int size)
{
    if ( strncmp(buffer, "AssertMacros:", 13) == 0 ) {
        return 0;
    }
    return _oldStdWrite(inFD, buffer, size);
}

void __iOS7B5CleanConsoleOutput()
{
    _oldStdWrite = stderr->_write;
    stderr->_write = __pyStderrWrite;
}

#pragma mark - application start

int main(int argc, char *argv[])

{
#warning REMOVE BEFORE FLIGHT - disables AssertMacros flood in console in XCode beta 5
    __iOS7B5CleanConsoleOutput();
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}