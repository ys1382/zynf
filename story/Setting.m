#import <Foundation/Foundation.h>

#import "Setting.h"
#import "Action.h"


@implementation Setting

static NSMutableArray *allSettings;

+ (Setting *)settingWithValues:(NSArray *)values
{
    Setting *setting = [Setting alloc];
    setting.values = [NSMutableArray arrayWithArray:values];
    setting.links = [NSMutableDictionary dictionary];
    setting.index    = [NSNumber numberWithInt:(int)[[Setting all] count]];
    [[Setting all] addObject:setting];
    return setting;
}

+ (NSArray*)generateSome:(int)howMany
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:howMany];
    
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
            [result addObject:setting];
        }
    }

    return result;
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

+ (NSMutableArray *)all
{
    if (allSettings == nil)
    {
        allSettings = [NSMutableArray array];
    }
    return allSettings;
}

- (NSString *)description {
    NSString *result = [NSString stringWithFormat:@"Setting: values:%@ links:%@", self.values, self.links];
    return result;
}

@end