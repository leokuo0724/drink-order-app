//
//  OrderListViewController.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/18.
//

import UIKit

class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var targetList: [[String: String]] = []
    
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var orderListTableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupLabel.text = userInfo.userGroup
        orderListTableView.backgroundColor = .clear
        orderListTableView.separatorColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)
        orderListTableView.separatorInset = UIEdgeInsets(top: 0, left: 92, bottom: 0, right: 0)
        fetchOrderItems()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as! OrderItemCell
        // 設定畫面
        let drinkInfo = targetList[indexPath.row]
        // 若無該飲料圖片，給預設圖片
        if let image = allDrinkImages[drinkInfo["drinkName"]!] {
            cell.drinkImageView.image = image
        } else {
            cell.drinkImageView.image = UIImage(named: "熟成紅茶")
        }
        cell.nameLabel.text = drinkInfo["drinkName"]!
        cell.briefLabel.text = "\(drinkInfo["drinkSize"]!)、\(drinkInfo["drinkTemp"]!)、\(drinkInfo["drinkSugar"]!) \(drinkInfo["addOn"]!)"
        cell.priceLabel.text = "$\(drinkInfo["totalPrice"]!)"
        return cell
    }

    func fetchOrderItems() {
        let url = URL(string: "https://sheetdb.io/api/v1/wbsoh89yl2tip")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data {
                do {
                    let result = try decoder.decode([[String: String]].self, from: data)
                    self.targetList = result.filter({
                        $0["group"] == userInfo.userGroup
                    })
                    // 更新畫面
                    DispatchQueue.main.async {
                        self.orderListTableView.reloadData()
                        self.totalAmountLabel.text = "共計 \(self.targetList.count)杯"
                        self.priceLabel.text = "$\(self.computeTotal())"
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func computeTotal() -> Int {
        var result: Int = 0
        targetList.forEach({
            result += Int($0["totalPrice"]!) ?? 0
        })
        return result
    }

}
