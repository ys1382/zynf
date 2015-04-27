#import <Foundation/Foundation.h>

#import "Setting.h"
#import "Action.h"

@interface Step : NSObject

+ (Step *)stepFrom:(Setting*)from to:(Setting*)to by:(Action*)action;

@property (strong, nonatomic) Setting *from;
@property (strong, nonatomic) Setting *to;
@property (strong, nonatomic) Action *by;

@end
