
//  NSString+AtoZ.h
//  AtoZ

#import <Foundation/Foundation.h>
#import "AtoZ.h"

@interface NSString (AtoZ)


- (CGFloat)pointSizeForFrame:(NSRect)frame withFont:(NSString *)fontName;
+ (CGFloat)pointSizeForFrame:(NSRect)frame withFont:(NSString *)fontName forString:(NSString*)string;

- (NSString*) stringByReplacingAllOccurancesOfString:(NSString*) search withString:(NSString*) replacement;
- (NSString*) urlEncoded;
- (NSString*) urlDecoded;

- (NSString*) firstLetter;
+ (NSString*) newUniqueIdentifier;
+ (NSString*) randomAppPath;

+ (NSString*) randomWords:(NSInteger)number;
+ (NSString*) randomSentences:(NSInteger)number;

//@property (readonly) NSColor *colorValue;

// new way
- (void) drawInRect:(NSRect)r withFont:(NSFont*)font andColor:(NSColor*)color;

- (void) drawCenteredInRect:(NSRect)rect withFont:(NSString*) font;
/*** Returns the string cleaned from leading and trailing whitespaces */
@property (readonly) NSString *trim;

/*** Returns the reverse version of the string */
@property (readonly) NSString *reversed;

/*** Returns the substring after the first character in this string */
@property (readonly) NSString *shifted;

/*** Returns the substring not containing the last character of this string */
@property (readonly) NSString *popped;

/*** Combination of shifted and popped, removes the first and last character */
@property (readonly) NSString *chopped;

/*** Returns a CamelCase Version of this string */
@property (readonly) NSString *camelized;

@property (readonly) NSString *hyphonized;

@property (readonly) NSString *underscored;

/*** Returns YES if this string is nil or contains nothing but whitespaces */
@property (readonly) BOOL isEmpty;

/*** Counts occurrences of a given string */
- (NSUInteger)count:(NSString*) aString;

/*** Cunts occurrences of a given string with sone compare options */
- (NSUInteger)count:(NSString*) aString options:(NSStringCompareOptions)flags;

/*** Counts the whitespace chars that prefix this string */
@property (readonly) NSUInteger indentationLevel;

/*** Returns YES when aString is part of the this string.
 * nil and @"" are never part of any compared string */
- (BOOL)contains:(NSString*) aString;

/*** Returns YES when this string contains ANY of the strings defined in the array */
- (BOOL)containsAnyOf:(NSArray*) array;

/*** Returns YES when this string contains ALL of the strings defined in the array */
- (BOOL)containsAllOf:(NSArray*) array;

/*** Returns YES when this string starts with aString, just a synonym for hasPrefix */
- (BOOL)startsWith:(NSString*) aString;

/*** Returns YES when this string ends with aString, just a synonym for hasSuffix */
- (BOOL)endsWith:(NSString*) aString;

/*** Returns YES when this string has both given prefix and suffix */
- (BOOL)hasPrefix:(NSString*) prefix andSuffix:(NSString*) suffix;

/*** Will return the substring between prefix and suffix.
 * If either prefix or suffix cannot be matched nil will be returned */
- (NSString*) substringBetweenPrefix:(NSString*) prefix 
                           andSuffix:(NSString*) suffix;

/*** Oldscool indexOf, if you do not want to handle NSRange objects
 * will return -1 instead of NSNotFound */
- (NSInteger)indexOf:(NSString*) aString;
- (NSInteger)indexOf:(NSString*) aString 
		  afterIndex:(NSInteger)index;

/*** Oldscool lastIndexOf, if you do not want to handle NSRange objects
 * will return -1 instead of NSNotFound */
- (NSInteger)lastIndexOf:(NSString*) aString;

/*** Returns the first NSRange of any matching substring in this string
 * that is part of the strings set */
- (NSRange)rangeOfAny:(NSSet*) strings;

/*** Returns this string splitted by lines.
 * Shortcut for componentsSeperatedByString:@"\n" */
@property (readonly) NSArray *lines;

/*** Returns this string splitted by whitespaces.
 * Shortcut for componentsSeperatedByString:@" "
 * Empty elements will not be part of the resulting array */
@property (readonly) NSArray *words;

/*** Returns a set with all unique elements of this String,
 * separated by whitespaces */
@property (readonly) NSSet *wordSet;

- (NSArray*) trimmedComponentsSeparatedByString:(NSString*) delimiter;

@property (readonly) NSArray *decolonize;
@property (readonly) NSArray *splitByComma;

- (NSString*) substringBefore:(NSString*) delimiter;
- (NSString*) substringAfter:(NSString*) delimiter;


// The difference between the splitBy and splitAt groups is
// that splitAt will return an array containing one or two elements

- (NSArray*) splitAt:(NSString*) delimiter;
- (BOOL)splitAt:(NSString*) delimiter 
           head:(NSString **)head 
           tail:(NSString **)tail;

// excuse the pun, but it divides the string into a head and body word, trimmed
@property (readonly) NSArray *decapitate;


// TBD whether they belong here or elsewhere

@property (readonly) NSPoint pointValue;
@property (readonly) NSUInteger minutesValue;
@property (readonly) NSUInteger secondsValue;

@property (readonly) NSURL *url;
@property (readonly) NSURL *fileURL;

@property (readonly) NSString *ucfirst;
@property (readonly) NSString *lcfirst;

+ (id)	stringWithData:(NSData*) data encoding:(NSStringEncoding)encoding;
+ (NSString*) stringWithCGFloat:(CGFloat)f maxDigits:(NSUInteger)numDigits;


- (NSAttributedString*) attributedWithSize:(NSUInteger)size andColor:(NSColor*)color;


-(NSMutableAttributedString *) attributedParagraphWithSpacing:(float)spacing;
- (CGFloat) widthWithFont:(NSFont *)font;
-(NSString*) truncatedForRect:(NSRect)frame withFont:(NSFont*)font;

@end


// Truncate a string by inserting an ellipsis ("..."). truncateMode can be NSLineBreakByTruncatingHead, NSLineBreakByTruncatingMiddle or NSLineBreakByTruncatingTail.
NSString*   StringByTruncatingStringWithAttributesForWidth( NSString* s,
                                                                NSDictionary* attrs,
                                                                float wid,
                                                                NSLineBreakMode truncateMode );



@interface NSMutableString (AtoZ)

- (NSString*) shift;
- (NSString*) pop;

- (BOOL)removePrefix:(NSString*) prefix;
- (BOOL)removeSuffix:(NSString*) suffix;
- (BOOL)removePrefix:(NSString*) prefix andSuffix:(NSString*) suffix;

- (NSMutableString*) camelize;
- (NSMutableString*) hyphonize;
- (NSMutableString*) underscorize;
- (NSMutableString*) replaceAll:(NSString*) needle 
                     withString:(NSString*) replacement;

@end


@interface NSString (RuntimeReporting)

- (BOOL) hasSubclasses;
- (NSArray *) subclassNames;
- (NSArray *) methodNames;
- (NSArray *) ivarNames;
- (NSArray *) propertyNames;
- (NSArray *) protocolNames;

@end


/*

 * SUMMARY

 The methods in these @interfaces are typically used to dynamically size
 an NSTextView or NSTextField to fit their strings.  They return the
 ^used^ size, width or height of the given string/attributes, constrained
 by the maximum dimensions passed in the 'width' and 'height' arguments.

 * RENDERING IN NSTextView VS. NSTextField

 Text rendered in a multiline line-wrapped NSTextField leaves much more
 space between lines than text rendered in an NSTextView.  The total points
 per line is typically 10-20% higher.

 Because most apps use NSTextView to render multiline text, using a
 line-wrapped NSTextField looks funny, and obviously it wastes useful
 screen area.  But there are more subtle disadavantages if you wish to
 estimate the size of the rendered text, typically done in
 order to size the view.

 First of all, you cannot get a perfect estimate of the height.
 Although using the proper typesetterBehavior in the NSLayoutManager
 providing the estimate fixes the severe 10-20% underestimation which
 you'd get from using the default NSTypesetterLatestBehavior,
 it still usually gives results that are a little inaccurate.
 The error depends on the font and the size.
 For Arial and Helvetica, the calculated height is usually underestimated
 by the measure of one glyph descender; i.e. the measurement extends
 only to the baseline of the last line.
 For Lucida Grande smaller-sized fonts (9-10 pt), and for most sizes of
 Goudy Old Style, the calculated height is overestimated, by about one line.
 For Stencil, the calculated height is accurate.
 For Zapfino, the calculated height is usually underrestimated by 1-3 pixels.
 These are the only fonts that I looked at the results for.

 Finally, although the typesetterBehavior seems to be, at this time,
 equal to NSTypesetterBehavior_10_2_WithCompatibility, I suppose that
 this could change in the future.  This will change the vertical
 size of the rendered text.

 For these reasons, using a wrapped NSTextField to render multiline text is
 therefore discouraged in favor of using an NSTextView.

 * THE GLOBAL VARIABLE gNSStringGeometricsTypesetterBehavior

 The estimate of line spacing is controlled by the NSTypesetterBehavior
 setting in NSLayoutManager used in these methods.  Therefore, you must
 specify the NSTypsetterBehavior you desire when using one of these methods
 to get a measurement.

 Rather than providing a 'typsetterBehavior' argument in each of the methods in
 this category, which would make them really messy just to support a
 discouraged usage, a global variable, gNSStringGeometricsTypesetterBehavior, is
 initialized with the value NSTypesetterLatestBehavior.  This value is
 appropriate to estimating height of text to be rendered in an NSTextView.
 This is also the default behavior in NSLayoutManager.

 Therefore, if you want to get measurements for text to be rendered in an
 NSTextView, these methods will "just work".

 Also, if you want to get the dimensions for text which will render in a
 single line, even in NSTextField, these methods will "just work".

 However, if you want to get dimensions of a string as rendered in the
 discouraged NSTextField with line wrapping, set the global variable
 gNSStringGeometricsTypesetterBehavior to
 NSTypesetterBehavior_10_2_WithCompatibility before invoking these methods.
 Invoking any of these methods will automatically set it back to the
 default value of NSTypesetterLatestBehavior.

 * ARGUMENTS width and height

 In the sizeFor... methods, pass either a width or height which is known to
 be larger than the width or height that is required.  Usually, one of these
 should be the "unlimited" value of FLT_MAX.
 If text will be drawn on one line, you may pass FLT_MAX for width.

 * ARGUMENT attributes, NSAttributedString attributes

 The dictionary 'attributes', or for NSAttributedString (Geometrics), the
 attributes of the receiver, must contain at least one key:
 NSFontAttributeName, with value an NSFont object.
 Other keys in 'attributes' are ignored.

 * DEGENERATE ARGUMENT CASES

 If the receiver has 0 -length, all of these methods will return 0.0.
 If 'font' argument is nil, will log error to console and return 0.0 x 0.0.

 It is sometimes useful to know that, according to Douglas Davidson,
 http://www.cocoabuilder.com/archive/message/cocoa/2002/2/13/66379,
 "The default font for text that has no font attribute set is 12-pt Helvetica."
 Can't find any official documentation on this, but it seems to be still
 true today, as of Mac OS 10.5.2, for NSTextView.  For NSTextField, however,
 the default font is 12-pt Lucida Grande.

 If you pass a nil 'font' argument, these methods will log an error and
 return 0.0.  But if you pass an NSAttributedString with no font attribute
 for a run, these methods will calculate assuming 12-pt regular Helvetica.

 * INTERNAL DESIGN

 -[NSAttributedString sizeForWidth:height] is the primitive workhorse method.
 All other methods in these @interfaces invoke this method under the hood.
 Basically, it stuffs your string into an NSTextContainer, stuffs this into
 an NSLayout Manager, and then gets the answer by invoking
 -[NSLayoutManager usedRectForTextContainer:].  The idea is copied from here:
 http://developer.apple.com/documentation/Cocoa/Conceptual/TextLayout/Tasks/StringHeight.html

 * AUTHOR

 Please send bug reports or other comments to Jerry Krinock, jerry@ieee.org
 Updates may be available at http://sheepsystems.com/sourceCode

 * ACKNOWLEDGEMENTS

 Thanks very much to Steve Nygard for taking the project one night,
 recognizing the importance of the line fragment padding and hyphenation
 factor, and the idea of generalizing to support NSAttributedString.

 */


extern int gNSStringGeometricsTypesetterBehavior ;

@interface NSAttributedString (Geometrics)

// Measuring Attributed Strings
- (NSSize)sizeForWidth:(float)width
				height:(float)height ;
- (float)heightForWidth:(float)width ;
- (float)widthForHeight:(float)height ;

@end

@interface NSString (Geometrics)

// Measuring a String With Attributes
- (NSSize)sizeForWidth:(float)width		height:(float)height 	attributes:(NSDictionary*)attributes ;

- (float)heightForWidth:(float)width	attributes:(NSDictionary*)attributes ;
- (float)widthForHeight:(float)height	attributes:(NSDictionary*)attributes ;

// Measuring a String with a constant Font
//- (NSSize)sizeInSize:(NSSize)size 	  font:(NSFont*)font;

- (NSSize)sizeForWidth: (float)width  height:(float)height font:(NSFont*)font;
- (float)heightForWidth:(float)width  font:(NSFont*)font;
- (float)widthForHeight:(float)height font:(NSFont*)font;

@end
