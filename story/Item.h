#ifndef story_Item_h
#define story_Item_h

#import <Foundation/Foundation.h>

/////// Item

@interface Item : NSObject

@property (strong, nonatomic) NSString *name;
//@property (strong, nonatomic) NSArray *numStates;
@property (strong, nonatomic) NSArray *states;
@property (strong, nonatomic) NSMutableDictionary *values;

+ (Item*)itemWithName:(NSString*)name states:(NSArray*)states;
+ (NSMutableArray*)all;


@end

#endif
