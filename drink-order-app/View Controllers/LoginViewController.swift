//
//  LoginViewController.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/19.
//

import UIKit

var userInfo = UserInfo(userName: "", userGroup: "", editCode: "")

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var groups: Array<String> = []
    
    @IBOutlet weak var userNameTextField: LoginTextField!
    @IBOutlet weak var editCodeTextField: LoginTextField!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var groupTableView: UITableView!
    @IBOutlet weak var groupSelectionOverlayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGroupLabel()
        hideGroupSelection()
        
        // NotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(hideGroupSelection), name: NSNotification.Name("hideGroupSelection"), object: nil)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userNameTextField.endEditing(true)
        editCodeTextField.endEditing(true)
    }
    
    func setGroupLabel() {
        groupLabel.textColor = UIColor(named: "LightYellowColor")
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: groupLabel.frame.height-1, width: groupLabel.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.white.cgColor
        groupLabel.layer.addSublayer(bottomLine)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(popGroups))
        groupLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func popGroups() {
        showGroupSelection()
    }
    
    // 顯示/不顯示組別選擇
    func showGroupSelection() {
        fetchGroups()
        groupSelectionOverlayView.isHidden = false
    }
    @objc func hideGroupSelection() {
        groupSelectionOverlayView.isHidden = true
        // update group
        groupLabel.text = userInfo.userGroup
    }
    
    @IBAction func addGroupAction(_ sender: Any) {
        let controller = UIAlertController(title: "新增訂購群組", message: nil, preferredStyle: .alert)
        controller.addTextField { (textField) in
            textField.placeholder = "請輸入群組名稱"
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "新增", style: .default) { (_) in
            // 新增至 DB
            let text = controller.textFields![0].text!
            guard !self.isBlank(text) else {
                return
            }
            self.postGroup(name: text)
            // 關閉視窗
            self.hideGroupSelection()
        }
        controller.addAction(confirmAction)
        present(controller, animated: true, completion: nil)
    }
    
    func postGroup(name: String) {
        struct GroupData: Codable {
            var data: GroupName
        }
        struct GroupName: Codable {
            var group: String
        }
        let postData = GroupData(data: GroupName(group: name))
        
        let url = URL(string: "https://sheetdb.io/api/v1/5hz2yke6qinfs")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let data = try? JSONEncoder().encode(postData) {
            urlRequest.httpBody = data
            URLSession.shared.dataTask(with: urlRequest) { (data, reponse, error) in
                if let data = data,
                   let status = try? JSONDecoder().decode([String:Int].self, from: data),
                   status["created"] == 1 {
                    print("ok")
                    userInfo.userGroup = name
                    DispatchQueue.main.async {
                        self.hideGroupSelection()
                    }
                } else {
                    print("error")
                    DispatchQueue.main.async {
                        self.hideGroupSelection()
                    }
                }
            }.resume()
        }
    }
    
    // 字串是否空白判斷
    func isBlank(_ string: String) -> Bool {
        for char in string {
            if !char.isWhitespace {
                return false
            }
        }
        return true
    }
}
