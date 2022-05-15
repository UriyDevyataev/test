//
//  CustomPopUpView.swift
//  TestDataPicker
//
//  Created by Юрий Девятаев on 15.05.2022.
//

import UIKit

class CustomPopUpView: UIView {
    
    public var selectedIndex: Int = 0
    
    private var views = [UIView]()
    private var icons = [UIImageView]()
    private var buttonTittles = [String]()
    
    var taped: ((Int) -> ())?
    var isShow = false
    
    convenience init(frame: CGRect, butTittles: [String], selectedIndex: Int) {
        self.init(frame: frame)
        self.buttonTittles = butTittles
        self.selectedIndex = selectedIndex
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configView()
        updateView()
        show()
    }
    
    func configView() {
        layer.shadowRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.2
    }
    
    private func updateView() {
        createViews()
        createStack()
    }
    
    private func createViews() {
        buttonTittles.forEach { tittle in
            let customView = UIView()
            customView.backgroundColor = .white
            views.append(customView)
        }
        createCheckImage()
        createLabels()
        createButtons()
    }
    
    private func createCheckImage() {
        for (index, _) in buttonTittles.enumerated() {
            let icon = UIImageView()
            icon.backgroundColor = .clear
            icon.image = UIImage(named: "check")
            icon.alpha = 0
            icons.append(icon)
            let customView = views[index]
            
            customView.addSubview(icon)
            
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.heightAnchor.constraint(equalTo: customView.heightAnchor,
                                         multiplier: 1.0/3.0).isActive = true
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor,
                                        multiplier: 1.0/1.0).isActive = true
            icon.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
            icon.leftAnchor.constraint(equalTo: customView.leftAnchor, constant: 10).isActive = true
            
            if index == selectedIndex {
                icon.alpha = 1
            }
        }
    }
    
    private func createLabels() {
        for (index, value) in buttonTittles.enumerated() {
            let label = UILabel()
            label.backgroundColor = .clear
            label.text = value
            let customView = views[index]
            
            customView.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.topAnchor.constraint(equalTo: customView.topAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: customView.bottomAnchor).isActive = true
            label.leftAnchor.constraint(equalTo: icons[index].rightAnchor,
                                        constant: 10).isActive = true
            label.rightAnchor.constraint(equalTo: customView.rightAnchor).isActive = true
        }
    }
    
    private func createButtons() {
        for (index, _) in buttonTittles.enumerated() {
            let but = UIButton()
            but.tag = index
            but.setTitle("", for: .normal)
            but.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
            let customView = views[index]
            
            customView.addSubview(but)
            but.translatesAutoresizingMaskIntoConstraints = false
            but.topAnchor.constraint(equalTo: customView.topAnchor).isActive = true
            but.bottomAnchor.constraint(equalTo: customView.bottomAnchor).isActive = true
            but.leftAnchor.constraint(equalTo: customView.leftAnchor).isActive = true
            but.rightAnchor.constraint(equalTo: customView.rightAnchor).isActive = true
        }
    }
    
    private func createStack() {
        let stView = UIStackView(arrangedSubviews: views)
        stView.axis = .vertical
        stView.alignment = .fill
        stView.distribution = .fillEqually
        stView.spacing = 1
        stView.backgroundColor = .lightGray
        
        stView.layer.cornerRadius = 10
        stView.layer.shadowColor = UIColor.black.cgColor
        stView.layer.shadowOffset = CGSize(width: 5, height: 5)
        stView.layer.shadowOpacity = 1
        stView.clipsToBounds = true
        
        addSubview(stView)
        stView.translatesAutoresizingMaskIntoConstraints = false
        stView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    @objc
    private func buttonClicked(sender: UIButton) {
        selectedIndex = sender.tag
        hide()
    }
    
    func show() {
        let newHalfWidth = self.frame.width * 0.2 / 2
        let b = self.frame.width / 2 - newHalfWidth
        
        let newHalfHeigh = self.frame.height * 0.2 / 2
        let c = self.frame.height / 2 - newHalfHeigh
        
        let scaleTr = CGAffineTransform(scaleX: 0.2, y: 0.2)
        let moveTr = CGAffineTransform(translationX: -b, y: -c)
        
        self.transform = scaleTr.concatenating(moveTr)
       
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
            self.alpha = 1
        }
        
        isShow = true
        
    }
    
    func hide() {
        
        views[selectedIndex].backgroundColor = .lightGray
        taped?(selectedIndex)
        
        let newHalfWidth = self.frame.width * 0.2 / 2
        let b = self.frame.width / 2 - newHalfWidth
        
        let newHalfHeigh = self.frame.height * 0.2 / 2
        let c = self.frame.height / 2 - newHalfHeigh
        
        let scaleTr = CGAffineTransform(scaleX: 0.2, y: 0.2)
        let moveTr = CGAffineTransform(translationX: -b, y: -c)
       
        UIView.animate(withDuration: 0.3) {
            self.transform = scaleTr.concatenating(moveTr)
            self.alpha = 0
        } completion: { res in
            self.removeFromSuperview()
        }
        
        isShow = false
    }
}


//import UIKit
//
//class ViewController: UIViewController {
//
//    @IBOutlet weak var stButton: UIButton!
//    @IBOutlet weak var textView: UITextField!
//    @IBOutlet weak var datePicker: UIDatePicker!
//    @IBOutlet weak var popButton: UIButton!
//
//    var selectedIndex = 0
//
//    var popUp: CustomPopUpView = CustomPopUpView()
//    var myDate = Date()
//
//    @IBAction func actionSt(_ sender: UIButton) {
//
//
//        if popUp.isShow {
//            popUp.hide()
//        } else {
//            createPopUp(sender: sender)
//            view.addSubview(popUp)
//        }
//    }
//
//    func createPopUp(sender: UIView) {
//
//        let content = ["1", "2", "3"]
//        let heigh = content.count * 44
//        let width = 230
//        let rect = CGRect(x: Int(sender.frame.minX),
//                          y: Int(sender.frame.maxY) + 5,
//                          width: width,
//                          height: heigh)
//        popUp = CustomPopUpView(frame: rect, butTittles: ["1", "2", "3"], selectedIndex: selectedIndex)
//        popUp.taped = { index in
//            self.selectedIndex = index
//            UIView.animate(withDuration: 0.3) {
//                self.stButton.alpha = 0
//            } completion: { res in
//                self.stButton.setTitle(String(self.selectedIndex), for: .normal)
//                self.stButton.alpha = 1
//            }
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        stButton.backgroundColor = .red
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
//        if #available(iOS 14.0, *) {
//            setPopUpButton()
//        }
//        datePicker.calendar.locale = .autoupdatingCurrent
//
////        let datePic = UIDatePicker(frame: CGRect(x: 20, y: 100, width: 200, height: 200))
////        let datePic = UIDatePicker()
////        datePic.backgroundColor = .darkGray
////        datePic.datePickerMode = .time
////
////        if #available(iOS 13.4, *) {
////            datePic.preferredDatePickerStyle = .compact
////        } else {
////            datePic.frame = CGRect(x: 20, y: 100, width: 200, height: 200)
////            view.addSubview(datePic)
////        }
//
//    }
//
//    @objc
//    func dismissKeyboard() {
//        popUp.hide()
//    }
//
//    @available(iOS 14.0, *)
//    func setPopUpButton(){
//
//        // Here are my Array with countries name. It's works fine.
////        let statesOf = ArrayWithCountries()
//
//        let optionClosure = {(action: UIAction) in
//            print(action.title)
//        }
//
//        // In this part I want to fetch the countries array. Now it's a static menu!
//        popButton.menu = UIMenu(children: [
//            UIAction(title: "Country 1", state: .off, handler: optionClosure),
//            UIAction(title: "Country 2", state: .on, handler: optionClosure),
//            UIAction(title: "Country 3", state: .off, handler: optionClosure),
//            UIAction(title: "Country 4", state: .off , handler: optionClosure)
//        ])
//
////        popButton.showsMenuAsPrimaryAction = true
////        popButton.changesSelectionAsPrimaryAction = true
//
//
//
//    }
//
//
//    @IBAction func actionGet(_ sender: UIButton) {
////        show(sender: sender)
//        setNot()
////        getComponent()
//    }
//
//    func setNot () {
//        let oldDate = datePicker.date
//
//        let components = datePicker.calendar.dateComponents(
//            [ .day,
//              .hour,
//              .minute],
//            from: oldDate)
//
//        let day = components.day
//        let hour = components.hour
//        let minute = components.minute
//
//        print("day = \(day), hour = \(hour), min = \(minute)")
//
//
//        var ti = oldDate.timeIntervalSince1970
//        ti = ti - 5 * 60
//
//        let newDate = Date(timeIntervalSince1970: ti)
//
//        let newComponents = datePicker.calendar.dateComponents(
//            [ .day,
//              .hour,
//              .minute],
//            from: newDate)
//
//        let newDay = newComponents.day
//        let newHour = newComponents.hour
//        let newMinute = newComponents.minute
//
//        print("newDay = \(newDay), newHour = \(newHour), newMinute = \(newMinute)")
//
//    }
//    func getComponent() {
//
//        let components = datePicker.calendar.dateComponents(
//            [ .year,
//              .month,
//              .day,
//              .hour,
//              .minute,
//              .timeZone,
//              .weekday,
//              .day,
//              .calendar],
//            from: datePicker.date)
//
//        let year = components.year
//        let month = components.month
//        let day = components.day
//        let hour = components.hour
//        let minute = components.minute
////        let timeZone = components.timeZone
////        let weekday = components.weekday
////        let cal = components.calendar?.locale
////
////        print(hour)
////        print(minute)
////        print(timeZone)
////        print(weekday)
////        print(day)
////        print(cal)
//
////        myDate = makeDate(year: year, month: month, day: <#T##Int#>, hr: <#T##Int#>, min: <#T##Int#>, sec: <#T##Int#>)
//
//
//
//        let sa = datePicker.date.timeIntervalSince1970
//        print(sa)
//
//        let newDate = Date(timeIntervalSince1970: sa)
//        print(newDate)
//
//
//    }
//
//    func makeDate(year: Int, month: Int, day: Int, hr: Int, min: Int, sec: Int) -> Date {
//        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
//        let components = NSDateComponents()
//        components.year = year
//        components.month = month
//        components.day = day
//        components.hour = hr
//        components.minute = min
//        components.second = sec
//        let date = calendar.date(from: components as DateComponents)
//        return date! as Date
//    }
//
//    @IBAction func actionSet(_ sender: Any) {
//
//    }
//
//    func convertToUTC(dateToConvert:String) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
//        let convertedDate = formatter.date(from: dateToConvert)
//        formatter.timeZone = TimeZone(identifier: "UTC")
//        return formatter.string(from: convertedDate!)
//
//
//    }
//
//    func show(sender: UIView ) {
//        let height: CGFloat = 250
//        let butView = UIView(frame:
//                            CGRect(x: sender.frame.maxX - height,
//                                   y: sender.frame.minY - height - 5,
//                                   width: height,
//                                   height: height))
//        butView.backgroundColor = .darkGray
//        let dataPick = UIDatePicker(frame: butView.bounds)
//        dataPick.datePickerMode = .time
//        butView.addSubview(dataPick)
//        self.view.addSubview(butView)
//    }
//}

