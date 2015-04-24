#import <Foundation/Foundation.h>

#import "Setting.h"
#import "Action.h"
#import "State.h"


@implementation Setting

static NSMutableDictionary *allSettings;

+ (Setting *)settingWithValues:(NSDictionary *)values
{
    NSString *guid = [Setting guidFor:values];
    Setting *already;
    if ((already = [Setting existsFor:values])) {
        return already;
    }
    
    Setting *setting = [Setting alloc];
    setting.values = [NSMutableDictionary dictionaryWithDictionary:values];
    setting.links = [NSMutableDictionary dictionary];
    setting.index    = [NSNumber numberWithInt:(int)[[Setting all] count]];
    [allSettings setObject:setting forKey:guid];
    return setting;
}

+ (Setting*)existsFor:(NSDictionary *)values {
    NSString *g = [Setting guidFor:values];
    return [allSettings objectForKey:g];
}

- (NSString *)guid {
    return [Setting guidFor:self.values];
}

+ (void)printAll {
    for (Setting *setting in [Setting all]) {
        printf("%s\n", [[setting description] UTF8String]);
    }
}

// generate a few random settings
+ (void)generateSome:(int)howMany {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    while (howMany--)
    {
        for (Item *item in Item.all) // for all items
        {
            NSMutableDictionary *itemStates = [NSMutableDictionary dictionary];

            for (State *state in item.states) { // for all states

                u_int32_t bound = (u_int32_t)[state.values count];
                NSUInteger r = arc4random_uniform(bound);
                NSString *value = [state.values objectAtIndex:r];
                [itemStates setObject:value forKey:state.name];
            }

            Setting *setting = [Setting settingWithValues:itemStates];
            [result setObject:setting forKey:[Setting guidFor:setting.values]];
        }
    }

    allSettings = result;
}

+ (NSString *)guidFor:(NSDictionary *)values {
    return [NSString stringWithFormat:@"values=[%@]", values];
}

- (Setting*) perform:(Action*)action
{
    unsigned int numSettings = (unsigned int)[[Setting all] count];
    Setting *consequence = [[Setting all] objectAtIndex:arc4random_uniform(numSettings)];
    return consequence;
}

+ (void)linkThem
{
    for (Setting *setting in [Setting all])
    {
        for (Action *action in [Action all])
        {
            Setting *consequence = [setting perform:action];
            [setting.links setObject:[consequence index] forKey:[action index]];
        }
    }
}

+ (NSArray *)all
{
    if (allSettings == nil)
    {
        allSettings = [NSMutableDictionary dictionary];
    }
    return [allSettings allValues];
}

- (NSString *)description {
    NSString *result = [NSString stringWithFormat:@"Setting: values:%@ links:%@", self.values, self.links];
    return result;
}

@end