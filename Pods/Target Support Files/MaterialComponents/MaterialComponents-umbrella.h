#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MaterialActivityIndicator.h"
#import "MDCActivityIndicator+Interface.h"
#import "MDCActivityIndicator.h"
#import "MDCActivityIndicatorDelegate.h"
#import "CAMediaTimingFunction+MDCAnimationTiming.h"
#import "MaterialAnimationTiming.h"
#import "UIView+MDCTimingFunction.h"
#import "MaterialAvailability.h"
#import "MDCAvailability.h"
#import "MaterialPalettes.h"
#import "MDCPalettes.h"
#import "MaterialTextControls+BaseTextFields.h"
#import "MDCBaseTextField.h"
#import "MDCBaseTextFieldDelegate.h"
#import "MaterialTextControls+Enums.h"
#import "MDCTextControlLabelBehavior.h"
#import "MDCTextControlState.h"
#import "MaterialTextControls+FilledTextFields.h"
#import "MDCFilledTextField.h"
#import "MaterialApplication.h"
#import "UIApplication+MDCAppExtensions.h"
#import "MaterialMath.h"
#import "MDCMath.h"
#import "MaterialTextControlsPrivate+BaseStyle.h"
#import "MDCTextControlStyleBase.h"
#import "MDCTextControlVerticalPositioningReferenceBase.h"
#import "MaterialTextControlsPrivate+FilledStyle.h"
#import "MDCTextControlStyleFilled.h"
#import "MDCTextControlVerticalPositioningReferenceFilled.h"
#import "MaterialTextControlsPrivate+Shared.h"
#import "MDCTextControl.h"
#import "MDCTextControlAssistiveLabelDrawPriority.h"
#import "MDCTextControlAssistiveLabelView.h"
#import "MDCTextControlAssistiveLabelViewLayout.h"
#import "MDCTextControlColorViewModel.h"
#import "MDCTextControlGradientManager.h"
#import "MDCTextControlHorizontalPositioning.h"
#import "MDCTextControlHorizontalPositioningReference.h"
#import "MDCTextControlLabelAnimation.h"
#import "MDCTextControlLabelSupport.h"
#import "MDCTextControlPlaceholderSupport.h"
#import "MDCTextControlSideViewSupport.h"
#import "MDCTextControlVerticalPositioningReference.h"
#import "UIBezierPath+MDCTextControlStyle.h"
#import "MaterialTextControlsPrivate+TextFields.h"
#import "MDCBaseTextFieldLayout.h"
#import "MDCTextControlTextField.h"
#import "MDCTextControlTextFieldSideViewAlignment.h"
#import "MaterialTextControlsPrivate+UnderlinedStyle.h"
#import "MDCTextControlStyleUnderlined.h"
#import "MDCTextControlVerticalPositioningReferenceUnderlined.h"

FOUNDATION_EXPORT double MaterialComponentsVersionNumber;
FOUNDATION_EXPORT const unsigned char MaterialComponentsVersionString[];

