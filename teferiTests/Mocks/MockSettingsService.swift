import Foundation
import RxSwift
@testable import teferi

class MockSettingsService : SettingsService
{
    var lastShownGoalSuggestion: Date?
    
    //MARK: Properties
    var nextSmartGuessId = 0
    var installDate : Date? = Date()
    var lastInactiveDate : Date? = nil
    var lastLocation : Location? = nil
    var lastTimelineGenerationDate: Date? = nil
    var userEverGaveLocationPermission : Bool = false
    var userEverGaveMotionPermission: Bool = false
    var didShowWelcomeMessage : Bool = true
    var lastShownWeeklyRating : Date? = Date()
    var lastUsedGoalAchivedMessageAndDate: [Date : String]?
    var lastShownAddGoalAlert : Date? = Date()
    var versionNumber: String = ""
    var buildNumber: String = ""
    var lastGoalLoggingDate: Date? = nil

    var motionPermissionGranted: Observable<Bool> = Observable<Bool>.empty()
    
    var hasLocationPermission = true
    var hasNotificationPermission: Observable<Bool> = Observable.just(true)
    var userRejectedNotificationPermission = false
    var didAlreadyShowRequestForNotificationsInNewGoal = false
    var shouldAskForNotificationPermission = false
    var hasCoreMotionPermission = true
    var isFirstTimeAppRuns = false
    var isPostCoreMotionUser = true
    
        
    //MARK: Methods
    func setIsFirstTimeAppRuns()
    {
        isFirstTimeAppRuns = false
    }
    
    func setIsPostCoreMotionUser()
    {
        isPostCoreMotionUser = true
    }
        
    //MARK: Methods
    func setInstallDate(_ date: Date)
    {
        installDate = date
    }
    
    func setLastLocation(_ location: Location)
    {
        lastLocation = location
    }
    
    func setLastTimelineGenerationDate(_ date: Date)
    {
        lastTimelineGenerationDate = date
    }
    
    func getNextSmartGuessId() -> Int
    {
        return nextSmartGuessId
    }
    
    func incrementSmartGuessId()
    {
        nextSmartGuessId += 1
    }
    
    func setUserGaveLocationPermission()
    {
        userEverGaveLocationPermission = true
    }
    
    func setCoreMotionPermission(userGavePermission: Bool)
    {
        hasCoreMotionPermission = userGavePermission
    }
    
    func setUserRejectedNotificationPermission()
    {
        hasNotificationPermission = Observable.just(false)
    }
    
    func setShouldAskForNotificationPermission()
    {
        shouldAskForNotificationPermission = true
    }
    
    func setDidAlreadyShowRequestForNotificationsInNewGoal()
    {
        didAlreadyShowRequestForNotificationsInNewGoal = true
    }
    
    func setWelcomeMessageShown()
    {
        didShowWelcomeMessage = true
    }
    
    func setVote(forDate date: Date)
    {
        
    }
    
    func lastSevenDaysOfVotingHistory() -> [Date]
    {
        return []
    }
    
    func setLastShownWeeklyRating(_ date: Date)
    {
        lastShownWeeklyRating = date
    }
    
    func setLastUsedGoalAchivedMessageAndDate(_ data: [Date : String])
    {
        lastUsedGoalAchivedMessageAndDate = data
    }

    func setLastShownAddGoalAlert(_ date: Date)
    {
        lastShownAddGoalAlert = date
    }

    func setLastShownGoalSuggestion(_ date: Date)
    {
        lastShownGoalSuggestion = date
    }
    
    func setLastGoalLoggingDate(_ date: Date)
    {
        lastGoalLoggingDate = date
    }
    
}
