#import <Foundation/Foundation.h>

#import "Item.h"
#import "Setting.h"
#import "Action.h"
#import "Verb.h"
#import "Path.h"

/////// test

void test()
{
    [Item itemWithName:@"The Prince" numStates:@[@2, @2]];
    [Item itemWithName:@"The Princess" numStates:@[@2]];
    [Item itemWithName:@"The Dragon" numStates:@[@2, @2]];
    [Verb verbWithName:@"married"];
    [Verb verbWithName:@"killed"];

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
