//
//  ChallengeDetailViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 11/21/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

import Foundation
import RealmSwift

class ChallengeDetailViewModel {
    
    lazy var realm = try! Realm()
    private var data: Challenge!
        
    func setChallenge(newChallenge: Challenge) {
        self.data = newChallenge
    }
    
    var getTotalRows: Int {
        get {
            // first cell is a header cell
            return self.data.activities.count + 1
        }
    }
    
    var challengeTitle: String {
        get {
            return self.data!.title
        }
        set {
            try! realm.write {
                self.data.title = newValue
            }
        }
    }
    
    var challengeDescription: String {
        get {
            return data!.challengeDescription
        }
        set {
            try! realm.write {
                self.data.challengeDescription = newValue
            }
        }
    }

    var challengeDuration: String {
        get {
            if data!.duration == 0 {
                return "00"
            }
            return "Duration: \(data!.duration) min"
        }
    }
    
    func isRowEditable(indexPath: NSIndexPath) -> Bool {
        return indexPath.row > 0
    }
    
    func activityTitle(indexPath: NSIndexPath) -> String {
        if self.isRowEditable(indexPath) {
            return data.activities[indexPath.row-1].title
        }
        return ""
    }
    
    func activityDescription(indexPath: NSIndexPath) -> String {
        if self.isRowEditable(indexPath) {
            return data.activities[indexPath.row-1].activityDescription
        }
        return ""
    }
    
    func activityDuration(indexPath: NSIndexPath) -> String {
        if self.isRowEditable(indexPath) {
            return "\(data.activities[indexPath.row-1].duration)"
        }
        return ""
    }
    
    func activityDetails(indexPath: NSIndexPath) -> String {
        if self.isRowEditable(indexPath) {
            if data.activities[indexPath.row-1].notes != "" {
                return "1 presenter note"
            }
            return "0 presenter notes"
        }
        return ""
    }
}