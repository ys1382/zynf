#ifndef story_Item_h
#define story_Item_h

#import <Foundation/Foundation.h>

/////// Item

@interface Item : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *numStates;

+ (Item*)itemWithName:(NSString*)name numStates:(NSArray*)numStates;
+ (NSMutableArray*)all;


@end

#endif
