//
//  SetCardView.m
//  Matchismo
//
//  Created by Kunal Jathal on 1/23/15.
//  Copyright (c) 2015 Kunal Jathal. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma mark - Properties

- (void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)shape
{
    _shape = shape;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setChosen:(BOOL)chosen
{
    _chosen = chosen;
    [self setNeedsDisplay];
}




#pragma mark - Drawing

#define CORNER_RADIUS 0.1
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:self.bounds.size.width * CORNER_RADIUS];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    if (self.chosen) {
        [[UIColor blueColor] setStroke];
        roundedRect.lineWidth *= 2.0;
    } else {
        [[UIColor colorWithWhite:0.8 alpha:1.0] setStroke];
        roundedRect.lineWidth /= 2.0;
    }
    [roundedRect stroke];
    
    [self drawSymbols];
}

#define SYMBOL_OFFSET 0.2;
#define SYMBOL_LINE_WIDTH 0.02;

- (void)drawSymbols
{
    [[self uiColor] setStroke];
    CGPoint point = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    if (self.number == 1) {
        [self drawSymbolAtPoint:point];
        return;
    }
    CGFloat dx = self.bounds.size.width * SYMBOL_OFFSET;
    if (self.number == 2) {
        [self drawSymbolAtPoint:CGPointMake(point.x - dx / 2.0, point.y)];
        [self drawSymbolAtPoint:CGPointMake(point.x + dx / 2.0, point.y)];
        return;
    }
    if (self.number == 3) {
        [self drawSymbolAtPoint:point];
        [self drawSymbolAtPoint:CGPointMake(point.x - dx, point.y)];
        [self drawSymbolAtPoint:CGPointMake(point.x + dx, point.y)];
        return;
    }
}

- (UIColor *)uiColor
{
    if ([self.color isEqualToString:@"red"]) return [UIColor redColor];
    if ([self.color isEqualToString:@"green"]) return [UIColor greenColor];
    if ([self.color isEqualToString:@"purple"]) return [UIColor purpleColor];
    return nil;
}

- (void)drawSymbolAtPoint:(CGPoint)point
{
    if ([self.shape isEqualToString:@"oval"]) [self drawOvalAtPoint:point];
    else if ([self.shape isEqualToString:@"squiggle"]) [self drawSquiggleAtPoint:point];
    else if ([self.shape isEqualToString:@"diamond"]) [self drawDiamondAtPoint:point];
}

#define OVAL_WIDTH 0.12
#define OVAL_HEIGHT 0.4

- (void)drawOvalAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * OVAL_WIDTH / 2.0;
    CGFloat dy = self.bounds.size.height * OVAL_HEIGHT / 2.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x - dx, point.y - dy, 2.0 * dx, 2.0 * dy)
                                                    cornerRadius:dx];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define SQUIGGLE_WIDTH 0.12
#define SQUIGGLE_HEIGHT 0.3
#define SQUIGGLE_FACTOR 0.8

- (void)drawSquiggleAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * SQUIGGLE_WIDTH / 2.0;
    CGFloat dy = self.bounds.size.height * SQUIGGLE_HEIGHT / 2.0;
    CGFloat dsqx = dx * SQUIGGLE_FACTOR;
    CGFloat dsqy = dy * SQUIGGLE_FACTOR;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x - dx, point.y - dy)];
    [path addQuadCurveToPoint:CGPointMake(point.x + dx, point.y - dy)
                 controlPoint:CGPointMake(point.x - dsqx, point.y - dy - dsqy)];
    [path addCurveToPoint:CGPointMake(point.x + dx, point.y + dy)
            controlPoint1:CGPointMake(point.x + dx + dsqx, point.y - dy + dsqy)
            controlPoint2:CGPointMake(point.x + dx - dsqx, point.y + dy - dsqy)];
    [path addQuadCurveToPoint:CGPointMake(point.x - dx, point.y + dy)
                 controlPoint:CGPointMake(point.x + dsqx, point.y + dy + dsqy)];
    [path addCurveToPoint:CGPointMake(point.x - dx, point.y - dy)
            controlPoint1:CGPointMake(point.x - dx - dsqx, point.y + dy - dsqy)
            controlPoint2:CGPointMake(point.x - dx + dsqx, point.y - dy + dsqy)];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define DIAMOND_WIDTH 0.15
#define DIAMOND_HEIGHT 0.4

- (void)drawDiamondAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * DIAMOND_WIDTH / 2.0;
    CGFloat dy = self.bounds.size.height * DIAMOND_HEIGHT / 2.0;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x, point.y - dy)];
    [path addLineToPoint:CGPointMake(point.x + dx, point.y)];
    [path addLineToPoint:CGPointMake(point.x, point.y + dy)];
    [path addLineToPoint:CGPointMake(point.x - dx, point.y)];
    [path closePath];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define STRIPES_OFFSET 0.06
#define STRIPES_ANGLE 5

- (void)shadePath:(UIBezierPath *)path
{
    if ([self.shading isEqualToString:@"solid"]) {
        [[self uiColor] setFill];
        [path fill];
    } else if ([self.shading isEqualToString:@"striped"]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [path addClip];
        UIBezierPath *stripes = [[UIBezierPath alloc] init];
        CGPoint start = self.bounds.origin;
        CGPoint end = start;
        CGFloat dy = self.bounds.size.height * STRIPES_OFFSET;
        end.x += self.bounds.size.width;
        start.y += dy * STRIPES_ANGLE;
        for (int i = 0; i < 1 / STRIPES_OFFSET; i++) {
            [stripes moveToPoint:start];
            [stripes addLineToPoint:end];
            start.y += dy;
            end.y += dy;
        }
        stripes.lineWidth = self.bounds.size.width / 2 * SYMBOL_LINE_WIDTH;
        [stripes stroke];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    } else if ([self.shading isEqualToString:@"open"]) {
        [[UIColor clearColor] setFill];
    }
}

/*

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if (self.chosen) {
        [[UIColor redColor] setStroke];
        roundedRect.lineWidth *= 4.0;
    } else {
        [[UIColor colorWithWhite:0.8 alpha:1.0] setStroke];
        roundedRect.lineWidth /= 4.0;
    }
    
    [roundedRect stroke];
    
    [[self setAlong] drawInRect:self.bounds];
    [self makeAsquare];
    
    
    
}


- (void)makeAsquare
{
    // First, let's define the rect inside which we want to draw our circle. It's basically a rect inset thats say 50% of the card view itself.
    
    CGRect rectToDrawIn = CGRectInset(self.bounds, self.bounds.size.width * 0.45, self.bounds.size.height * 0.45);
    
    UIBezierPath *aPath = [UIBezierPath bezierPathWithOvalInRect:
                           rectToDrawIn];
    
    // Set the render colors.
    [[UIColor redColor] setStroke];
    [[UIColor redColor] setFill];
    
    //CGContextRef aRef = UIGraphicsGetCurrentContext();
    
    // If you have content to draw after the shape,
    // save the current state before changing the transform.
    //CGContextSaveGState(aRef);
    
    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    //CGContextTranslateCTM(aRef, 50, 50);
    
    // Adjust the drawing options as needed.
    aPath.lineWidth = 1;
    
    // Fill the path before stroking it so that the fill
    // color does not obscure the stroked line.
    [aPath fill];
    [aPath stroke];
    
    // Restore the graphics state before drawing any other content.
    //CGContextRestoreGState(aRef);
}

- (NSAttributedString *)setAlong
{
        NSString *shape = @"?";
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    
        // Convert the string shape to the actual shape
        if ([self.shape isEqualToString:@"circle"]) shape = @"●";
        if ([self.shape isEqualToString:@"triangle"]) shape = @"▲";
        if ([self.shape isEqualToString:@"square"]) shape = @"■";
        
        // The 'number' in a set card is simply the number of times the shape appears
        shape = [shape stringByPaddingToLength:self.number
                                    withString:shape
                               startingAtIndex:0];
        
        // Convert the color string to the actual color. Note that we are just adding the color to a dictionary of attributes, that we will later apply to the string. The attribute we are using is simply NSForegroundColorAttributeName.
        if ([self.color isEqualToString:@"red"])
            [attributes setObject:[UIColor redColor]
                           forKey:NSForegroundColorAttributeName];
        if ([self.color isEqualToString:@"green"])
            [attributes setObject:[UIColor greenColor]
                           forKey:NSForegroundColorAttributeName];
        if ([self.color isEqualToString:@"purple"])
            [attributes setObject:[UIColor purpleColor]
                           forKey:NSForegroundColorAttributeName];
        
        // Repeat the process for the shading. Attribute is NSStrokeWidthAttributeName.
        if ([self.shading isEqualToString:@"solid"])
            [attributes setObject:@-5
                           forKey:NSStrokeWidthAttributeName];
        if ([self.shading isEqualToString:@"striped"])
            [attributes addEntriesFromDictionary:@{
                                                   NSStrokeWidthAttributeName : @-5,
                                                   NSStrokeColorAttributeName : attributes[NSForegroundColorAttributeName],
                                                   NSForegroundColorAttributeName : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.1]
                                                   }];
        if ([self.shading isEqualToString:@"open"])
            [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
    
        return [[NSMutableAttributedString alloc] initWithString:shape
                                                  attributes:attributes];
}

*/



#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}


@end
