//
//  TimerViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/3/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation

class TimerViewModel {
    
    func setDesignStudio(designStudio: DesignStudio) {
        AppDelegate.designStudio.startDesignStudio(designStudio)
    }
    
    var currentChallenge: Challenge? {
        get { return AppDelegate.designStudio.currentChallenge }
    }
    
    var challengeTitle: String {
        get { return AppDelegate.designStudio.currentChallenge?.title ?? "" }
    }
    
    var activityTitle: String {
         get { return AppDelegate.designStudio.currentActivity?.title ?? "" }
    }
    
    var activityDescription: String {
        get { return AppDelegate.designStudio.currentActivity?.activityDescription ?? "" }
    }
    
    var activityNotes: String {
        get { return AppDelegate.designStudio.currentActivity?.notes ?? "" }
    }
    
}