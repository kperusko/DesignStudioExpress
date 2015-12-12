//
//  EndActivityViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/8/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

class EndActivityViewModel {
    var didAddMoreTime = false
    
    func viewDidDisappear() {
        if self.didAddMoreTime {
            AppDelegate.designStudio.addMoreTimeViewDidDisappear()
        } else {
            AppDelegate.designStudio.endCurrentActivityViewDidDisappear()
        }
    }
        
    func addMoreTime() {
        self.didAddMoreTime = true
    }
}