//
//  GroupViewController.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/19.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var groups: Array<String> = []
    @IBOutlet weak var groupTableView: UITableView!
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        modalTransitionStyle = .crossDissolve
//        modalPresentationStyle = .overFullScreen
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        modalTransitionStyle = .crossDissolve
//                modalPresentationStyle = .overFullScreen

        // 獲取群組資料
        fetchGroups()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        cell.textLabel?.text = groups[indexPath.row]
        return cell
    }
    
    func fetchGroups() {
        let url = URL(string: "https://sheetdb.io/api/v1/5hz2yke6qinfs")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("applicaion/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode([[String: String]].self, from: data)
                    print(result)
                    // 先清空再加入
                    self.groups = []
                    for element in result {
                        self.groups.append(element["group"]!)
                    }
                    print(self.groups)
                    // 更新畫面
                    DispatchQueue.main.async {
                        self.groupTableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

}
