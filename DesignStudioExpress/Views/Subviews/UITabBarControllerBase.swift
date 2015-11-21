//
//  UITabBarViewController.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/11/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import UIKit

class UITabBarControllerBase: UITabBarController {
    
    // tabbar style customization
    let higlightedItemColor = DesignStudioStyles.bottomNavigationIconSelected
    let barItemBackgroundColor = DesignStudioStyles.bottomNavigationBGColorUnselected
    let barItemBackgroundColorSelected = DesignStudioStyles.bottomNavigationBGColorSelected
    let tabBarHeight = CGFloat(60)
    
    let createDesignStudioNavTabIndex = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeStyle()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showDesignStudio:", name: "DesignStudioLoaded", object: nil)
    }
    
    func showDesignStudio(notification: NSNotification) {
        let userInfo = notification.userInfo as? [String: AnyObject]
        let designStudio = userInfo?["DesignStudio"] as? DesignStudio
        
        let navViewController = self.viewControllers![createDesignStudioNavTabIndex] as! UINavigationController
        let designStudioViewController = navViewController.viewControllers[0] as! DetailDesignStudioViewController
        
        designStudioViewController.vm.setDesignStudio(designStudio)
        
        navViewController.popToRootViewControllerAnimated(false)
        
        // jump to design studio tab
        self.selectedIndex = createDesignStudioNavTabIndex
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     * Customize the tab bar style
     */
    private func customizeStyle() {
        // Set empty background image, so that we can remove the tab bar shadow
        self.tabBar.backgroundImage = UIImage()
        // Set empty shadow image
        self.tabBar.shadowImage = UIImage()
        // make the tab bar not translucen, so that we can apply back. color
        self.tabBar.translucent = false
        
        // color for the highlighted item
        self.tabBar.tintColor = higlightedItemColor
        // color for the bar
        self.tabBar.barTintColor = barItemBackgroundColor
        
        // all bar icon assets are set to render as 'Original Image' to get the original item color
        // when the item is not selected
        // set the higlighted image (selected image) to be the same as original, but render it as a template
        // to get the colored version of the image
        self.tabBar.items?.forEach({ (tabBarItem) -> () in
            if let image = tabBarItem.image?.imageWithRenderingMode(.AlwaysTemplate) {
                tabBarItem.selectedImage = image
            }
            
            // remove the title and adjust the image position
            tabBarItem.title = "";
            tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        })
        
        // set the background color for the selected item
        let numOfItems = CGFloat(self.tabBar.items?.count ?? 1)
        let backgroundImage = UIImage.makeImageWithColorAndSize(self.barItemBackgroundColorSelected,
            size: CGSizeMake(tabBar.frame.width/numOfItems, self.tabBarHeight))
        self.tabBar.selectionIndicatorImage = backgroundImage
    }
    
    /**
     * Change the height of the bar
     */
    override func viewWillLayoutSubviews() {
        var tabBarFrame = self.tabBar.frame
        // default value is around 50
        tabBarFrame.size.height = self.tabBarHeight
        tabBarFrame.origin.y = self.view.frame.size.height - self.tabBarHeight
        self.tabBar.frame = tabBarFrame
    }
}

