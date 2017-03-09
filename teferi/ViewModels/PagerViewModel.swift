import RxSwift
import Foundation

class PagerViewModel
{
    //MARK: Fields
    private let timeService : TimeService
    private let settingsService : SettingsService
    private let appLifecycleService : AppLifecycleService
    private var selectedDateService : SelectedDateService
    
    init(timeService: TimeService,
         settingsService: SettingsService,
         editStateService: EditStateService,
         appLifecycleService: AppLifecycleService,
         selectedDateService: SelectedDateService)
    {
        self.timeService = timeService
        self.appLifecycleService = appLifecycleService
        self.settingsService = settingsService
        self.selectedDateService = selectedDateService
        
        self.selectedDate = timeService.now
        
        self.isEditingObservable = editStateService.isEditingObservable
    }
    
    //MARK: Properties
    private(set) lazy var dateObservable : Observable<DateChange> =
    {
        return self.selectedDateService
            .currentlySelectedDateObservable
            .map(self.toDateChange)
            .filterNil()
    }()
    
    //MARK: Properties
    let isEditingObservable : Observable<Bool>
    
    var currentDate : Date { return self.timeService.now }
    
    private(set) lazy var refreshObservable : Observable<Void> =
    {
        return self.appLifecycleService
            .lifecycleEventObservable
            .filter(self.shouldRefreshView)
            .map { _ in () }
    }()
    
    private var selectedDate : Date
    var currentlySelectedDate : Date
    {
        get { return self.selectedDate.ignoreTimeComponents() }
        set(value)
        {
            self.selectedDate = value
            self.selectedDateService.currentlySelectedDate = value
        }
    }
    
    //Methods
    func canScroll(toDate date: Date) -> Bool
    {
        let minDate = self.settingsService.installDate!.ignoreTimeComponents()
        let maxDate = self.timeService.now.ignoreTimeComponents()
        let dateWithNoTime = date.ignoreTimeComponents()
        
        return dateWithNoTime >= minDate && dateWithNoTime <= maxDate
    }
    
    private func shouldRefreshView(onLifecycleEvent event: LifecycleEvent) -> Bool
    {
        switch event
        {
            case .movedToForeground:
                let today = self.timeService.now.ignoreTimeComponents()
                
                guard let inactiveDate = self.settingsService.lastInactiveDate,
                    today > inactiveDate.ignoreTimeComponents() else { return false }
                
                self.settingsService.setLastInactiveDate(nil)
                return true
            
            case .movedToBackground:
                self.settingsService.setLastInactiveDate(self.timeService.now)
                break
            
            case .invalidatedUiState:
                self.settingsService.setLastInactiveDate(nil)
                return true
            
            case .receivedNotification:
                return true
        }
        
        return false
    }
    
    private func toDateChange(_ date: Date) -> DateChange?
    {
        if date.ignoreTimeComponents() != self.currentlySelectedDate
        {
            let dateChange = DateChange(newDate: date, oldDate: self.selectedDate)
            self.selectedDate = date
            
            return dateChange
        }
        
        return nil
    }
}
