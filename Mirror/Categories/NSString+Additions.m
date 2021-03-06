//
//  NSString+Additions.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 20/09/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import "NSString+Additions.h"

static const char units[] = { '\0', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y' };
static int unitCount = sizeof units - 1;

#pragma mark NSString + Additions

@interface NSString (Private)

+ (NSString *)stringForSpeed:(long long)speed b:(NSString *)b kb:(NSString *)kb mb:(NSString *)mb gb:(NSString *)gb;

- (NSString *)removeAlphaNumeric;
- (NSString *)removeNonAlphaNumeric;
- (NSString *)removeNumeric;
- (NSString *)removeWhitespace;

@end

@implementation NSString (NSStringAdditions)

+ (NSAttributedString *)attributedStringWithTitle:(NSString *)title color:(NSColor *)color font:(NSFont *)font alignment:(CTTextAlignment)alignment {
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = alignment;
    
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger length = [attributedTitle length];
    NSRange range = NSMakeRange(0, length);
    [attributedTitle addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attributedTitle addAttribute:NSFontAttributeName value:font range:range];
    [attributedTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributedTitle fixAttributesInRange:range];
    
    [paragraphStyle release];
    
    return [attributedTitle autorelease];
    
}

+ (NSString *)elapsedTimeForSeconds:(long long)seconds {
    
    seconds = (seconds % 60);
    int minutes = (seconds % 3600) / 60;
    int hours = (seconds % 86400) / 3600;
    int days = (seconds % (86400 * 30)) / 86400;
    
    if (days > 0)
        return [NSString stringWithFormat:@"%i days, %i hours, %i minutes", days, hours, minutes];
    else if (hours > 0)
        return [NSString stringWithFormat:@"%i hours, %i minutes", hours, minutes];
    else if (minutes > 0)
        return [NSString stringWithFormat:@"%i minutes, %lli seconds", minutes, seconds];
    else if (seconds > 0)
        return [NSString stringWithFormat:@"%lli seconds", seconds];
    
    return @"--";
    
}

+ (NSString *)stringForByteCount:(long long)size { // http://stackoverflow.com/questions/7846495/how-to-get-file-size-properly-and-convert-it-to-mb-gb-in-cocoa
    
    int exponent = 0;
    double bytes = size;
    
    while ((bytes >= 1024) && (exponent < unitCount)) {
        bytes /= 1024;
        exponent++;
    }
    
    return [NSString stringWithFormat:@"%.0f%cb", bytes, units[exponent]];
    
}

+ (NSString *)stringForSpeed:(long long)speed {
    
    return [self stringForSpeed:speed b:@"b/s" kb:@"KB/s" mb:@"MB/s" gb:@"GB/s"];
    
}

+ (NSString *)stringForSpeedAbbrev:(long long)speed {
    
    return [self stringForSpeed:speed b:@"b" kb:@"K" mb:@"M" gb:@"G"];
    
}

+ (NSString *)formattedStringFromCamelCasing:(NSString *)string {
    
    // Adapted from https://stackoverflow.com/questions/7322498/insert-or-split-string-at-uppercase-letters-objective-c
    
    int index = 1;
    NSMutableString *mutableInputString = [NSMutableString stringWithString:string];
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    NSMutableCharacterSet *lowercase = [NSMutableCharacterSet lowercaseLetterCharacterSet];
    [lowercase addCharactersInString:@"0123456789"];
    
    while (index < mutableInputString.length) {
        
        if ([uppercase characterIsMember:[mutableInputString characterAtIndex:index]]) {
            if (index > 0
                && [lowercase characterIsMember:[mutableInputString characterAtIndex:index-1]]) {
                [mutableInputString insertString:@" " atIndex:index];
                index++;
            }
        }
        
        index++;
        
    }
    
    return [NSString stringWithString:mutableInputString];
    
}

- (void)convertToCString:(char *)cStringPointer {
    
    NSUInteger length = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding] + 1;
    char cString [length];
    
    if ([self getCString:cString maxLength:length encoding:NSUTF8StringEncoding])
        strncpy(cStringPointer, cString, length);
    else
        NSLog(@"Error converting %@ to CString", self); // Error
    
}

- (unsigned long long)unsignedLongLongValue {
    
    if (!self || [self length] < 1)
        return 0; // Empty string
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [numberFormatter numberFromString:self];
    
    return [number unsignedLongLongValue];
    
}

- (BOOL)isNumeric {
    
    return [[self removeNumeric] length] == 0;
    
}

- (BOOL)isAlphaNumeric {
    
    return [[self removeAlphaNumeric] length] == 0;
    
}

- (BOOL)isWhitespace {
    
    return [[self removeWhitespace] length] == 0;
    
}

- (BOOL)isEmpty {
    
    return self.length == 0 || [self isWhitespace];
    
}

- (BOOL)contains:(NSString *)string {
    
    NSRange range = [self rangeOfString:string];
    BOOL found = range.location != NSNotFound;
    return found;
    
}

- (NSString *)UTI {
    
    CFStringRef fileExtension = (CFStringRef) [self pathExtension];
    return [(NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL) autorelease];
    
}

@end

@implementation NSString (Private)

+ (NSString *)stringForSpeed:(long long)speed b:(NSString *)b kb:(NSString *)kb mb:(NSString *)mb gb:(NSString *)gb {
    
    if (speed < 1000)
        return [NSString stringWithFormat:@"%lli %@", speed, b];
    speed /= 1000;
    if (speed <= 1000)
        return [NSString stringWithFormat:@"%lli %@", speed, kb];
    speed /= 1000;
    if (speed <= 1000)
        return [NSString stringWithFormat:@"%lli %@", speed, mb];

    return [NSString stringWithFormat:@"%lli %@", speed/1000, gb];
    
}

- (NSString *)removeAlphaNumeric {
    
    NSCharacterSet *charactersToRemove = [NSCharacterSet alphanumericCharacterSet];
    return [[self componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
    
}

- (NSString *)removeNonAlphaNumeric {
    
    NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return [[self componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
    
}

- (NSString *)removeNumeric {
    
    NSCharacterSet *charactersToRemove = [NSCharacterSet decimalDigitCharacterSet];
    return [[self componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
    
}

- (NSString *)removeWhitespace {
    
    NSCharacterSet *charactersToRemove = [NSCharacterSet whitespaceCharacterSet];
    return [self stringByTrimmingCharactersInSet:charactersToRemove];
    
}

@end
