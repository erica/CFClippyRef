/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */


#import "TileHelper.h"

@implementation TileHelper

BOOL floatEqual(CGFloat a, CGFloat b)
{
	return (fabs(a-b) < FLT_EPSILON);
}

- (BOOL) validTileSize
{
    if (tileSize.width < 1.0f) return NO;
    if (tileSize.height < 1.0f) return NO;

    uint width = (int) tileMap.size.width;
    uint height = (int) tileMap.size.height;
    
    uint tileWidth = (int) tileSize.width;
    uint tileHeight = (int) tileSize.height;
    
    uint nWide = width / tileWidth;
    uint nHigh = height / tileHeight;
    
    if (!(floatEqual(tileMap.size.width, (float) tileWidth * nWide)))
        return NO;
    
    if (!(floatEqual(tileMap.size.height, (float) tileHeight * nHigh)))
        return NO;
    
    return YES;
}

- (CGSize) tileSize
{
    return tileSize;
}

- (void) setTileSize:(CGSize)aTileSize
{
    tileSize = aTileSize;
    if ([self validTileSize]) return;
    tileSize = CGSizeZero;
}

- (NSArray *) proposedWidths
{
    uint width = (int) tileMap.size.width;

    NSMutableArray *results = [NSMutableArray array];
    for (int i = 2; i <= width; i++)
    {
        uint tileWidth = width / i;
        CGFloat test = (float) (tileWidth * i);

        if (floatEqual(tileMap.size.width, test))
            [results addObject:[NSNumber numberWithInt:i]];
    }
    
    return results;
}

- (NSArray *) proposedHeights
{
    uint height = (int) tileMap.size.height;
    
    NSMutableArray *results = [NSMutableArray array];
    for (int i = 2; i <= height; i++)
    {
        uint tileHeight = height / i;
        CGFloat test = (float) (tileHeight * i);
        
        if (floatEqual(tileMap.size.height, test))
            [results addObject:[NSNumber numberWithInt:i]];
    }
    
    return results;
}


- (UIImage *) getFrameAtX: (uint) xFrame andY: (uint) yFrame
{
    if (CGSizeEqualToSize(CGSizeZero, tileSize)) return nil;
    
    // NSLog(@"Fetching Frame at (%d, %d)", xFrame, yFrame);
    
    uint sideX = (int) tileSize.width;
    uint sideY = (int) tileSize.height;
    uint width = tileMap.size.width;
    
    // Retrieve the raw bytes
    Byte *data = (Byte *)tileData.bytes;
    uint length = tileData.length;
    
    // Create an output frame
    Byte *frame = malloc(sideX * sideY * 4);
    
    uint baseOffset = 0;
    for (uint y = 0; y < sideY; y++)
        for (uint x = 0; x < sideX; x++)
        {
            uint dataInset = (yFrame * sideY + y) * width * 4 + (xFrame * sideX + x) * 4;
            for (int byteOffset = 0; byteOffset < 4; byteOffset++)
            {
                if (!((dataInset + byteOffset) < length))
                    continue;
                
                if (baseOffset >= sideX * sideY * 4)
                    continue;

                frame[baseOffset] = data[dataInset + byteOffset];
                baseOffset++;
            }
        }
    
    UIImage *img = [TileHelper imageWithBits:frame withSize:CGSizeMake(sideX, sideY)];
    return img;
}

- (uint) itemsPerRow
{
    uint width = tileMap.size.width;
    return width / tileSize.width;
}

- (uint) itemsPerColumn
{
    uint height = tileMap.size.height;
    return height / tileSize.height;
}

- (uint) numberOfTiles
{
    return [self itemsPerRow] * [self itemsPerColumn];
}

- (uint) lastFrame
{
    return [self numberOfTiles] - 1;
}

- (BOOL) validFrame: (uint) frameNumber
{
     return (frameNumber < [self numberOfTiles]);
}

- (UIImage *) getFrameNumber: (uint) frameNumber
{
    if (CGSizeEqualToSize(CGSizeZero, tileSize)) return nil;
    if (![self validFrame:frameNumber]) return nil;
    
    // NSLog(@"Fetching Frame #%d", frameNumber);
    
    // This method does not check for valid widths
    uint width = tileMap.size.width;
    uint itemsPerRow = width / tileSize.width;
    
    uint x = frameNumber % itemsPerRow;
    uint y = frameNumber / itemsPerRow;
    
    return [self getFrameAtX:x andY:y];
}

// Frames are numbered from 0 to rowItems * colItems - 1
- (NSArray *) getFramesFrom: (uint) initialFrame to: (uint) finalFrame
{
    if (CGSizeEqualToSize(CGSizeZero, tileSize)) return nil;
    if (![self validFrame:initialFrame]) return nil;
    if (![self validFrame:finalFrame]) return nil;
    
    NSMutableArray *array = [NSMutableArray array];
    BOOL ascending = (initialFrame <= finalFrame);
    int dI = ascending ? 1 : -1;

    for (int i = initialFrame; i <= finalFrame; i += dI)
    {
        UIImage *anImage = [self getFrameNumber:i];
        if (anImage)
            [array addObject:anImage];
    }
    
    return array;
}

- (NSArray *) getAllFrames
{
    if (CGSizeEqualToSize(CGSizeZero, tileSize)) return nil;
    return [self getFramesFrom:0 to: [self lastFrame]];
}

- (id) initWithMap: (UIImage *) aTileMap
{
    if (!(self = [super init])) return self;
    
    tileMap = aTileMap;
    tileData = [TileHelper getBitmapFromImage: aTileMap];
    tileSize = CGSizeZero;
    
    return self;
}

+ (id) helperWithMap: (UIImage *) tileMap
{
    TileHelper *helper = [[TileHelper alloc] initWithMap:tileMap];
    
    // NSLog(@"Proposed Widths:  %@", [helper proposedWidths]);
    // NSLog(@"Proposed Heights: %@", [helper proposedHeights]);

    return helper;
}

// Return a byte array of image
+ (NSData *) getBitmapFromImage: (UIImage *) anImage
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
	
	CGSize size = anImage.size;
	Byte *bitmapData = calloc(size.width * size.height * 4, 1); // Courtesy of Dirk. Thanks!
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Error: Memory not allocated!");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
	
    CGContextRef context = CGBitmapContextCreate (bitmapData, size.width, size.height, 8, size.width * 4, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace );
    if (context == NULL)
    {
        fprintf (stderr, "Error: Context not created!");
        free (bitmapData);
		return NULL;
    }
	
	CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
	CGContextDrawImage(context, rect, anImage.CGImage);
	Byte *data = CGBitmapContextGetData(context);
	CGContextRelease(context);
    
    NSData *bytes = [NSData dataWithBytes:data length:size.width * size.height * 4];
    free(bitmapData);
	
    return bytes;
}

+ (UIImage *) imageWithBits: (unsigned char *) bits withSize: (CGSize) size
{
	// Create a color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
		free(bits);
        return nil;
    }
	
    CGContextRef context = CGBitmapContextCreate (bits, size.width, size.height, 8, size.width * 4, colorSpace, kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        fprintf (stderr, "Error: Context not created!");
        free (bits);
		CGColorSpaceRelease(colorSpace );
		return nil;
    }
	
    CGColorSpaceRelease(colorSpace );
	CGImageRef ref = CGBitmapContextCreateImage(context);
	free(CGBitmapContextGetData(context));
	CGContextRelease(context);
	
	UIImage *img = [UIImage imageWithCGImage:ref];
	CFRelease(ref);
	return img;
}
@end
