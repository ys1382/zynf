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

+ (Item*)itemWithName:(NSString*)_name numStates:(NSArray*)_numStates
{
    Item *item = [Item alloc];
    item.name = _name;
    item.numStates = _numStates;

    [[Item all] addObject:item];
    return item;
}

@end