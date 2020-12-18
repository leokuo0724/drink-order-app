//
//  OrderListViewController.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/18.
//

import UIKit

class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var targetList: [[String: String]] = []
    @IBOutlet weak var orderListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchOrderItems()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as! OrderItemCell
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
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

}
