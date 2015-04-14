#import <Foundation/Foundation.h>

#import "Item.h"
#import "Setting.h"
#import "Action.h"
#import "Verb.h"
#import "Path.h"

/////// test

void test()
{
    [Item itemWithName:@"Alice" numStates:@[@2, @3]];
    [Item itemWithName:@"Bob" numStates:@[@4, @5, @6]];
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
