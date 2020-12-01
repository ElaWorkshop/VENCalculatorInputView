#import <UIKit/UIKit.h>

@class VENCalculatorInputView;
@protocol VENCalculatorInputViewDelegate <NSObject>

@optional
- (void)calculatorInputView:(VENCalculatorInputView *)inputView didTapKey:(NSString *)key;
- (void)calculatorInputViewDidTapBackspace:(VENCalculatorInputView *)calculatorInputView;
- (void)calculatorInputViewDidTapSave:(VENCalculatorInputView *)calculatorInputView;
@end

@interface VENCalculatorInputView : UIView <UIInputViewAudioFeedback>

@property (weak, nonatomic) id<VENCalculatorInputViewDelegate> delegate;

/**-----------------------------------------------------------------------------
 * @name Localization
 * -----------------------------------------------------------------------------
 */

/**-----------------------------------------------------------------------------
 * @name Customizing colors
 * -----------------------------------------------------------------------------
 */

@property (strong, nonatomic) UIColor *buttonTitleColor;
@property (strong, nonatomic) UIFont  *buttonTitleFont;

@property (strong, nonatomic) UIColor *numberButtonBackgroundColor;
@property (strong, nonatomic) UIColor *numberButtonBorderColor;
@property (strong, nonatomic) UIColor *numberButtonHighlightedColor;

@property (strong, nonatomic) UIColor *operationButtonBackgroundColor;
@property (strong, nonatomic) UIColor *operationButtonBorderColor;
@property (strong, nonatomic) UIColor *operationButtonHighlightedColor;

@property (strong, nonatomic) IBOutlet UIButton *decimalButton;

@property (nonatomic) BOOL savable;

- (void)toggleSavable:(BOOL)savable;

@end
