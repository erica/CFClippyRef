/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 
 Tile image via http://www.smore.com/clippy-js, in turn
 whose MIT licensing points out that 
 
 "All Microsoft agents, including agent names, the Clippy
 brand and all resources are the property of Microsoft and 
 their respective owners."
 */


#import <Foundation/Foundation.h>
#import "TileHelper.h"

@interface ClippyHelper : NSObject
{
    TileHelper *helper;
    NSDictionary *animations;
}

@property (nonatomic, readonly) NSDictionary *animations;

+ (id) helper;
- (UIImageView *) baseImageView;
- (NSArray *) animationNames;
- (UIImageView *) animationNamed: (NSString *) aName repeats: (BOOL) yorn;
- (NSArray *) animationSequenceNamed: (NSString *) aName;
- (void) addAnimation: (NSString *) aName to: (UIImageView *) aView repeats: (BOOL) yorn;
@end
