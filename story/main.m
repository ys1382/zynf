#import <Foundation/Foundation.h>

#import "Item.h"
#import "Setting.h"
#import "Action.h"
#import "Verb.h"
#import "Path.h"
#import "State.h"

/////// test

void test()
{

    NSString *(^marriage)(Setting*, Action*) = ^NSString *(Setting *setting, Action *action) {

        // one cannot marry oneself
        if ([action.subject.name isEqualToString:action.object.name]) {
            return nil;
        }
        
        // one cannot marry one's spouse
        if ([action.subject.values objectForKey:@"spouse"] == action.object.name) {
            return nil;
        }

        // one cannot marry if either party is dead - I feel like such a prude making these rules
        if (([action.subject.values objectForKey:@"dead"] != nil) ||
            ([action.object.values objectForKey:@"dead"] != nil)) {
            return nil;
        }
        
        setting = [setting copy];
        
        NSMutableDictionary *adam  = [setting.values objectForKey:action.subject.name];
        NSMutableDictionary *steve = [setting.values objectForKey:action.object.name];
        [adam setObject:action.object.name forKey:@"spouse"];
        [steve setObject:action.subject.name forKey:@"spouse"];

        return [setting guid];
    };
    
    NSString *(^murder)(Setting*, Action*) = ^NSString *(Setting *setting, Action *action) {

        // one cannot kill if either party is dead
        if (([action.subject.values objectForKey:@"dead"] != nil) ||
            ([action.object.values objectForKey:@"dead"] != nil)) {
            return nil;
        }
        
        setting = [setting copy];

        NSMutableDictionary *abel = [setting.values objectForKey:action.object.name];
        [abel setObject:@"as a doorknob" forKey:@"dead"];

        return [setting guid];
    };
    
    State *married = [State stateWithName:@"married" values:[NSArray arrayWithObjects:@"married",@"single",nil]];
    State *alive   = [State stateWithName:@"alive" values:[NSArray arrayWithObjects:@"alive",@"dead",nil]];
    
    [Item itemWithName:@"The Prince" states:[NSArray arrayWithObjects:married,alive,nil]];
    [Item itemWithName:@"The Princess" states:[NSArray arrayWithObjects:married,alive,nil]];
    [Item itemWithName:@"The Dragon" states:[NSArray arrayWithObjects:married,alive,nil]];
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
