import Foundation

extension Date
{
    //MARK: Properties

    ///Returns the day before the current date
    var yesterday : Date
    {
        return self.add(days: -1)
    }

    ///Returns the day after the current date
    var tomorrow : Date
    {
        return self.add(days: 1)
    }
    
    var firstDateOfMonth: Date
    {
        return self.add(days: -(self.day - 1)).ignoreTimeComponents()
    }
    //MARK: Methods
    
    /**
     Add (or subtract, if the value is negative) days to this date.
     
     - Parameter daysToAdd: Days to be added to the date.
     
     - Returns: A new date that is `daysToAdd` ahead of this one.
     */
    func add(days: Int? = nil, months: Int? = nil) -> Date
    {
        var dayComponent = DateComponents()
        dayComponent.day = days
        dayComponent.month = months
        
        let calendar = Calendar.current
        let nextDate = (calendar as NSCalendar).date(byAdding: dayComponent, to: self, options: NSCalendar.Options())!
        return nextDate
    }
    
    /**
     Ignores the time portion of the Date.
     
     - Returns: A new date whose time is always midnight.
     */
    func ignoreTimeComponents() -> Date
    {
        let units : NSCalendar.Unit = [ .year, .month, .day];
        let calendar = Calendar.current;
        return calendar.date(from: (calendar as NSCalendar).components(units, from: self))!
    }
    
    func ignoreDateComponents() -> Date
    {
        let units : NSCalendar.Unit = [ .hour, .minute, .second, .nanosecond];
        let calendar = Calendar.current;
        return calendar.date(from: (calendar as NSCalendar).components(units, from: self))!
    }
    
    //period -> .WeekOfYear, .Day
    func rangeOfPeriod(period: Calendar.Component) -> (Date, Date)
    {
        var startDate = Date()
        var interval: TimeInterval = 0
        let _ = Calendar.current.dateInterval(of: period,
                                              start: &startDate, interval: &interval, for: self)
        let endDate = startDate.addingTimeInterval(interval - 1)
        return (startDate, endDate)
    }
    
    var daysInMonth : Int
    {
        let dateComponents = DateComponents(year: self.year, month: self.month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    var dayOfWeek : Int { return Calendar.current.component(.weekday, from: self) - 1 }
    
    var second : Int { return Calendar.current.component(.second, from: self) }
    
    var minute : Int { return Calendar.current.component(.minute, from: self) }
    
    var hour : Int { return Calendar.current.component(.hour, from: self) }
    
    var day : Int { return Calendar.current.component(.day, from: self) }
    
    var weekOfYear : Int { return Calendar.current.component(.weekOfYear, from: self) }
    
    var month : Int { return Calendar.current.component(.month, from: self) }
    
    var year: Int { return Calendar.current.component(.year, from: self) }
    
    var formatedShortStyle: String
    {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
    
    func differenceInDays(toDate date: Date) -> Int
    {
        let calendar = Calendar.current
        let units = Set<Calendar.Component>([ .day]);
        
        let components = calendar.dateComponents(units, from: ignoreTimeComponents(), to: date.ignoreTimeComponents())

        return components.day!
    }
    
    func isSameDay(asDate date: Date) -> Bool
    {
        return differenceInDays(toDate: date) == 0
    }
    
    func convert(calendarUnits: NSCalendar.Unit, sameAs date: Date) -> Date
    {
        let currentUnits : NSCalendar.Unit = [ .year, .month, .day, .hour, .minute, .second, .nanosecond]
        let calendar = Calendar.current
        
        var currentComponents = (calendar as NSCalendar).components(currentUnits, from: self)
        let newComponents = (calendar as NSCalendar).components(calendarUnits, from: date)
        
        currentComponents.year = newComponents.year
        currentComponents.month = newComponents.month
        currentComponents.day = newComponents.day
        
        return calendar.date(from: currentComponents)!
    }
    
    func absoluteTimeIntervalIgnoringDateSince(_ date: Date) -> TimeInterval
    {
        let baseTime = self.ignoreDateComponents()
        let timeToCompare = date.ignoreDateComponents()
        
        let differenceIfPreviousDay = abs(baseTime.timeIntervalSince(timeToCompare.add(days: -1)))
        let differenceIfSameDay = abs(baseTime.timeIntervalSince(timeToCompare))
        let differenceIfNextDay = abs(baseTime.timeIntervalSince(timeToCompare.add(days: 1)))
        
        return min(differenceIfPreviousDay, differenceIfSameDay, differenceIfNextDay)
    }
    
    func setHour(_ hour: Int, minute: Int = 0, second: Int = 0) -> Date
    {
        let calendar = Calendar.current
        var components = calendar.dateComponents(Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second]), from: self)
        components.hour = hour
        components.minute = minute
        components.second = second
        return calendar.date(from: components)!
    }
    
    static func create(weekday: Int, hour: Int, minute: Int, second: Int) -> Date
    {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.second = second
        components.weekday = weekday
        components.weekdayOrdinal = 10
        components.timeZone = .current
        
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: components)!
    }
    
    static func createTime(hour: Int, minute: Int, second: Int = 0) -> Date
    {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.second = second
        components.timeZone = .current
        
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: components)!.ignoreDateComponents()
    }
}
