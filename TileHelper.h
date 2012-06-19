/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */


#import <Foundation/Foundation.h>

@interface TileHelper : NSObject
{
    UIImage *tileMap;
    NSData *tileData;
    CGSize tileSize;
}

@property (nonatomic, assign) CGSize tileSize;
@property (nonatomic, readonly) BOOL validTileSize;

+ (id) helperWithMap: (UIImage *) tileMap;
+ (NSData *) getBitmapFromImage: (UIImage *) anImage;
+ (UIImage *) imageWithBits: (unsigned char *) bits withSize: (CGSize) size;

- (NSArray *) proposedWidths;
- (NSArray *) proposedHeights;

- (uint) itemsPerRow;
- (uint) itemsPerColumn;
- (uint) numberOfTiles;

- (uint) lastFrame;

- (UIImage *) getFrameAtX: (uint) xFrame andY: (uint) yFrame;
- (UIImage *) getFrameNumber: (uint) frameNumber;
- (NSArray *) getFramesFrom: (uint) initialFrame to: (uint) finalFrame;
- (NSArray *) getAllFrames;
@end
