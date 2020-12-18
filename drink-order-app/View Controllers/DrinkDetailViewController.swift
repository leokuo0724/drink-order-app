//
//  DrinkDetailViewController.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/15.
//

import UIKit

class DrinkDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameZHLabel: UILabel!
    @IBOutlet weak var nameENLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!
    
    @IBOutlet weak var calorieMLabel: UILabel!
    @IBOutlet weak var calorieLLabel: UILabel!
    
    @IBOutlet weak var temperatureView: UIView!
    @IBOutlet weak var temperatureTableView: UITableView!
    @IBOutlet weak var sugarView: UIView!
    @IBOutlet weak var sugarTableView: UITableView!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var sizeTableView: UITableView!
    @IBOutlet weak var addOnView: UIView!
    @IBOutlet weak var addOnTableView: UITableView!
    @IBOutlet weak var saySomethingView: UIView!
    @IBOutlet weak var saySomethingTextView: UITextView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var briefLabel: UILabel!
    @IBOutlet weak var orderBtn: UIButton!
    
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
        
        // 設定 table view 大小
        temperatureTableView.frame.size.height = CGFloat(48*Temp.allCases.count)
        sugarTableView.frame.size.height = CGFloat(48*Sugar.allCases.count)
        sizeTableView.frame.size.height = CGFloat(48*Size.allCases.count)
        // 設定 btn style and disabled
        orderBtn.layer.cornerRadius = 6
        orderBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        setOrderBtnEnabled(false)
        
        // 設定選項縮小
        optionExpand()
        // 設定初始資訊
        setBasicInfo()
        
        // 設定 NotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(clearTempCellStyle), name: NSNotification.Name("clearTempCellStyle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearSugarCellStyle), name: NSNotification.Name("clearSugarCellStyle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearSizeCellStyle), name: NSNotification.Name("clearSizeCellStyle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBrief), name: NSNotification.Name("updateBrief"), object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        order.reset()
    }
    
    func setBasicInfo() {
        nameZHLabel.text = selectedDrink?.name_zh.value
        nameENLabel.text = selectedDrink?.name_en.value
        descriptionLabel.text = selectedDrink?.description.value
        calorieMLabel.text = selectedDrink?.maxCalorieM.value
        calorieLLabel.text = selectedDrink?.maxCalorieL.value
        // 圖片
        drinkImageView.image = allDrinkImages[(selectedDrink?.name_zh.value)!]
        // 價錢
        priceLabel.text = "$\((selectedDrink?.priceM.value)!).00"
        // brief
        briefLabel.text = "請選擇飲品溫度、甜度、份量"
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
        
        // 取消文字編輯
        saySomethingTextView.endEditing(true)
    }
    
    // 生成 table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var counts: Int?
        switch tableView {
        case self.temperatureTableView:
            counts = Temp.allCases.count
        case self.sugarTableView:
            counts = Sugar.allCases.count
        case self.sizeTableView:
            counts = Size.allCases.count
        case self.addOnTableView:
            counts = AddOn.allCases.count
        default:
            counts = 0
        }
        return counts!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch tableView {
        case self.temperatureTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "OptionSelectCell", for: indexPath) as! OptionSelectCell
            (cell as! OptionSelectCell).optionType = .temp
            (cell as! OptionSelectCell).option = Temp.allCases[indexPath.row]
        case self.sugarTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "OptionSelectCell", for: indexPath) as! OptionSelectCell
            (cell as! OptionSelectCell).optionType = .sugar
            (cell as! OptionSelectCell).option = Sugar.allCases[indexPath.row]
        case self.sizeTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "OptionSelectCell", for: indexPath) as! OptionSelectCell
            (cell as! OptionSelectCell).optionType = .size
            (cell as! OptionSelectCell).option = Size.allCases[indexPath.row]
        case self.addOnTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "OptionCheckCell", for: indexPath) as! OptionCheckCell
            (cell as! OptionCheckCell).option = AddOn.allCases[indexPath.row]
        default:
            break
        }
        return cell
    }
    
    // 清除 cells 樣式
    @objc func clearTempCellStyle() {
        temperatureTableView.visibleCells.forEach({
            ($0 as? OptionSelectCell)?.setBtnStyle(isActive: false)
        })
    }
    @objc func clearSugarCellStyle() {
        sugarTableView.visibleCells.forEach({
            ($0 as? OptionSelectCell)?.setBtnStyle(isActive: false)
        })
    }
    @objc func clearSizeCellStyle() {
        sizeTableView.visibleCells.forEach({
            ($0 as? OptionSelectCell)?.setBtnStyle(isActive: false)
        })
    }
    
    // 更新 brief 與 確認是否可購買
    @objc func updateBrief() {
        var outputStr: String = ""
        var totalPrice: Int = 0
        var isCanOrder: Bool = false
        if let priceM = selectedDrink?.priceM.value {
            totalPrice = Int(priceM)!
        }
        
        if let temp = order.drinkTemp {
            let str = temp.rawValue.components(separatedBy: " ")[0]
            outputStr += "\(str)、"
        }
        if let sugar = order.drinkSugar {
            let str = sugar.rawValue.components(separatedBy: " ")[0]
            outputStr += "\(str)、"
        }
        if let size = order.drinkSize {
            let str = size.rawValue.components(separatedBy: " ")[0]
            outputStr += "\(str)"
            // 中杯、大杯價格
            if size == .medium,
               let priceM = selectedDrink?.priceM.value {
                totalPrice = Int(priceM)!
            } else if size == .large,
              let priceL = selectedDrink?.priceL.value {
                totalPrice = Int(priceL)!
            }
        }
        for ingredient in order.addOn {
            let str = ingredient.rawValue.components(separatedBy: " ")[0].prefix(2)
            outputStr += "、加\(str)"
            // 加白玉墨玉加錢
            if ingredient == .whiteBubble {
                totalPrice += 5
            } else if ingredient == .blackBubble {
                totalPrice += 10
            }
        }
        
        // 檢查是否訂購
        if let _ = order.drinkTemp, let _ = order.drinkSugar, let _ = order.drinkSize {
            isCanOrder = true
        }
        
        briefLabel.text = outputStr
        priceLabel.text = "$\(totalPrice).00"
        order.totalPrice = totalPrice
        setOrderBtnEnabled(isCanOrder)
    }
    
    func setOrderBtnEnabled(_ isEnabled: Bool) {
        if isEnabled {
            print("set enabled")
            orderBtn.isEnabled = true
            orderBtn.backgroundColor = UIColor(named: "LightYellowColor")
        } else {
            orderBtn.isEnabled = false
            orderBtn.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
        }
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
    
    @IBAction func orderAction(_ sender: Any) {
        print("check")
        let controller = UIAlertController(title: "是否加入訂購？", message: "確認後訂購資料將上傳", preferredStyle: .alert)
        
        // 取消
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        
        // 確認
        let okAction = UIAlertAction(title: "確認", style: .default) { (_) in
            // 上傳 database
            self.postOrder()
        }
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
    }
    
    func postOrder() {
        // 開始 loading anim
        
        // 設定資料格式
        let orderItem = OrderItem(group: userInfo.userGroup,
                                  orderer: userInfo.userName,
                                  drinkName: order.drinkName!,
                                  drinkSize: (order.drinkSize?.rawValue.components(separatedBy: " ")[0])!,
                                  drinkTemp: (order.drinkTemp?.rawValue.components(separatedBy: " ")[0])!,
                                  drinkSugar: (order.drinkSugar?.rawValue.components(separatedBy: " ")[0])!,
                                  addOn: formatAddOns(),
                                  saySomething: formatSaySomething(),
                                  totalPrice: String(order.totalPrice!),
                                  editCode: userInfo.editCode,
                                  lastUpdateTime: formatDate())
        let postOrder = PostOrder(data: orderItem)
        
        let url = URL(string: "https://sheetdb.io/api/v1/wbsoh89yl2tip")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("appliction/json", forHTTPHeaderField: "Content-Type")

        if let data = try? JSONEncoder().encode(postOrder) {
            // 資料裝在 httpBody 中
            urlRequest.httpBody = data
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let data = data,
                   let status = try? JSONDecoder().decode([String:Int].self, from: data),
                   status["created"] == 1 {
                    print("ok")
                    // 停止 loading anim
                } else {
                    print("error")
                }
            }.resume()
        }
    }
    func formatSaySomething() -> String {
        if order.saySomething == "想說點什麼呢..." {
            return ""
        } else {
            return order.saySomething!
        }
    }
    func formatAddOns() -> String {
        var output: String = ""
        for ingredient in order.addOn {
            let str = ingredient.rawValue.components(separatedBy: " ")[0].prefix(2)
            output += "加\(str) "
        }
        return output
    }
    func formatDate() -> String {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.string(from: Date())
    }
    
}
