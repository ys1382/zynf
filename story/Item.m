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

+ (Item*)itemWithName:(NSString*)_name states:(NSArray*)_states;
{
    Item *item = [Item alloc];
    item.name = _name;
    item.states = _states;
    item.values = [NSMutableDictionary dictionary];

    [[Item all] addObject:item];
    return item;
}

@end