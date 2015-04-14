#ifndef story_Verb_h
#define story_Verb_h

@interface Verb : NSObject

@property (strong, nonatomic) NSString *name;

+ (Verb *)verbWithName:(NSString *)name;
+ (NSMutableArray *)all;

@end

#endif
