import Foundation

class TimelineMerger : TemporaryTimelineGenerator
{
    private let timelineGenerators : [TemporaryTimelineGenerator]
    
    init(withTimelineGenerators timelineGenerators: TemporaryTimelineGenerator...)
    {
        self.timelineGenerators = timelineGenerators
    }
    
    func generateTemporaryTimeline() -> [TemporaryTimeSlot]
    {
        let timelines = self.timelineGenerators
                            .map { $0.generateTemporaryTimeline() }
    
        let flatTimeline = timelines.flatMap { $0 }
        let startTimes =  flatTimeline.map { $0.start }
        let endTimes = flatTimeline.flatMap { $0.end }
        
        let timeline = (startTimes + endTimes)
                        .distinct()
                        .sorted(by: <)
                        .reduce([TemporaryTimeSlot](), self.toSingleTimeline(using: timelines))
        
        return timeline
    }
    
    private func toSingleTimeline(using timelines: [[TemporaryTimeSlot]]) -> ([TemporaryTimeSlot], Date) -> [TemporaryTimeSlot]
    {
        return { timeline, currentTime in
            
            var result = timeline
        
            let intersectedTimeSlots = timelines.flatMap(self.toFirstTimeSlot(thatIntersects: currentTime))
            let bestTimeSlot =  self.getTimeSlotWithBestCategory(inIntersectedTimeslots: intersectedTimeSlots)
        
            if let previousTimeSlot = result.last
            {
                result[result.count - 1] = previousTimeSlot.with(end: currentTime)
            }
        
            let location = bestTimeSlot?.location ?? intersectedTimeSlots.first(where: { $0.location != nil })?.location
            
            result.append(TemporaryTimeSlot(start: currentTime,
                                            end: nil,
                                            smartGuess: bestTimeSlot?.smartGuess,
                                            category: bestTimeSlot?.category ?? .unknown,
                                            location: location))
            
            return result
        }
    }

    private func toFirstTimeSlot(thatIntersects time: Date) -> ([TemporaryTimeSlot]) -> TemporaryTimeSlot?
    {
        return { timeline in
            
            guard let timeSlot = timeline.first(where: { $0.start <= time && ($0.end == nil || $0.end! > time) }) else
            {
                return nil
            }
            
            return timeSlot
        }
    }
    
    private func getTimeSlotWithBestCategory(inIntersectedTimeslots timeSlots: [TemporaryTimeSlot]) -> TemporaryTimeSlot?
    {
        var bestTemporaryTimeSlot : TemporaryTimeSlot?
        
        for timeSlot in timeSlots
        {
            switch timeSlot.category
            {
                case .unknown:
                    continue
                case .commute:
                    break
                default:
                
                    guard let currentBest = bestTemporaryTimeSlot else { break }
                    
                    if currentBest.category == .commute { continue }
                    
                    //If we can't decide, we stick to the one with a SmartGuess
                    if currentBest.smartGuess != nil || timeSlot.smartGuess == nil { continue }
                    
                    break
            }
            
            bestTemporaryTimeSlot = timeSlot
        }
        
        return bestTemporaryTimeSlot ?? timeSlots.first
    }
}
