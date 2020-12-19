//
//  OrderListViewController.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/18.
//

import UIKit

class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var targetList: [[String: String]] = []
    var currentCellEditCode: String?
    var currentCellOrderer: String?
    
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
        
        // Notification Center
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAction), name: NSNotification.Name("deleteAction"), object: nil)
        NotificationCenter.default.addObserver(forName: NSNotification.Name("deleteAction"), object: nil, queue: nil, using: catchNotiInfo)
        
    }
    
    func catchNotiInfo(notification: Notification) {
        guard let editCode = notification.userInfo!["editCode"],
              let orderer = notification.userInfo!["orderer"] else {
            return
        }
        currentCellEditCode = (editCode as! String)
        currentCellOrderer = (orderer as! String)
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
        // 設定文字
        cell.nameLabel.text = drinkInfo["drinkName"]!
        cell.briefLabel.text = "\(drinkInfo["drinkSize"]!)、\(drinkInfo["drinkTemp"]!)、\(drinkInfo["drinkSugar"]!) \(drinkInfo["addOn"]!)"
        cell.priceLabel.text = "$\(drinkInfo["totalPrice"]!)"
        cell.ordererLabel.text = drinkInfo["orderer"]
        // 帶入資料
        cell.editCode = drinkInfo["editCode"]!
        cell.orderer = drinkInfo["orderer"]!
        return cell
    }

    // get google sheet 資料
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
    
    // 計算總共多少
    func computeTotal() -> Int {
        var result: Int = 0
        targetList.forEach({
            result += Int($0["totalPrice"]!) ?? 0
        })
        return result
    }

    @objc func deleteAction() {
        let controller = UIAlertController(title: "請輸入驗證碼", message: "輸入設定的驗證碼以刪除訂購資料", preferredStyle: .alert)
        controller.addTextField { (textField) in
            textField.placeholder = "請輸入驗證碼"
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "確認", style: .default) { (_) in
            let editCode = controller.textFields?[0].text
            // 檢查與當前 cell 編輯碼是否相同
            guard editCode == self.currentCellEditCode else {
                self.showFailAlert()
                return
            }
            print("驗證成功")
            self.deleteOrder()
        }
        controller.addAction(confirmAction)
        present(controller, animated: true, completion: nil)
    }
    
    // 驗證碼錯誤跳出視窗
    func showFailAlert() {
        let failController = UIAlertController(title: "驗證碼錯誤", message: "請再試一次", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        failController.addAction(okAction)
        present(failController, animated: true, completion: nil)
    }
    
    func deleteOrder() {
        let url = URL(string: "https://sheetdb.io/api/v1/wbsoh89yl2tip/orderer/\(currentCellOrderer!)?limit=1".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data,
               let status = try? JSONDecoder().decode([String:Int].self, from: data), status["deleted"] != nil {
                print("ok")
                DispatchQueue.main.async {
                    self.cancelShowDeleteBtns()
                    self.fetchOrderItems()
                }
            } else {
                print("error")
            }
        }.resume()
    }
    
    func cancelShowDeleteBtns() {
        orderListTableView.visibleCells.forEach({
            ($0 as! OrderItemCell).hideDeleteBtn()
        })
    }
}
