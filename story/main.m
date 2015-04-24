#import <Foundation/Foundation.h>

#import "Item.h"
#import "Setting.h"
#import "Action.h"
#import "Verb.h"
#import "Path.h"

/////// test

void test()
{

    NSString *(^marriage)(Setting*, Action*) = ^NSString *(Setting *setting, Action *action) {

        // one cannot marry one's spouse
        if ([action.subject.states objectForKey:@"spouse"] == action.object.name)
            return nil;

        // one cannot marry if either party is dead
        if (([action.subject.states objectForKey:@"alive"] == nil) ||
            ([action.object.states objectForKey:@"alive"] == nil))
            return nil;
        
        setting = [setting copy];
        
        NSMutableDictionary *adam  = [setting.values objectForKey:action.subject.name];
        NSMutableDictionary *steve = [setting.values objectForKey:action.object.name];
        [adam setObject:action.object.name forKey:@"spouse"];
        [steve setObject:action.subject.name forKey:@"spouse"];

        return [setting guid];
    };
    
    NSString *(^murder)(Setting*, Action*) = ^(Setting *setting, Action *action) {
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
