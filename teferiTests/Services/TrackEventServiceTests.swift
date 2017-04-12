import XCTest
import UserNotifications
import Nimble
import CoreLocation
@testable import teferi

class TrackEventServiceTests : XCTestCase
{
    private var trackEventService : DefaultTrackEventService!
    
    private var loggingService : MockLoggingService!
    private var locationService : MockLocationService!
    private var healthKitService : MockHealthKitService!
    private var persistencyService : BasePersistencyService<TrackEvent>!
    
    override func setUp()
    {
        self.loggingService = MockLoggingService()
        self.locationService = MockLocationService()
        self.healthKitService = MockHealthKitService()
        self.persistencyService = TrackEventPersistencyService(loggingService: self.loggingService,
                                                               locationPersistencyService: MockPersistencyService<Location>(),
                                                               healthSamplePersistencyService: MockPersistencyService<HealthSample>())
        
        self.trackEventService = DefaultTrackEventService(loggingService: self.loggingService,
                                                          persistencyService: self.persistencyService,
                                                          withEventSources: self.locationService,
                                                                            self.healthKitService)
    }
    
    func testNewEventsGetPersistedByTheTrackEventService()
    {
        let sample = HealthSample(withIdentifier: "something", startTime: Date(), endTime: Date(), value: nil)
        
        self.locationService.sendNewTrackEvent(CLLocation())
        self.locationService.sendNewTrackEvent(CLLocation())
        self.healthKitService.sendNewTrackEvent(sample)
        self.locationService.sendNewTrackEvent(CLLocation())
        self.healthKitService.sendNewTrackEvent(sample)
        
        let persistedEvents = self.trackEventService.getEventData(ofType: Location.self)
        expect(persistedEvents.count).to(equal(3))
    }
}