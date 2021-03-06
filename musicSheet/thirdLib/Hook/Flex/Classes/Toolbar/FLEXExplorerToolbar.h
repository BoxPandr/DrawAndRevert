//
//  FLEXExplorerToolbar.h
//  Flipboard
//
//  Created by Ryan Olson on 4/4/14.
//  Copyright (c) 2014 Flipboard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLEXToolbarItem;


// 要改的高度, 在这里


@interface FLEXExplorerToolbar : UIView

/// The items to be displayed in the toolbar. Defaults to:
/// globalsItem, hierarchyItem, selectItem, moveItem, closeItem
@property (nonatomic, copy) NSArray<FLEXToolbarItem *> *toolbarItems;

/// Toolbar item for selecting views.
/// Users of the toolbar can configure the enabled/selected state and event targets/actions.
@property (nonatomic, readonly) FLEXToolbarItem *selectItem;

/// Toolbar item for presenting a list with the view hierarchy.
/// Users of the toolbar can configure the enabled state and event targets/actions.
@property (nonatomic, readonly) FLEXToolbarItem *hierarchyItem;

/// Toolbar item for moving views.
/// Users of the toolbar can configure the enabled/selected state and event targets/actions.
@property (nonatomic, readonly) FLEXToolbarItem *moveItem;




// 菜单，全局按钮 globalsItem


/// Toolbar item for inspecting details of the selected view.
/// Users of the toolbar can configure the enabled state and event targets/actions.
@property (nonatomic, readonly) FLEXToolbarItem *globalsItem;

/// Toolbar item for hiding the explorer.
/// Users of the toolbar can configure the event targets/actions.
@property (nonatomic, readonly) FLEXToolbarItem *closeItem;

/// A view for moving the entire toolbar.
/// Users of the toolbar can attach a pan gesture recognizer to decide how to reposition the toolbar.
@property (nonatomic, readonly) UIView *dragHandle;

/// A color matching the overlay on color on the selected view.
@property (nonatomic) UIColor *selectedViewOverlayColor;

/// Description text for the selected view displayed below the toolbar items.
@property (nonatomic, copy) NSString *selectedViewDescription;

/// Area where details of the selected view are shown
/// Users of the toolbar can attach a tap gesture recognizer to show additional details.
@property (nonatomic, readonly) UIView *selectedViewDescriptionContainer;

@end
