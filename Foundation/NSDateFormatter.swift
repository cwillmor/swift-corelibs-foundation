// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

import CoreFoundation

public class NSDateFormatter : NSFormatter {
    typealias CFType = CFDateFormatter
    private var __cfObject: CFType?
    private var _cfObject: CFType {
        guard let obj = __cfObject else {
            #if os(OSX) || os(iOS)
                let dateStyle = CFDateFormatterStyle(rawValue: CFIndex(self.dateStyle.rawValue))!
                let timeStyle = CFDateFormatterStyle(rawValue: CFIndex(self.timeStyle.rawValue))!
            #else
                let dateStyle = CFDateFormatterStyle(self.dateStyle.rawValue)
                let timeStyle = CFDateFormatterStyle(self.timeStyle.rawValue)
            #endif
            
            let obj = CFDateFormatterCreate(kCFAllocatorSystemDefault, locale._cfObject, dateStyle, timeStyle)
            _setFormatterAttributes(obj)
            if let dateFormat = _dateFormat {
                CFDateFormatterSetFormat(obj, dateFormat._cfObject)
            }
            __cfObject = obj
            return obj
        }
        return obj
    }

    public override init() {
        super.init()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public var formattingContext: NSFormattingContext = .Unknown // default is NSFormattingContextUnknown

    public func objectValue(_ string: String, range rangep: UnsafeMutablePointer<NSRange>) throws -> AnyObject? { NSUnimplemented() }

    public override func stringForObjectValue(_ obj: AnyObject) -> String? {
        guard let date = obj as? NSDate else { return nil }
        return string(from: date)
    }

    public func string(from date: NSDate) -> String {
        return CFDateFormatterCreateStringWithDate(kCFAllocatorSystemDefault, _cfObject, date._cfObject)._swiftObject
    }

    public func dateFromString(_ string: String) -> NSDate? {
        var range = CFRange(location: 0, length: string.length)
        let date = withUnsafeMutablePointer(&range) { (rangep: UnsafeMutablePointer<CFRange>) -> NSDate? in
            guard let res = CFDateFormatterCreateDateFromString(kCFAllocatorSystemDefault, _cfObject, string._cfObject, rangep) else {
                return nil
            }
            return res._nsObject
        }
        return date
    }

    public class func localizedString(from date: NSDate, dateStyle dstyle: NSDateFormatterStyle, timeStyle tstyle: NSDateFormatterStyle) -> String {
        let df = NSDateFormatter()
        df.dateStyle = dstyle
        df.timeStyle = tstyle
        return df.stringForObjectValue(date)!
    }

    public class func dateFormat(fromTemplate tmplate: String, options opts: Int, locale: NSLocale?) -> String? {
        guard let res = CFDateFormatterCreateDateFormatFromTemplate(kCFAllocatorSystemDefault, tmplate._cfObject, CFOptionFlags(opts), locale?._cfObject) else {
            return nil
        }
        return res._swiftObject
    }

    public func setLocalizedDateFormatFromTemplate(_ dateFormatTemplate: String) {
        NSUnimplemented()
    }

    private func _reset() {
        __cfObject = nil
    }

    internal func _setFormatterAttributes(_ formatter: CFDateFormatter) {
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterIsLenient, value: lenient._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterTimeZone, value: timeZone?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterCalendarName, value: _calendar?.calendarIdentifier._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterTwoDigitStartDate, value: _twoDigitStartDate?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterDefaultDate, value: defaultDate?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterCalendar, value: _calendar?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterEraSymbols, value: _eraSymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterMonthSymbols, value: _monthSymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterShortMonthSymbols, value: _shortMonthSymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterWeekdaySymbols, value: _weekdaySymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterShortWeekdaySymbols, value: _shortWeekdaySymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterAMSymbol, value: _AMSymbol?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterPMSymbol, value: _PMSymbol?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterLongEraSymbols, value: _longEraSymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterVeryShortMonthSymbols, value: _veryShortMonthSymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterStandaloneMonthSymbols, value: _standaloneMonthSymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterShortStandaloneMonthSymbols, value: _shortStandaloneMonthSymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterVeryShortStandaloneMonthSymbols, value: _veryShortStandaloneMonthSymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterVeryShortWeekdaySymbols, value: _veryShortWeekdaySymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterStandaloneWeekdaySymbols, value: _standaloneWeekdaySymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterShortStandaloneWeekdaySymbols, value: _shortStandaloneWeekdaySymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterVeryShortStandaloneWeekdaySymbols, value: _veryShortStandaloneWeekdaySymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterQuarterSymbols, value: _quarterSymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterShortQuarterSymbols, value: _shortQuarterSymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterStandaloneQuarterSymbols, value: _standaloneQuarterSymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterShortStandaloneQuarterSymbols, value: _shortStandaloneQuarterSymbols?._cfObject)
        _setFormatterAttribute(formatter, attributeName: kCFDateFormatterGregorianStartDate, value: _gregorianStartDate?._cfObject)
    }

    internal func _setFormatterAttribute(_ formatter: CFDateFormatter, attributeName: CFString, value: AnyObject?) {
        if let value = value {
            CFDateFormatterSetProperty(formatter, attributeName, value)
        }
    }

    private var _dateFormat: String? { willSet { _reset() } }
    public var dateFormat: String! {
        get {
            guard let format = _dateFormat else {
                return __cfObject.map { CFDateFormatterGetFormat($0)._swiftObject } ?? ""
            }
            return format
        }
        set {
            _dateFormat = newValue
        }
    }

    public var dateStyle: NSDateFormatterStyle = .NoStyle { willSet { _dateFormat = nil; _reset() } }

    public var timeStyle: NSDateFormatterStyle = .NoStyle { willSet { _dateFormat = nil; _reset() } }

    /*@NSCopying*/ public var locale: NSLocale! = .currentLocale() { willSet { _reset() } }

    public var generatesCalendarDates = false { willSet { _reset() } }

    /*@NSCopying*/ public var timeZone: NSTimeZone! = .systemTimeZone() { willSet { _reset() } }

    /*@NSCopying*/ internal var _calendar: NSCalendar! { willSet { _reset() } }
    public var calendar: NSCalendar! {
        get {
            guard let calendar = _calendar else {
                return CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterCalendar) as! NSCalendar
            }
            return calendar
        }
        set {
            _calendar = newValue
        }
    }

    public var lenient = false { willSet { _reset() } }

    /*@NSCopying*/ internal var _twoDigitStartDate: NSDate? { willSet { _reset() } }
    public var twoDigitStartDate: NSDate? {
        get {
            guard let startDate = _twoDigitStartDate else {
                return CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterTwoDigitStartDate) as? NSDate
            }
            return startDate
        }
        set {
            _twoDigitStartDate = newValue
        }
    }

    /*@NSCopying*/ public var defaultDate: NSDate? { willSet { _reset() } }
    
    internal var _eraSymbols: [String]! { willSet { _reset() } }
    public var eraSymbols: [String]! {
        get {
            guard let symbols = _eraSymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterEraSymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _eraSymbols = newValue
        }
    }
    
    internal var _monthSymbols: [String]! { willSet { _reset() } }
    public var monthSymbols: [String]! {
        get {
            guard let symbols = _monthSymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterMonthSymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _monthSymbols = newValue
        }
    }

    internal var _shortMonthSymbols: [String]! { willSet { _reset() } }
    public var shortMonthSymbols: [String]! {
        get {
            guard let symbols = _shortMonthSymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterShortMonthSymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _shortMonthSymbols = newValue
        }
    }
    

    internal var _weekdaySymbols: [String]! { willSet { _reset() } }
    public var weekdaySymbols: [String]! {
        get {
            guard let symbols = _weekdaySymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterWeekdaySymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _weekdaySymbols = newValue
        }
    }

    internal var _shortWeekdaySymbols: [String]! { willSet { _reset() } }
    public var shortWeekdaySymbols: [String]! {
        get {
            guard let symbols = _shortWeekdaySymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterShortWeekdaySymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _shortWeekdaySymbols = newValue
        }
    }

    internal var _AMSymbol: String! { willSet { _reset() } }
    public var AMSymbol: String! {
        get {
            guard let symbol = _AMSymbol else {
                return (CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterAMSymbol) as! NSString)._swiftObject
            }
            return symbol
        }
        set {
            _AMSymbol = newValue
        }
    }

    internal var _PMSymbol: String! { willSet { _reset() } }
    public var PMSymbol: String! {
        get {
            guard let symbol = _PMSymbol else {
                return (CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterPMSymbol) as! NSString)._swiftObject
            }
            return symbol
        }
        set {
            _PMSymbol = newValue
        }
    }

    internal var _longEraSymbols: [String]! { willSet { _reset() } }
    public var longEraSymbols: [String]! {
        get {
            guard let symbols = _longEraSymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterLongEraSymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _longEraSymbols = newValue
        }
    }

    internal var _veryShortMonthSymbols: [String]! { willSet { _reset() } }
    public var veryShortMonthSymbols: [String]! {
        get {
            guard let symbols = _veryShortMonthSymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterVeryShortMonthSymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _veryShortMonthSymbols = newValue
        }
    }

    internal var _standaloneMonthSymbols: [String]! { willSet { _reset() } }
    public var standaloneMonthSymbols: [String]! {
        get {
            guard let symbols = _standaloneMonthSymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterStandaloneMonthSymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _standaloneMonthSymbols = newValue
        }
    }

    internal var _shortStandaloneMonthSymbols: [String]! { willSet { _reset() } }
    public var shortStandaloneMonthSymbols: [String]! {
        get {
            guard let symbols = _shortStandaloneMonthSymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterShortStandaloneMonthSymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _shortStandaloneMonthSymbols = newValue
        }
    }

    internal var _veryShortStandaloneMonthSymbols: [String]! { willSet { _reset() } }
    public var veryShortStandaloneMonthSymbols: [String]! {
        get {
            guard let symbols = _veryShortStandaloneMonthSymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterVeryShortStandaloneMonthSymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _veryShortStandaloneMonthSymbols = newValue
        }
    }

    internal var _veryShortWeekdaySymbols: [String]! { willSet { _reset() } }
    public var veryShortWeekdaySymbols: [String]! {
        get {
            guard let symbols = _veryShortWeekdaySymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterVeryShortWeekdaySymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _veryShortWeekdaySymbols = newValue
        }
    }

    internal var _standaloneWeekdaySymbols: [String]! { willSet { _reset() } }
    public var standaloneWeekdaySymbols: [String]! {
        get {
            guard let symbols = _standaloneWeekdaySymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterStandaloneWeekdaySymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _standaloneWeekdaySymbols = newValue
        }
    }

    internal var _shortStandaloneWeekdaySymbols: [String]! { willSet { _reset() } }
    public var shortStandaloneWeekdaySymbols: [String]! {
        get {
            guard let symbols = _shortStandaloneWeekdaySymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterShortStandaloneWeekdaySymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _shortStandaloneWeekdaySymbols = newValue
        }
    }
    
    internal var _veryShortStandaloneWeekdaySymbols: [String]! { willSet { _reset() } }
    public var veryShortStandaloneWeekdaySymbols: [String]! {
        get {
            guard let symbols = _veryShortStandaloneWeekdaySymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterVeryShortStandaloneWeekdaySymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _veryShortStandaloneWeekdaySymbols = newValue
        }
    }

    internal var _quarterSymbols: [String]! { willSet { _reset() } }
    public var quarterSymbols: [String]! {
        get {
            guard let symbols = _quarterSymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterQuarterSymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _quarterSymbols = newValue
        }
    }
    
    internal var _shortQuarterSymbols: [String]! { willSet { _reset() } }
    public var shortQuarterSymbols: [String]! {
        get {
            guard let symbols = _shortQuarterSymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterShortQuarterSymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _shortQuarterSymbols = newValue
        }
    }

    internal var _standaloneQuarterSymbols: [String]! { willSet { _reset() } }
    public var standaloneQuarterSymbols: [String]! {
        get {
            guard let symbols = _standaloneQuarterSymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterStandaloneQuarterSymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _standaloneQuarterSymbols = newValue
        }
    }

    internal var _shortStandaloneQuarterSymbols: [String]! { willSet { _reset() } }
    public var shortStandaloneQuarterSymbols: [String]! {
        get {
            guard let symbols = _shortStandaloneQuarterSymbols else {
                let cfSymbols = CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterShortStandaloneQuarterSymbols) as! NSArray
                return cfSymbols.bridge().map { ($0 as! NSString).bridge() }
            }
            return symbols
        }
        set {
            _shortStandaloneQuarterSymbols = newValue
        }
    }

    internal var _gregorianStartDate: NSDate? { willSet { _reset() } }
    public var gregorianStartDate: NSDate? {
        get {
            guard let startDate = _gregorianStartDate else {
                return CFDateFormatterCopyProperty(_cfObject, kCFDateFormatterGregorianStartDate) as? NSDate
            }
            return startDate
        }
        set {
            _gregorianStartDate = newValue
        }
    }

    public var doesRelativeDateFormatting = false { willSet { _reset() } }
}

public enum NSDateFormatterStyle : UInt {
    case NoStyle
    case ShortStyle
    case MediumStyle
    case LongStyle
    case FullStyle
}
