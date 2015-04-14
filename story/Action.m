#import <Foundation/Foundation.h>

#import "Action.h"
#import "Item.h"


@implementation Action


static NSMutableArray *allActions;


+ (Action*) actionWithSubject:(Item*)subject object:(Item*)object verb:(Verb*)verb
{
    Action *action = [Action alloc];

    action.subject  = subject;
    action.object   = object;
    action.verb     = verb;
    action.index    = [NSNumber numberWithInt:(int)[[Action all] count]];
    [[Action all] addObject:action];

    return action;
}

+ (NSArray*) generateSome:(NSUInteger)howMany
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:howMany];
    while (howMany--)
    {
        unsigned int numItems = (unsigned int)[[Item all] count];
        unsigned int numVerbs = (unsigned int)[[Verb all] count];

        Item *subject   = [[Item all] objectAtIndex:arc4random_uniform(numItems)];
        Item *object    = [[Item all] objectAtIndex:arc4random_uniform(numItems)];
        Verb *verb      = [[Verb all] objectAtIndex:arc4random_uniform(numVerbs)];

        [result addObject:[Action actionWithSubject:subject object:object verb:verb]];
    }

    return result;
}

+ (NSMutableArray *)all
{
    if (allActions == nil)
    {
        allActions = [NSMutableArray array];
    }
    return allActions;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@", self.subject.name, self.verb.name, self.object.name];
}


@end
