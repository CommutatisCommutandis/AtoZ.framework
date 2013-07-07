//
//  NSValue+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 9/30/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSValue+AtoZ.h"
@implementation NSValue (AZWindowPosition)
+ (id)valueWithPosition:(AZWindowPosition)pos;
{
	return [NSValue value:&pos withObjCType:@encode(AZWindowPosition)];
}
- (AZWindowPosition)positionValue;
{
	AZWindowPosition pos; [self getValue:&pos]; return pos;
}
@end


@implementation NSValue (AZInstallationStatus)

+ (id)valueWithInstallStatus: (AZInstallationStatus) status;
{
	return [NSValue value:&status withObjCType:@encode(AZInstallationStatus)];
}
- (AZInstallationStatus) installStatusValue;
{
	AZInstallationStatus status; [self getValue:&status]; return status;

}@end

@implementation NSValue (AtoZAutoBox)
+ (id)valueWithColor: (NSColor*) color 
{
	return (NSVAL*)[NSValue valueWithBytes:[color.hexString dataUsingEncoding:NSUTF8StringEncoding].bytes objCType:@encode(NSS)];
}
- (NSC*) colorValue {
	NSData *j;  [self getValue:&j]; NSS*hex = [NSS stringWithData:j encoding:NSUTF8StringEncoding]; return [NSC colorWithHex:hex];
}

@end

struct _Pair
{   short val;
	short count;
};

typedef struct _Pair Pair;

@interface NSValue (Pair)
+ (id)valueWithPair:(Pair)pair;
- (Pair)pairValue;
@end
@implementation NSValue (Pair)
+ (id)valueWithPair:(Pair)pair
{
	return [NSValue value:&pair withObjCType:@encode(Pair)];
}
- (Pair)pairValue
{
	Pair pair; [self getValue:&pair]; return pair;
}
@end




@implementation NSData (NSDataExtension)

+ (NSData *) dataWithBase32String:(NSS*)encoded
{
	/* First valid character that can be indexed in decode lookup table */
	static NSInteger charDigitsBase = '2';

	/* Lookup table used to decode() characters in encoded strings */
	static NSInteger charDigits[] =
	{		 26,27,28,29,30,31,-1,-1,-1,-1,-1,-1,-1,-1		 // 23456789:;<=>?
		,-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14 // @ABCDEFGHIJKLMNO
		,15,16,17,18,19,20,21,22,23,24,25,-1,-1,-1,-1,-1 // PQRSTUVWXYZ[\]^_
		,-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14 // `abcdefghijklmno
		,15,16,17,18,19,20,21,22,23,24,25					 // pqrstuvwxyz
	};

	if (! [encoded canBeConvertedToEncoding:NSASCIIStringEncoding]) return nil;
	const char *chars = [encoded UTF8String]; // avoids using characterAtIndex.
	NSInteger charsLen = [encoded length];

	// Note that the code below could detect non canonical Base32 length within the loop. However canonical Base32 length can be tested before entering the loop.
	// A canonical Base32 length modulo 8 cannot be:
	// 1 (aborts discarding 5 bits at STEP n=0 which produces no byte),
	// 3 (aborts discarding 7 bits at STEP n=2 which produces no byte),
	// 6 (aborts discarding 6 bits at STEP n=1 which produces no byte).
	switch (charsLen & 7) { // test the length of last subblock
		case 1: //  5 bits in subblock:  0 useful bits but 5 discarded
		case 3: // 15 bits in subblock:  8 useful bits but 7 discarded
		case 6: // 30 bits in subblock: 24 useful bits but 6 discarded
			return nil; // non-canonical length
	}
	NSInteger charDigitsLen = sizeof(charDigits);
	NSInteger bytesLen = (charsLen * 5) >> 3;
	Byte bytes[bytesLen];
	NSInteger bytesOffset = 0, charsOffset = 0;
	// Also the code below does test that other discarded bits
	// (1 to 4 bits at end) are effectively 0.
	while (charsLen > 0)
	{
		NSInteger digit, lastDigit;
		// STEP n = 0: Read the 1st Char in a 8-Chars subblock
		// Leave 5 bits, asserting there's another encoding Char
		if ((digit = (NSI)chars[charsOffset] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		lastDigit = digit << 3;
		// STEP n = 5: Read the 2nd Char in a 8-Chars subblock
		// Insert 3 bits, leave 2 bits, possibly trailing if no more Char
		if ((digit = (NSI)chars[charsOffset + 1] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		bytes[bytesOffset] = (Byte)((digit >> 2) | lastDigit);
		lastDigit = (digit & 3) << 6;
		if (charsLen == 2) {
			if (lastDigit != 0) return nil; // non-canonical end
			break; // discard the 2 trailing null bits
		}
		// STEP n = 2: Read the 3rd Char in a 8-Chars subblock
		// Leave 7 bits, asserting there's another encoding Char
		if ((digit = (NSI)chars[charsOffset + 2] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		lastDigit |= (Byte)(digit << 1);
		// STEP n = 7: Read the 4th Char in a 8-chars Subblock
		// Insert 1 bit, leave 4 bits, possibly trailing if no more Char
		if ((digit = (NSI)chars[charsOffset + 3] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		bytes[bytesOffset + 1] = (Byte)((digit >> 4) | lastDigit);
		lastDigit = (Byte)((digit & 15) << 4);
		if (charsLen == 4) {
			if (lastDigit != 0) return nil; // non-canonical end
			break; // discard the 4 trailing null bits
		}
		// STEP n = 4: Read the 5th Char in a 8-Chars subblock
		// Insert 4 bits, leave 1 bit, possibly trailing if no more Char
		if ((digit = (NSI)chars[charsOffset + 4] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		bytes[bytesOffset + 2] = (Byte)((digit >> 1) | lastDigit);
		lastDigit = (Byte)((digit & 1) << 7);
		if (charsLen == 5) {
			if (lastDigit != 0) return nil; // non-canonical end
			break; // discard the 1 trailing null bit
		}
		// STEP n = 1: Read the 6th Char in a 8-Chars subblock
		// Leave 6 bits, asserting there's another encoding Char
		if ((digit = (NSI)chars[charsOffset + 5] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		lastDigit |= (Byte)(digit << 2);
		// STEP n = 6: Read the 7th Char in a 8-Chars subblock
		// Insert 2 bits, leave 3 bits, possibly trailing if no more Char
		if ((digit = (NSI)chars[charsOffset + 6] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		bytes[bytesOffset + 3] = (Byte)((digit >> 3) | lastDigit);
		lastDigit = (Byte)((digit & 7) << 5);
		if (charsLen == 7) {
			if (lastDigit != 0) return nil; // non-canonical end
			break; // discard the 3 trailing null bits
		}
		// STEP n = 3: Read the 8th Char in a 8-Chars subblock
		// Insert 5 bits, leave 0 bit, next encoding Char may not exist
		if ((digit = (NSI)chars[charsOffset + 7] - charDigitsBase) < 0 || digit >= charDigitsLen || (digit = charDigits[digit]) == -1)
			return nil; // invalid character
		bytes[bytesOffset + 4] = (Byte)(digit | lastDigit);
		//// This point is always reached for chars.length multiple of 8
		charsOffset += 8;
		bytesOffset += 5;
		charsLen -= 8;
	}
	// On loop exit, discard the n trailing null bits
	return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

- (NSS*) base32String
{
	/* Lookup table used to canonically encode() groups of data bits */
	static char canonicalChars[] =
	{		 'A','B','C','D','E','F','G','H','I','J','K','L','M' // 00..12
		,'N','O','P','Q','R','S','T','U','V','W','X','Y','Z' // 13..25
		,'2','3','4','5','6','7'									  // 26..31
	};
	const Byte *bytes = [self bytes];
	NSInteger bytesOffset = 0, bytesLen = [self length];
	NSInteger charsOffset = 0, charsLen = ((bytesLen << 3) + 4) / 5;
	char chars[charsLen];
	while (bytesLen != 0) {
		NSInteger digit, lastDigit;
		// INVARIANTS FOR EACH STEP n in [0..5[; digit in [0..31[;
		// The remaining n bits are already aligned on top positions
		// of the 5 least bits of digit, the other bits are 0.
		////// STEP n = 0: insert new 5 bits, leave 3 bits
		digit = bytes[bytesOffset] & 255;
		chars[charsOffset] = canonicalChars[digit >> 3];
		lastDigit = (digit & 7) << 2;
		if (bytesLen == 1) { // put the last 3 bits
			chars[charsOffset + 1] = canonicalChars[lastDigit];
			break;
		}
		////// STEP n = 3: insert 2 new bits, then 5 bits, leave 1 bit
		digit = bytes[bytesOffset + 1] & 255;
		chars[charsOffset + 1] = canonicalChars[(digit >> 6) | lastDigit];
		chars[charsOffset + 2] = canonicalChars[(digit >> 1) & 31];
		lastDigit = (digit & 1) << 4;
		if (bytesLen == 2) { // put the last 1 bit
			chars[charsOffset + 3] = canonicalChars[lastDigit];
			break;
		}
		////// STEP n = 1: insert 4 new bits, leave 4 bit
		digit = bytes[bytesOffset + 2] & 255;
		chars[charsOffset + 3] = canonicalChars[(digit >> 4) | lastDigit];
		lastDigit = (digit & 15) << 1;
		if (bytesLen == 3) { // put the last 1 bits
			chars[charsOffset + 4] = canonicalChars[lastDigit];
			break;
		}
		////// STEP n = 4: insert 1 new bit, then 5 bits, leave 2 bits
		digit = bytes[bytesOffset + 3] & 255;
		chars[charsOffset + 4] = canonicalChars[(digit >> 7) | lastDigit];
		chars[charsOffset + 5] = canonicalChars[(digit >> 2) & 31];
		lastDigit = (digit & 3) << 3;
		if (bytesLen == 4) { // put the last 2 bits
			chars[charsOffset + 6] = canonicalChars[lastDigit];
			break;
		}
		////// STEP n = 2: insert 3 new bits, then 5 bits, leave 0 bit
		digit = bytes[bytesOffset + 4] & 255;
		chars[charsOffset + 6] = canonicalChars[(digit >> 5) | lastDigit];
		chars[charsOffset + 7] = canonicalChars[digit & 31];
		//// This point is always reached for bytes.length multiple of 5
		bytesOffset += 5;
		charsOffset += 8;
		bytesLen -= 5;
	}
	return @(chars);
}

@end
