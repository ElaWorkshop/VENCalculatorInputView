#import "VENCalculatorInputView.h"

@interface VENCalculatorInputView ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numberButtonCollection;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *operationButtonCollection;

@property (nonatomic) IBOutlet UIButton *equalSaveButton;

@end

@implementation VENCalculatorInputView

- (id)initWithFrame:(CGRect)frame {
    self = [[[NSBundle bundleForClass:[self class]]  loadNibNamed:@"VENCalculatorInputView" owner:self options:nil] firstObject];
    if (self) {
        // Set default locale
        self.locale = [NSLocale currentLocale];

        // Set customizable properties
        [self setNumberButtonBackgroundColor:[UIColor colorWithWhite:0.98828 alpha:1]];
        [self setNumberButtonBorderColor:[UIColor colorWithWhite:0.75 alpha:1]];
        [self setNumberButtonHighlightedColor:[UIColor colorWithRed:0.82 green:0.84 blue:0.86 alpha:1]];
        [self setOperationButtonBackgroundColor:[UIColor colorWithRed:0.82 green:0.84 blue:0.86 alpha:1]];
        [self setOperationButtonBorderColor:[UIColor colorWithWhite:0.65 alpha:1]];
        [self setOperationButtonHighlightedColor:[UIColor whiteColor]];
        [self setButtonTitleColor:[UIColor darkTextColor]];

        // Set default properties
        for (UIButton *numberButton in self.numberButtonCollection) {
            [self setupButton:numberButton];
        }
        for (UIButton *operationButton in self.operationButtonCollection) {
            [self setupButton:operationButton];
        }
    }
    return self;
}

- (void)setLocale:(NSLocale *)locale {
    _locale = locale;
    NSString *decimalSymbol = [locale objectForKey:NSLocaleDecimalSeparator];
    [self.decimalButton setTitle:decimalSymbol forState:UIControlStateNormal];
}

- (void)setupButton:(UIButton *)button {
    button.layer.borderWidth = 0.25f;
}

- (IBAction)userDidTapBackspace:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    if ([self.delegate respondsToSelector:@selector(calculatorInputViewDidTapBackspace:)]) {
        [self.delegate calculatorInputViewDidTapBackspace:self];
    }
}

- (IBAction)userDidTapKey:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    if (self.savable && [sender isEqual:self.equalSaveButton]) {
        if ([self.delegate respondsToSelector:@selector(calculatorInputViewDidTapSave:)]) {
            [self.delegate calculatorInputViewDidTapSave:self];
        }
    }
    else if ([self.delegate respondsToSelector:@selector(calculatorInputView:didTapKey:)]) {
        [self.delegate calculatorInputView:self didTapKey:sender.titleLabel.text];
    }
}


#pragma mark - UIInputViewAudioFeedback

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}


#pragma mark - Helpers

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    [color set];
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - Properties

- (void)setButtonTitleColor:(UIColor *)buttonTitleColor {
    _buttonTitleColor = buttonTitleColor;
    for (UIButton *numberButton in self.numberButtonCollection) {
        [numberButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    }
    for (UIButton *operationButton in self.operationButtonCollection) {
        [operationButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    }
}

- (void)setButtonTitleFont:(UIFont *)buttonTitleFont {
    _buttonTitleFont = buttonTitleFont;
    for (UIButton *numberButton in self.numberButtonCollection) {
        numberButton.titleLabel.font = buttonTitleFont;
    }
    for (UIButton *operationButton in self.operationButtonCollection) {
        operationButton.titleLabel.font = buttonTitleFont;
    }
}

- (void)setNumberButtonBackgroundColor:(UIColor *)numberButtonBackgroundColor {
    _numberButtonBackgroundColor = numberButtonBackgroundColor;
    for (UIButton *numberButton in self.numberButtonCollection) {
        numberButton.backgroundColor = numberButtonBackgroundColor;
    }
}

- (void)setNumberButtonBorderColor:(UIColor *)numberButtonBorderColor {
    _numberButtonBorderColor = numberButtonBorderColor;
    for (UIButton *numberButton in self.numberButtonCollection) {
        numberButton.layer.borderColor = numberButtonBorderColor.CGColor;
    }
}

- (void)setNumberButtonHighlightedColor:(UIColor *)buttonHighlightedColor {
    _numberButtonHighlightedColor = buttonHighlightedColor;
    for (UIButton *numberButton in self.numberButtonCollection) {
        [numberButton setBackgroundImage:[self imageWithColor:buttonHighlightedColor size:CGSizeMake(50, 50)]
                                forState:UIControlStateHighlighted];
    }
}

- (void)setOperationButtonBackgroundColor:(UIColor *)operationButtonBackgroundColor {
    _operationButtonBackgroundColor = operationButtonBackgroundColor;
    for (UIButton *operationButton in self.operationButtonCollection) {
        operationButton.backgroundColor = operationButtonBackgroundColor;
    }
}

- (void)setOperationButtonBorderColor:(UIColor *)operationButtonBorderColor {
    _operationButtonBorderColor = operationButtonBorderColor;
    for (UIButton *operationButton in self.operationButtonCollection) {
        operationButton.layer.borderColor = operationButtonBorderColor.CGColor;
    }
}

- (void)setOperationButtonHighlightedColor:(UIColor *)buttonHighlightedColor {
    _operationButtonHighlightedColor = buttonHighlightedColor;
    for (UIButton *operationButton in self.operationButtonCollection) {
        [operationButton setBackgroundImage:[self imageWithColor:buttonHighlightedColor size:CGSizeMake(50, 50)]
                                   forState:UIControlStateHighlighted];
    }
}

- (void)toggleSavable:(BOOL)savable {
    self.savable = savable;
    if (self.savable) {
        self.equalSaveButton.backgroundColor = [UIColor colorWithRed:0.56 green:0.82 blue:0.14 alpha:1];
        self.equalSaveButton.tintColor = [UIColor whiteColor];
        UIImage *checkImage = [UIImage imageNamed:@"check" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        checkImage = [checkImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.equalSaveButton setImage:checkImage forState:UIControlStateNormal];
        [self.equalSaveButton setImage:checkImage forState:UIControlStateHighlighted];
        [self.equalSaveButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.62 green:0.89 blue:0.32 alpha:1] size:CGSizeMake(50, 50)]
                                        forState:UIControlStateHighlighted];
        [self.equalSaveButton setTitle:nil forState:UIControlStateNormal];
    }
    else {
        self.equalSaveButton.backgroundColor = self.operationButtonBackgroundColor;
        [self.equalSaveButton setImage:nil forState:UIControlStateNormal];
        [self.equalSaveButton setImage:nil forState:UIControlStateHighlighted];
        [self.equalSaveButton setBackgroundImage:[self imageWithColor:self.operationButtonHighlightedColor size:CGSizeMake(50, 50)]
                                        forState:UIControlStateHighlighted];
        [self.equalSaveButton setTitle:@"=" forState:UIControlStateNormal];
    }
}

@end
