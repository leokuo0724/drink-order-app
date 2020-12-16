//
//  DrinkDetailViewController.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/15.
//

import UIKit

enum OptionType {
    case temp, sugar, size, addOn, saySomething
}
enum Temp: String, CaseIterable {
    case regularIce = "正常冰 Regular Ice"
    case lessIce = "少冰 Less Ice"
    case halfIce = "微冰 Half Ice"
    case noIce = "去冰 Ice-Free"
    case roomTemp = "常溫 Room Temperature"
    case warmTemp = "溫 Warm"
    case hot = "熱 Hot"
}
enum Sugar: String, CaseIterable {
    case regularSugar = "全糖 100% Sugar"
    case lessSugar = "少糖 70% Sugar"
    case halfSugar = "半糖 50% Sugar"
    case lightSugar = "微糖 30% Sugar"
    case noSugar = "無糖 Sugar-Free"
}
enum Size: String, CaseIterable {
    case Medium = "中杯 Medium"
    case Large = "大杯 Large"
}

class DrinkDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameZHLabel: UILabel!
    @IBOutlet weak var nameENLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!
    
    @IBOutlet weak var calorieMLabel: UILabel!
    @IBOutlet weak var calorieLlabel: UILabel!
    
    @IBOutlet weak var temperatureView: UIView!
    @IBOutlet weak var temperatureTableView: UITableView!
    @IBOutlet weak var sugarView: UIView!
    @IBOutlet weak var sugarTableView: UITableView!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var sizeTableView: UITableView!
    @IBOutlet weak var addOnView: UIView!
    @IBOutlet weak var saySomethingView: UIView!
    
    var currentOption: OptionType? = nil
//    private let bottomY: CGFloat = 740
    let sectionPosition: [OptionType : [String : CGFloat]] = [
        .temp: [
            "up": 152,
            "down": 740-51*5
        ],
        .sugar: [
            "up": 152+51,
            "down": 740-51*4
        ],
        .size: [
            "up": 152+51*2,
            "down": 740-51*3
        ],
        .addOn: [
            "up": 152+51*3,
            "down": 740-51*2
        ],
        .saySomething: [
            "up": 152+51*4,
            "down": 740-51
        ],
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set table view height
        temperatureTableView.frame.size.height = CGFloat(48*Temp.allCases.count)
        sugarTableView.frame.size.height = CGFloat(48*Sugar.allCases.count)
        sizeTableView.frame.size.height = CGFloat(48*Size.allCases.count)
        
        // set optionExpand
        optionExpand()
    }
    
    func optionExpand() {
        
        var tempPosY: CGFloat?, sugarPosY: CGFloat?, sizePosY: CGFloat?, addOnPosY: CGFloat?, saySomePosY: CGFloat?
        
        switch currentOption {
        case .temp:
            tempPosY = sectionPosition[.temp]!["up"]
            sugarPosY = sectionPosition[.sugar]!["down"]
            sizePosY = sectionPosition[.size]!["down"]
            addOnPosY = sectionPosition[.addOn]!["down"]
            saySomePosY = sectionPosition[.saySomething]!["down"]
        case .sugar:
            tempPosY = sectionPosition[.temp]!["up"]
            sugarPosY = sectionPosition[.sugar]!["up"]
            sizePosY = sectionPosition[.size]!["down"]
            addOnPosY = sectionPosition[.addOn]!["down"]
            saySomePosY = sectionPosition[.saySomething]!["down"]
        case .size:
            tempPosY = sectionPosition[.temp]!["up"]
            sugarPosY = sectionPosition[.sugar]!["up"]
            sizePosY = sectionPosition[.size]!["up"]
            addOnPosY = sectionPosition[.addOn]!["down"]
            saySomePosY = sectionPosition[.saySomething]!["down"]
        case .addOn:
            tempPosY = sectionPosition[.temp]!["up"]
            sugarPosY = sectionPosition[.sugar]!["up"]
            sizePosY = sectionPosition[.size]!["up"]
            addOnPosY = sectionPosition[.addOn]!["up"]
            saySomePosY = sectionPosition[.saySomething]!["down"]
        case .saySomething:
            tempPosY = sectionPosition[.temp]!["up"]
            sugarPosY = sectionPosition[.sugar]!["up"]
            sizePosY = sectionPosition[.size]!["up"]
            addOnPosY = sectionPosition[.addOn]!["up"]
            saySomePosY = sectionPosition[.saySomething]!["up"]
        default:
            tempPosY = sectionPosition[.temp]!["down"]
            sugarPosY = sectionPosition[.sugar]!["down"]
            sizePosY = sectionPosition[.size]!["down"]
            addOnPosY = sectionPosition[.addOn]!["down"]
            saySomePosY = sectionPosition[.saySomething]!["down"]
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.temperatureView.frame.origin.y = tempPosY!
            self.sugarView.frame.origin.y = sugarPosY!
            self.sizeView.frame.origin.y = sizePosY!
            self.addOnView.frame.origin.y = addOnPosY!
            self.saySomethingView.frame.origin.y = saySomePosY!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var counts: Int?
        switch tableView {
        case self.temperatureTableView:
            counts = Temp.allCases.count
        case self.sugarTableView:
            counts = Sugar.allCases.count
        case self.sizeTableView:
            counts = Size.allCases.count
        default:
            counts = 0
        }
        return counts!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionSelectCell", for: indexPath) as! OptionSelectCell
        cell.selectionStyle = .none
        
        switch tableView {
        case self.temperatureTableView:
            cell.optionType = .temp
            cell.option = Temp.allCases[indexPath.row]
        case self.sugarTableView:
            cell.optionType = .sugar
            cell.option = Sugar.allCases[indexPath.row]
        case self.sizeTableView:
            cell.optionType = .size
            cell.option = Size.allCases[indexPath.row]
        default:
            break
        }
        return cell
    }
    
    
    // 設定當前 option view
    @IBAction func setMode(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            if currentOption == .temp {
                currentOption = nil
            } else {
                currentOption = .temp
            }
        case 1:
            if currentOption == .sugar {
                currentOption = nil
            } else {
                currentOption = .sugar
            }
        case 2:
            if currentOption == .size {
                currentOption = nil
            } else {
                currentOption = .size
            }
        case 3:
            if currentOption == .addOn {
                currentOption = nil
            } else {
                currentOption = .addOn
            }
        case 4:
            if currentOption == .saySomething {
                currentOption = nil
            } else {
                currentOption = .saySomething
            }
        default:
            break
        }
        optionExpand()
    }
    

}
