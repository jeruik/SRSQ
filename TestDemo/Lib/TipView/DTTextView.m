//
//  DTTextView.m
//  Cinderella
//
//  Created by mac on 15/5/30.
//  Copyright (c) 2015年 cloudstruct. All rights reserved.
//

#import "DTTextView.h"
#import "UIColor+Hex.h"

@implementation DTTextView



- (id)initWithFrame:(CGRect)frame andFontSize:(CGFloat)fontSize {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        self.placeholderTextColor = [UIColor colorWithHexString:@"CCCCCC"];
        self.font = [UIFont systemFontOfSize:fontSize];
        CGFloat width = frame.size.width / 2;
        self.counterLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 15 - width, frame.size.height - 20, width, 15)];
        _counterLabel.textAlignment = NSTextAlignmentRight;
        _counterLabel.font = [UIFont systemFontOfSize:12];
        _counterLabel.textColor = [UIColor colorWithHexString:@"CCCCCC"];
        [self addSubview:_counterLabel];
    }

    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if ([_placeholder isEqualToString:placeholder]) {
        return;
    }
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    _placeholderTextColor = placeholderTextColor;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)string {
    [super setText:string];
    [self setNeedsDisplay];
}

- (void)insertText:(NSString *)string {
    [super insertText:string];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:self];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        [self commonInit];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!(self.text.length == 0 && self.placeholder.length > 0)) {
        return;
    }
    
    // Draw the text
    //rect = [self placeholderRectForBounds:self.bounds];
    //rect = FRAME(11, 10, self.bounds.size.width-20, self.bounds.size.height - 20);
    rect = FRAME(self.textContainerInset.left+5, self.textContainerInset.top, self.bounds.size.width-self.textContainerInset.left-self.textContainerInset.right - 5, self.bounds.size.height-self.textContainerInset.top-self.textContainerInset.bottom);
    if ([self.placeholder respondsToSelector:@selector(drawInRect:withAttributes:)]) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:self.typingAttributes];
        attributes[NSForegroundColorAttributeName] = self.placeholderTextColor;
        
        [self.placeholder drawInRect:rect withAttributes:attributes];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self.placeholderTextColor set];
        [self.placeholder drawInRect:rect
                            withFont:self.font
                       lineBreakMode:NSLineBreakByWordWrapping
                           alignment:self.textAlignment];
#pragma clang diagnostic pop
    }
}

#pragma mark - Private Methods

- (void)commonInit {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    self.placeholderTextColor = [UIColor colorWithWhite:0.700 alpha:1.000];
}

- (void)textChanged:(NSNotification *)notification {
    [self setNeedsDisplay];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    // Inset the rect
    CGRect rect = UIEdgeInsetsInsetRect(bounds, self.contentInset);
    rect = CGRectInset(rect, 5, 0); // Take cursor position into consideration
    
    return rect;
}

@end
