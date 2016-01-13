#import "VENMoneyCalculator.h"
#import "NSString+VENCalculatorInputView.h"

@interface VENMoneyCalculator ()
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@end

@implementation VENMoneyCalculator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.locale = [NSLocale currentLocale];
    }
    return self;
}

- (NSString *)evaluateExpression:(NSString *)expressionString {
    static NSCharacterSet *ops;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ops = [NSCharacterSet characterSetWithCharactersInString:@"+-/*"];
    });
    
    if (!expressionString) {
        return nil;
    }
    NSString *sanitizedString = [self sanitizedString:expressionString];
    NSRange opRange = [sanitizedString rangeOfCharacterFromSet:ops];
    if (opRange.location == NSNotFound) {
        // Simply a number, return as is
        return sanitizedString;
    }

    // We can guarantee such expression only have 1 op inside, simply switch on the op
    NSString *op = [sanitizedString substringWithRange:opRange];
    NSArray *nums = [sanitizedString componentsSeparatedByCharactersInSet:ops];
    if ([nums count] != 2) {
        return nil;
    }
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:nums[0]];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:nums[1]];
    NSDecimalNumber *result;
    @try {
        if ([op isEqualToString:@"+"]) {
            result = [num1 decimalNumberByAdding:num2];
        }
        else if ([op isEqualToString:@"-"]) {
            result = [num1 decimalNumberBySubtracting:num2];
        }
        else if ([op isEqualToString:@"/"]) {
            if ([num2 isEqualToValue:[NSDecimalNumber zero]]) {
                return @"0";
            }
            result = [num1 decimalNumberByDividingBy:num2];
        }
        else if ([op isEqualToString:@"*"]) {
            result = [num1 decimalNumberByMultiplyingBy:num2];
        }
    }
    @catch (NSException *exception) {
        return nil;
    }

    return [[self numberFormatter] stringFromNumber:result];
}

- (void)setLocale:(NSLocale *)locale {
    _locale = locale;
    self.numberFormatter.locale = locale;
}


#pragma mark - Private

- (NSNumberFormatter *)numberFormatter {
    if (!_numberFormatter) {
        _numberFormatter = [NSNumberFormatter new];
        [_numberFormatter setLocale:self.locale];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [_numberFormatter setCurrencySymbol:@""];
        [_numberFormatter setMaximumFractionDigits:2];
    }
    return _numberFormatter;
}

- (NSString *)sanitizedString:(NSString *)string {
    NSString *groupingSeperator = [self.locale objectForKey:NSLocaleGroupingSeparator];
    NSString *withoutGroupingSeperator = [string stringByReplacingOccurrencesOfString:groupingSeperator withString:@""];
    return [[self replaceOperandsInString:withoutGroupingSeperator] stringByReplacingCharactersInSet:[self illegalCharacters] withString:@""];
}

- (NSString *)replaceOperandsInString:(NSString *)string {
    NSString *subtractReplaced = [string stringByReplacingOccurrencesOfString:@"−" withString:@"-"];
    NSString *divideReplaced = [subtractReplaced stringByReplacingOccurrencesOfString:@"÷" withString:@"/"];
    NSString *multiplyReplaced = [divideReplaced stringByReplacingOccurrencesOfString:@"×" withString:@"*"];

    return [multiplyReplaced stringByReplacingOccurrencesOfString:[self decimalSeparator] withString:@"."];
}

- (NSCharacterSet *)illegalCharacters {
    return [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-/*.+"] invertedSet];
}

- (NSString *)decimalSeparator {
    return [self.locale objectForKey:NSLocaleDecimalSeparator];
}

@end
