//
//  CalendarViewController.swift
//  
//
//  Created by Xavier Paez on 2/18/17.
//
//

import UIKit
import JTAppleCalendar
import CoreData
import FirebaseInstanceID
import FirebaseMessaging

class CalendarViewController: UIViewController, UICollectionViewDataSource {
  
  
    @IBOutlet weak var swallowsSummaryCollectionView: UICollectionView!
    @IBOutlet weak var popUpView: UIView!

    @IBOutlet weak var popUpContraint: NSLayoutConstraint!
    @IBOutlet weak var calendarView : JTAppleCalendarView!
    let currentDate = Date()
    let formatter = DateFormatter()
    let calendar  = Calendar.current
    let veryLightGray = UIColor(colorWithHexValue: 0xECEAED)

    let darkBlue = UIColor(colorWithHexValue: 0x1F7ABE)
    let dimBlue = UIColor(colorWithHexValue: 0x2BA4FF)
    let gray = UIColor.gray
    let lightGray = UIColor(red:0.81, green:0.81, blue:0.81, alpha:1.0)
    
    @IBOutlet weak var missedPills: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "blupil")
        let imageView = NavigationImageView(image: logo)
        
        self.navigationItem.titleView = imageView
        imageView.contentMode = .scaleAspectFit  // s
        imageView.sizeToFit()
        setUpCalendar()
        highlightTakenDates()
        Messaging.messaging().subscribe(toTopic: "/topic/news")
        updateStats()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.reloadData()
    }
    
    private func setUpCalendar(){
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = calendar.timeZone
        formatter.locale = calendar.locale
        
        calendarView.allowsMultipleSelection  = true
        calendarView.isRangeSelectionUsed = true
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.register(UINib(nibName: "CalendarCellView", bundle: nil), forCellWithReuseIdentifier: "CalendarCellView")
        let currentDate = Date()
        calendarView.scrollToDate(currentDate) {
                self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
                    self.setupViewsOfCalendar(from: visibleDates)
                })
        }
        
    }
    
    func presentPopUp(){
        popUpContraint.constant = 0
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CalendarCellView  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = UIColor.white
        } else {
            let date = Date()
            let currentMonth = calendar.component(.month, from: date)
            let cellDay = calendar.component(.day, from: cellState.date)
            let cellMonth = calendar.component(.month, from: cellState.date)
            let currentDay = calendar.component(.day, from: date)
            if cellState.dateBelongsTo == .thisMonth && cellDay < currentDay{
                myCustomCell.dayLabel.textColor = lightGray
            } else if cellMonth != currentMonth {
                myCustomCell.dayLabel.textColor =  lightGray
            }
            else {
                myCustomCell.dayLabel.textColor = gray
            }
        }
    }
    
    func handleCellSelection(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CalendarCellView  else {
            return
        }
        if cellState.isSelected {
            myCustomCell.selectedView.layer.cornerRadius =  20
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }
    
    @IBAction func next(_ sender: UIButton) {
        self.calendarView.scrollToSegment(.next) {
            self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            })
        }
    }
    
    @IBAction func previous(_ sender: UIButton) {
        self.calendarView.scrollToSegment(.previous) {
            self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            })
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        
        let month = calendar.component(.month, from: startDate)
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = Calendar.current.component(.year, from: startDate)
        monthLabel.text = monthName + " " + String(year)
        self.swallowsSummaryCollectionView.reloadData()
    }

    
    func saveSelectedDate(cellState: CellState){
        let repository = RecordRepository(context: context)
        var date = cellState.date
        _ = repository.upsert(date: cellState.date, isTaken: cellState.isSelected)
        repository.saveChanges()
    }

    private func highlightTakenDates() {
        let repository = RecordRepository(context: context)
        let records = repository.findTakenRecords()
        let dates = records.compactMap { $0.date as Date? }
        self.calendarView.selectDates(dates)
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func updateStats(){
        let pillsTaken = getSelectedDateRecord()
        missedPills.text = String(30-pillsTaken);
    }
    
    func getSelectedDateRecord() -> Int{
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        fetchRequest.predicate = makeDayPredicate()
        do {
            return try context.count(for: fetchRequest)
        }
        catch {  }
        return 0
    }
    
    func makeDayPredicate() -> NSPredicate {
        let refillDate : Date
        if let date = calendar.date(byAdding: .day, value: -30, to: Date()){
            refillDate = date
        } else {
            refillDate = Date()
        }
        let endDate = Date()
        return NSPredicate(format: "date >= %@ AND date =< %@ AND taken == YES" , argumentArray: [refillDate, endDate])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("DATE")
        print (calendarView.visibleDates().monthDates.first?.date)
        if let firstDayOfMonth = calendarView.visibleDates().monthDates.first?.date {
            let repository = RecordRepository(context: context)
            let records = repository.dateToCurrentDayRecords(date: firstDayOfMonth, isTaken: true)
            return records.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = swallowsSummaryCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! SwallowsSummaryCollectionViewCell
        print("Index Path")
        print(indexPath.row)
        let repository = RecordRepository(context: context)
        if let firstDayOfMonth = calendarView.visibleDates().monthDates.first?.date {
            var records = repository.dateToCurrentDayRecords(date: firstDayOfMonth, isTaken: true)
            records = records.sorted(by: {
                $0.date?.compare($1.date!) == .orderedAscending
            })
            let record = records[indexPath.row]
            cell.date.text = record.date?.string(format: "MMM d")
            cell.time.text = record.date?.string(format: "h:mm a")
        }

        return cell
    }

}

