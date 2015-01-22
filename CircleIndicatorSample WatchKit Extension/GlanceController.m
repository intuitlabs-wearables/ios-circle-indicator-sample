//
//  GlanceController.m
//  CircleIndicatorSample WatchKit Extension
//
//  Created by Osmon, Cindy on 1/20/15.
//
//  Copyright (c) 1/2/15 Intuit Inc. All rights reserved. Unauthorized reproduction is a
//  violation of applicable law. This material contains certain confidential and proprietary
//  information and trade secrets of Intuit Inc.
//
#import "GlanceController.h"
@import IntuitWearKit;

/*!
 * @class GlanceController
 *
 * @discussion This class is the View Controller for an Apple Watch Glance.
 *             It controls drawing the Circle Indicator based on the total
 *             item count and the number of completed items.
 */
@interface GlanceController()
/*!
 *  @discussion These properties track the underlying values that represent the Circle Indicator.
 */
@property (nonatomic) NSInteger presentedTotalListItemCount;
@property (nonatomic) NSInteger presentedCompleteListItemCount;
@end

//const NSInteger IWGlanceInterfaceControllerCountUndefined = -1;

@implementation GlanceController

#pragma mark - Initializers

- (instancetype)initWithContext:(id)context {
    self = [super initWithContext:context];
    if (self){
        // Initialize variables here.
        GlanceStyle *glanceStyle = [self glanceStyleData];

        // Configure interface objects here.
        NSLog(@"%@ initWithContext", self);
        
        // Set the data fields for the Circle Indicator from the
        // GlanceStyle object obtained from NSUserDefaults data that
        // is shared between the iOS Phone App and the Glance.
        _presentedTotalListItemCount = glanceStyle.glanceTotalItemCount;
        
        _presentedCompleteListItemCount = glanceStyle.glanceCompletedItemsCount;
        
        [_glanceHeaderLabel setText:glanceStyle.glanceHeaderLabelText];
        
        NSLog(@"Watch Kit Extention for Glance : totalItemCount = %ld", _presentedTotalListItemCount);
        
        NSLog(@"Watch Kit Extention for Glance : completed ItemCount = %ld", _presentedCompleteListItemCount);
        
    }
    return self;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    NSLog(@"%@ will activate", self);
    
    [self drawGlanceWidget:[self glanceStyleData]];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    NSLog(@"%@ did deactivate", self);
}

/*!
 * @discussion Draws the Circle Indicator animation based on the data from
 *             the input GlanceStyle object.
 *
 * @param glancestyle The GlanceStyle object used to share data from the iOS Phone app and the Glance.
 * @return void
 */
- (void) drawGlanceWidget:(GlanceStyle *)glanceStyle {
    
    //Construct and draw the updated widget
    IWGlanceCircleIndicator *glanceWidget = [[IWGlanceCircleIndicator alloc] initWithGlanceStyle:glanceStyle];
    [self.glanceWidgetGroup setBackgroundImage:glanceWidget.groupBackgroundImage];
    [self.glanceWidgetImage setImageNamed:glanceWidget.imageName];
    NSRange imageRange = glanceWidget.imageRange;
    NSLog(@"my range is %@", NSStringFromRange(imageRange));
    [self.glanceWidgetImage startAnimatingWithImagesInRange:glanceWidget.imageRange duration:glanceWidget.animationDuration repeatCount:1];
}

/*!
 * @discussion Draws the Circle Indicator animation based the total item count and
 *             the number of completed items
 * @param totalItemCount The total item count of the Circle Indicator
 * @param numberComplete Number of completed items out of the total.
 * @return void
 */
- (void) drawGlanceWidget:(NSInteger)totalItemCount withNumberCompleted:(NSInteger)numberComplete {
    
    //Construct and draw the updated widget
    IWGlanceCircleIndicator *glanceWidget = [[IWGlanceCircleIndicator alloc] initWithTotalItemCountAndColor:totalItemCount completeItemCount:numberComplete color:0];
    
    [self.glanceWidgetGroup setBackgroundImage:glanceWidget.groupBackgroundImage];
    [self.glanceWidgetImage setImageNamed:glanceWidget.imageName];
    [self.glanceWidgetImage startAnimatingWithImagesInRange:glanceWidget.imageRange duration:glanceWidget.animationDuration repeatCount:1];
}

/*!
 * @discussion This method retrieves the GlanceStyle object from NSUserDefaults so it
 *             can share data between the iOS Phone App and the Glance.
 *
 * @return The GlanceStyle object from NSUserDefaults.
 */
- (GlanceStyle *)glanceStyleData {
    NSUserDefaults *userDefault=[[NSUserDefaults alloc] initWithSuiteName:IWAppConfigurationApplicationGroupsPrimary];
    NSData *myDecodedObject = [userDefault objectForKey: IWAppConfigurationIWContentUserDefaultsKey];
    IWearNotificationContent *glanceContent = [NSKeyedUnarchiver unarchiveObjectWithData: myDecodedObject];
    
    return glanceContent.glanceStyle;
}

@end


