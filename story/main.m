#import <Foundation/Foundation.h>

#import "Item.h"
#import "Setting.h"
#import "Action.h"
#import "Verb.h"
#import "Path.h"

/////// test

void test()
{

    NSString *(^marriage)(Setting *) = ^(Setting *setting) {
        return @"z";
    };
    
    NSString *(^murder)(Setting *) = ^(Setting *setting) {
        return @"z";
    };
    
    [Item itemWithName:@"The Prince" numStates:@[@2, @2]];
    [Item itemWithName:@"The Princess" numStates:@[@2]];
    [Item itemWithName:@"The Dragon" numStates:@[@2, @2]];
    [Verb verbWithName:@"married" does:marriage];
    [Verb verbWithName:@"killed" does:murder];

    [Setting generateSome:3];

    [Action generateSome:2];
    [Setting linkThem];
    [Path generateAll];
    
    NSString *story = [Path tell];
    printf("%s", [story UTF8String]);
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {

        test();

    }
    return 0;
}
