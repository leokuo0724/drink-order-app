//
//  LoginViewController.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/19.
//

import UIKit

var userInfo = UserInfo(userName: "", userGroup: "", editCode: "")

extension UIViewController {
    func presentLoading() {
        let controller = LoadingViewController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    func dismissLoading() {
        let topVC = topMostViewController()
        print(topVC)
        guard topVC is LoadingViewController else {
            return
        }
        topVC.dismiss(animated: true, completion: nil)
    }
    // 拿到最上層 VC
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        return self.presentedViewController!.topMostViewController()
    }
}

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var groups: Array<String> = []
    
    enum HintType {
        case info, danger
    }
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var userNameTextField: LoginTextField!
    @IBOutlet weak var editCodeTextField: LoginTextField!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var groupTableView: UITableView!
    @IBOutlet weak var groupSelectionOverlayView: UIView!
    @IBOutlet weak var groupSelectionView: UIView!
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var bottomSheetIcon: UIImageView!
    @IBOutlet weak var bottomSheetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGroupLabel()
        hideGroupSelection()
        
        imageContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageContainer.layer.shadowOpacity = 0.3
        imageContainer.layer.shadowRadius = 4
        
        // NotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(hideGroupSelection), name: NSNotification.Name("hideGroupSelection"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userNameTextField.text = ""
        editCodeTextField.text = ""
        groupLabel.text = ""
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
        presentLoading()
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
                        self.dismissLoading()
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        self.dismissLoading()
                    }
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
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.groupSelectionView.frame.origin.y = 306
        }
    }
    @objc func hideGroupSelection() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.groupSelectionView.frame.origin.y = 898
        } completion: { (_) in
            // update group
            self.groupLabel.text = userInfo.userGroup
            self.groupSelectionOverlayView.isHidden = true
        }
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
        
        presentLoading()
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
                        self.dismissLoading()
                        self.hideGroupSelection()
                    }
                } else {
                    print("error")
                    DispatchQueue.main.async {
                        self.dismissLoading()
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
    
    // 登入
    @IBAction func LoginAction(_ sender: Any) {
        guard !isBlank(userNameTextField.text!),
              !isBlank(editCodeTextField.text!),
              editCodeTextField.text?.count == 4,
              !isBlank(groupLabel.text!) else {
            showHintSheet(type: .danger, message: "登入資料錯誤或尚未填寫")
            return
        }
        userInfo.userName = userNameTextField.text!
        userInfo.editCode = editCodeTextField.text!
        if let controller = storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController {
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
        }
    }
    
    // edit code hint btn
    @IBAction func editCodeHintAction(_ sender: Any) {
        showHintSheet(type: .info, message: "當對訂購資料刪除時需要提供驗證碼")
    }
    
    func showHintSheet(type: HintType, message: String) {
        switch type {
        case .info:
            bottomSheetIcon.image = UIImage(systemName: "info.circle")
            bottomSheetIcon.tintColor = UIColor(named: "DeepBlueColor")
            bottomSheetLabel.textColor = UIColor(named: "DeepBlueColor")
        case .danger:
            bottomSheetIcon.image = UIImage(systemName: "exclamationmark.circle.fill")
            bottomSheetIcon.tintColor = UIColor(named: "RedColor")
            bottomSheetLabel.textColor = UIColor(named: "RedColor")
        }
        bottomSheetLabel.text = message
        
        // position
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
            self.bottomSheetView.frame.origin.y -= 90
        } completion: { (_) in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 3, options: .curveEaseOut) {
                self.bottomSheetView.frame.origin.y += 90
            }
        }
    }
    
}
