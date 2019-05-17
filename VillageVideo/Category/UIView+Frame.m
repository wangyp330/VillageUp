

#import "UIView+Frame.h"

@implementation UIView (Frame)



//set方法
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    
    frame.origin.x = x;
    
    self.frame = frame;
}

//get方法
- (CGFloat)x
{
    return self.frame.origin.x;
}


//set方法
- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    
    frame.origin.y = y;
    
    self.frame = frame;
}

//get方法
- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}


//set方法
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    
    frame.size.width = width;
    
    self.frame = frame;
}

//get方法
- (CGFloat)width
{
    return self.frame.size.width;
}


//set方法
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    
    frame.size.height = height;
    
    self.frame = frame;
}

//get方法
- (CGFloat)height
{
    return self.frame.size.height;
}


- (void)setMaxX:(CGFloat)MaxX {

    
}
// get方法
- (CGFloat)MaxY {
    
    return self.frame.size.height + self.y;
}

- (void)setMaxY:(CGFloat)MaxY {

}
//get方法
- (CGFloat)MaxX
{
    
    
    return self.frame.size.width + self.x;
}
@end
