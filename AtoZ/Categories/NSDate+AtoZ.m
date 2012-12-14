//
//  NSDate+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 12/13/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSDate+AtoZ.h"



@implementation NSTimeZone (Extensions)

+ (NSTimeZone*) GMTTimeZone {
	static NSTimeZone* timeZone = nil;
	if (timeZone == nil) {
		timeZone = [[NSTimeZone alloc] initWithName:@"GMT"];
		DCHECK(timeZone);
	}
	return timeZone;
}

@end








@implementation NSDate (AtoZ)


+ (NSS*)dayOfWeek
{
	return [[NSDate date] descriptionWithCalendarFormat:@"%A" timeZone:nil locale:[AZUSERDEFS dictionaryRepresentation]];
}

/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */
- (NSUInteger)daysAgo {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
											   fromDate:self
												 toDate:[NSDate date]
												options:0];
	return [components day];
}

- (NSUInteger)daysAgoAgainstMidnight {
	// get a midnight version of ourself:
	NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
	[mdf setDateFormat:@"yyyy-MM-dd"];
	NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
	[mdf release];

	return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSString *)stringDaysAgo {
	return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
	NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
	NSString *text = nil;
	switch (daysAgo) {
		case 0:
			text = @"Today";
			break;
		case 1:
			text = @"Yesterday";
			break;
		default:
			text = [NSString stringWithFormat:@"%ld days ago", daysAgo];
	}
	return text;
}

- (NSUInteger)weekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
	return [weekdayComponents weekday];
}

+ (NSDate *)dateFromString:(NSString *)string {
	return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:format];
	NSDate *date = [inputFormatter dateFromString:string];
	[inputFormatter release];
	return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
	return [date string];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime {
    /*
	 * if the date is in today, display 12-hour time with meridian,
	 * if it is within the last 7 days, display weekday name (Friday)
	 * if within the calendar year, display as Jan 23
	 * else display as Nov 11, 2008
	 */
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];

	NSDate *today = [NSDate date];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
													 fromDate:today];

	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
	NSString *displayString = nil;

	// comparing against midnight
    NSComparisonResult midnight_result = [date compare:midnight];
	if (midnight_result == NSOrderedDescending) {
		if (prefixed) {
			[displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
		} else {
			[displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
		}
	} else {
		// check if date is within last 7 days
		NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
		[componentsToSubtract setDay:-7];
		NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
		[componentsToSubtract release];
        NSComparisonResult lastweek_result = [date compare:lastweek];
		if (lastweek_result == NSOrderedDescending) {
            if (displayTime) {
                [displayFormatter setDateFormat:@"EEEE h:mm a"];
            } else {
                [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
            }
		} else {
			// check if same calendar year
			NSInteger thisYear = [offsetComponents year];

			NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
														   fromDate:date];
			NSInteger thatYear = [dateComponents year];
			if (thatYear >= thisYear) {
                if (displayTime) {
                    [displayFormatter setDateFormat:@"MMM d h:mm a"];
                }
                else {
                    [displayFormatter setDateFormat:@"MMM d"];
                }
			} else {
                if (displayTime) {
                    [displayFormatter setDateFormat:@"MMM d, yyyy h:mm a"];
                }
                else {
                    [displayFormatter setDateFormat:@"MMM d, yyyy"];
                }
			}
		}
		if (prefixed) {
			NSString *dateFormat = [displayFormatter dateFormat];
			NSString *prefix = @"'on' ";
			[displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
		}
	}

	// use display formatter to return formatted date string
	displayString = [displayFormatter stringFromDate:date];

    [displayFormatter release];

	return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
	return [[self class] stringForDisplayFromDate:date prefixed:prefixed alwaysDisplayTime:NO];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
	return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithFormat:(NSString *)format {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	NSString *timestamp_str = [outputFormatter stringFromDate:self];
	[outputFormatter release];
	return timestamp_str;
}

- (NSString *)string {
	return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateStyle:dateStyle];
	[outputFormatter setTimeStyle:timeStyle];
	NSString *outputString = [outputFormatter stringFromDate:self];
	[outputFormatter release];
	return outputString;
}

- (NSDate *)beginningOfWeek {
	// largely borrowed from "Date and Time Programming Guide for Cocoa"
	// we'll use the default calendar and hope for the best
	NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *beginningOfWeek = nil;
	BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
						   interval:NULL forDate:self];
	if (ok) {
		return beginningOfWeek;
	}

	// couldn't calc via range, so try to grab Sunday, assuming gregorian style
	// Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];

	/*
	 Create a date components to represent the number of days to subtract from the current date.
	 The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
	 */
	NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
	[componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
	beginningOfWeek = nil;
	beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
	[componentsToSubtract release];

	//normalize to midnight, extract the year, month, and day components and create a new date from those components.
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
											   fromDate:beginningOfWeek];
	return [calendar dateFromComponents:components];
}

- (NSDate *)beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
											   fromDate:self];
	return [calendar dateFromComponents:components];
}

- (NSDate *)endOfWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	// to get the end of week for a particular date, add (7 - weekday) days
	[componentsToAdd setDay:(7 - [weekdayComponents weekday])];
	NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
	[componentsToAdd release];

	return endOfWeek;
}

+ (NSString *)dateFormatString {
	return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString {
	return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
	return @"yyyy-MM-dd HH:mm:ss";
}

// preserving for compatibility
+ (NSString *)dbFormatString {
	return [NSDate timestampFormatString];
}

@end


@implementation NSDate (Extensions)

// NSCalendar is not thread-safe so we use a singleton protected by a spinlock
static inline NSCalendar* _GetSharedCalendar() {
	static NSCalendar* calendar = nil;
	if (calendar == nil) {
		calendar = [NSCalendar currentCalendar];
	}
	DCHECK(calendar.timeZone == [NSTimeZone defaultTimeZone]);
	calendar.timeZone = [NSTimeZone defaultTimeZone];  // This should be a no-op if the timezone hasn't changed
	return calendar;
}

+ (NSDate*) dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day {
	return [self dateWithYear:year month:month day:day hour:0 minute:0 second:0];
}

+ (NSDate*) dateWithYear:(NSUInteger)year
				   month:(NSUInteger)month
					 day:(NSUInteger)day
					hour:(NSUInteger)hour
				  minute:(NSUInteger)minute
				  second:(NSUInteger)second {
	NSDateComponents* components = [[NSDateComponents alloc] init];
	components.year = year;
	components.month = month;
	components.day = day;
	components.hour = hour;
	components.minute = minute;
	components.second = second;
	OSSpinLockLock(&_calendarSpinLock);
	NSDate* date = [_GetSharedCalendar() dateFromComponents:components];
	OSSpinLockUnlock(&_calendarSpinLock);
	[components release];
	return date;
}

- (void) getYear:(NSUInteger*)year month:(NSUInteger*)month day:(NSUInteger*)day {
	[self getYear:year month:month day:day hour:NULL minute:NULL second:NULL];
}

- (void) getYear:(NSUInteger*)year
		   month:(NSUInteger*)month
			 day:(NSUInteger*)day
			hour:(NSUInteger*)hour
		  minute:(NSUInteger*)minute
		  second:(NSUInteger*)second {
	NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	OSSpinLockLock(&_calendarSpinLock);
	NSDateComponents* components = [_GetSharedCalendar() components:flags fromDate:self];
	OSSpinLockUnlock(&_calendarSpinLock);
	if (year) {
		*year = components.year;
	}
	if (month) {
		*month = components.month;
	}
	if (day) {
		*day = components.day;
	}
	if (hour) {
		*hour = components.hour;
	}
	if (minute) {
		*minute = components.minute;
	}
	if (second) {
		*second = components.second;
	}
}

- (NSUInteger) daySinceBeginningOfTheYear {
	OSSpinLockLock(&_calendarSpinLock);
	NSDateComponents* components = [_GetSharedCalendar() components:NSYearCalendarUnit fromDate:self];
	NSDate* date = [_GetSharedCalendar() dateFromComponents:components];
	components = [_GetSharedCalendar() components:NSDayCalendarUnit fromDate:date toDate:self options:0];
	OSSpinLockUnlock(&_calendarSpinLock);
	return components.day + 1;
}

- (NSDate*) dateRoundedToMidnight {
	NSUInteger year;
	NSUInteger month;
	NSUInteger day;
	[self getYear:&year month:&month day:&day];
	return [NSDate dateWithYear:year month:month day:day];
}

static NSDate* _GetReferenceDay() {
	static NSDate* date = nil;
	if (date == nil) {
		OSSpinLockLock(&_staticSpinLock);
		if (date == nil) {
			date = [NSDate dateWithYear:2001 month:1 day:1];
		}
		OSSpinLockUnlock(&_staticSpinLock);
	}
	return date;
}

+ (NSDate*) dateWithDaysSinceReferenceDate:(NSInteger)days {
	NSDate* date = _GetReferenceDay();
	NSDateComponents* components = [[NSDateComponents alloc] init];
	components.day = days;
	OSSpinLockLock(&_calendarSpinLock);
	date = [_GetSharedCalendar() dateByAddingComponents:components toDate:date options:0];
	OSSpinLockUnlock(&_calendarSpinLock);
	[components release];
	return date;
}

- (NSInteger) daysSinceReferenceDate {
	NSDate* date = _GetReferenceDay();
	OSSpinLockLock(&_calendarSpinLock);
	NSDateComponents* components = [_GetSharedCalendar() components:NSDayCalendarUnit fromDate:date toDate:self options:0];
	OSSpinLockUnlock(&_calendarSpinLock);
	return components.day;
}

// NSDateFormatter is not thread-safe so this function is protected with a spinlock
static NSDateFormatter* _GetDateFormatter(NSString* format, NSString* identifier, NSTimeZone* timeZone) {
	static NSMutableDictionary* cacheLevel0 = nil;
	if (cacheLevel0 == nil) {
		cacheLevel0 = [[NSMutableDictionary alloc] init];
	}

	NSMutableDictionary* cacheLevel1 = [cacheLevel0 objectForKey:(identifier ? identifier : @"")];
	if (cacheLevel1 == nil) {
		cacheLevel1 = [[NSMutableDictionary alloc] init];
		[cacheLevel0 setObject:cacheLevel1 forKey:(identifier ? identifier : @"")];
		[cacheLevel1 release];
	}

	NSMutableDictionary* cacheLevel2 = [cacheLevel1 objectForKey:(timeZone ? [timeZone name] : @"")];
	if (cacheLevel2 == nil) {
		cacheLevel2 = [[NSMutableDictionary alloc] init];
		[cacheLevel1 setObject:cacheLevel2 forKey:(timeZone ? [timeZone name] : @"")];
		[cacheLevel2 release];
	}

	NSDateFormatter* formatter = [cacheLevel2 objectForKey:format];
	if (formatter == nil) {
		formatter = [[NSDateFormatter alloc] init];
		formatter.locale = identifier ? [[[NSLocale alloc] initWithLocaleIdentifier:identifier] autorelease] : [NSLocale currentLocale];
		formatter.timeZone = timeZone ? timeZone : [NSTimeZone defaultTimeZone];
		formatter.dateFormat = format;
		[cacheLevel2 setObject:formatter forKey:format];
		[formatter release];
	}

	return formatter;
}

+ (NSDate*) dateWithString:(NSString*)string cachedFormat:(NSString*)format {
	return [self dateWithString:string cachedFormat:format localIdentifier:nil timeZone:nil];
}

+ (NSDate*) dateWithString:(NSString*)string cachedFormat:(NSString*)format localIdentifier:(NSString*)identifier {
	return [self dateWithString:string cachedFormat:format localIdentifier:identifier timeZone:nil];
}

+ (NSDate*) dateWithString:(NSString*)string
			  cachedFormat:(NSString*)format
		   localIdentifier:(NSString*)identifier
				  timeZone:(NSTimeZone*)timeZone {
	OSSpinLockLock(&_formattersSpinLock);
	NSDateFormatter* formatter = _GetDateFormatter(format, identifier, timeZone);
	NSDate* date = [formatter dateFromString:string];
	OSSpinLockUnlock(&_formattersSpinLock);
	return date;
}

- (NSString*) stringWithCachedFormat:(NSString*)format {
	return [self stringWithCachedFormat:format localIdentifier:nil timeZone:nil];
}

- (NSString*) stringWithCachedFormat:(NSString*)format localIdentifier:(NSString*)identifier {
	return [self stringWithCachedFormat:format localIdentifier:identifier timeZone:nil];
}
- (NSString*) stringWithCachedFormat:(NSString*)format localIdentifier:(NSString*)identifier timeZone:(NSTimeZone*)timeZone {
	OSSpinLockLock(&_formattersSpinLock);
	NSDateFormatter* formatter = _GetDateFormatter(format, identifier, timeZone);
	NSString* string = [formatter stringFromDate:self];
	OSSpinLockUnlock(&_formattersSpinLock);
	return string;
}

@end





