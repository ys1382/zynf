#import <Foundation/Foundation.h>

#import "Setting.h"
#import "Action.h"


@implementation Setting

static NSMutableDictionary *allSettings;

+ (Setting *)settingWithValues:(NSArray *)values
{
    NSString *guid = [Setting guidFor:values];
    Setting *already;
    if ((already = [Setting existsFor:values])) {
        return already;
    }
    
    Setting *setting = [Setting alloc];
    setting.values = [NSMutableArray arrayWithArray:values];
    setting.links = [NSMutableDictionary dictionary];
    setting.index    = [NSNumber numberWithInt:(int)[[Setting all] count]];
    [allSettings setObject:setting forKey:guid];
    return setting;
}

+ (Setting*)existsFor:(NSArray *)values {
    NSString *g = [Setting guidFor:values];
    return [allSettings objectForKey:g];
}

+ (void)printAll {
    for (Setting *setting in [Setting all]) {
        printf("%s\n", [[setting description] UTF8String]);
    }
}

+ (void)generateSome:(int)howMany {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    while (howMany--)
    {
        for (Item *item in Item.all)
        {
            NSMutableArray *itemStates = [NSMutableArray arrayWithCapacity:item.numStates.count];
            for (int i=0; i<item.numStates.count; i++)
            {
                u_int32_t bound = (u_int32_t)[item.numStates[i] unsignedIntegerValue];
                NSUInteger r = arc4random_uniform(bound);
                [itemStates addObject:[NSNumber numberWithUnsignedLong:r]];
            }
            Setting *setting = [Setting settingWithValues:itemStates];
//            [result addObject:setting];
            [result setObject:setting forKey:[Setting guidFor:setting.values]];
        }
    }

    allSettings = result;
}

+ (NSString *)guidFor:(NSArray *)values {
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