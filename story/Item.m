#include "Item.h"

@implementation Item

static NSMutableArray *allItems = nil;

+ (NSMutableArray *)all
{
    if (allItems == nil)
    {
        allItems = [NSMutableArray array];
    }
    return allItems;
}

+ (Item*)itemWithName:(NSString*)_name numStates:(NSDictionary*)_states
{
    Item *item = [Item alloc];
    item.name = _name;
    item.states = _states;

    [[Item all] addObject:item];
    return item;
}

@end