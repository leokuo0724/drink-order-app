//
//  CoverFlowViewController.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/14.
//

import UIKit

private let baseCellID = "baseCellID"

var userInfo = UserInfo(userName: "彼得潘", userGroup: "17 彼得潘班", editCode: "9999")

var allDrinks: Array<DrinkData> = []
var allDrinkImages: [String : UIImage] = [:]
var selectedDrink: DrinkData?
var order = Order(drinkName: nil, drinkTemp: nil, drinkSugar: nil, drinkSize: nil, saySomething: nil, totalPrice: nil)

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var indicator: UIView!
    @IBOutlet weak var orderListBtn: UIButton!
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        fetchItem()
        // order list btn
        orderListBtn.layer.cornerRadius = 6
        orderListBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(toDrinkDetail), name: NSNotification.Name("toDrinkDetail"), object: nil)
    }
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allDrinks.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: baseCellID, for: indexPath) as! BaseCollectionViewCell
        
        cell.drinkInfo = allDrinks[indexPath.row]
        cell.setValues()
        
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bringMiddleCellToFront()
    }
    
    // Fetch Data
    func fetchItem() {
        // Get data
        let urlStr = "https://spreadsheets.google.com/feeds/list/1yAyoNkOetc7JvSFQLs8LGpm2psypOi-QBMpRnWuo2sg/od6/public/values?alt=json"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                if let data = data {
                    do {
                        let result = try decoder.decode(SheetStruct.self, from: data)
                        allDrinks = result.feed.entry
                        // 主線更新畫面
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
                
            }.resume()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bringMiddleCellToFront() // 把中间的cell的放在最前面
    }
    /// 把中间的cell带到最前面
    fileprivate func bringMiddleCellToFront() {
        let pointX = (collectionView.contentOffset.x + collectionView.bounds.width / 2)
        let point = CGPoint(x: pointX, y: collectionView.bounds.height / 2)
        let indexPath = collectionView.indexPathForItem(at: point)
        if let letIndexPath = indexPath {
            let cell = collectionView.cellForItem(at: letIndexPath)
            guard let letCell = cell else {
                return
            }
            // 把cell放到最前面
            collectionView.bringSubviewToFront(letCell)
        }
    }
    
    private func setUpView() {
        // 创建flowLayout对象
        let layout = CoverFlowLayout()
        
        let margin: CGFloat = 80
        let collH: CGFloat = 500
        let itemH = (collH - margin * 2)
        let itemW = ((view.bounds.width - margin * 2) / 2)
        
        layout.itemSize = CGSize(width: (itemW + 60)*1.5, height: (itemH - 80)*1.5)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        layout.scrollDirection = .horizontal
        // 创建collection
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: collH), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .none
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 注册cell
        collectionView.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: baseCellID)
        view.addSubview(collectionView)
        // autoLayout
        let collectionViewBottom = NSLayoutConstraint(item: collectionView!, attribute: .top, relatedBy: .equal, toItem: indicator, attribute: .bottom, multiplier: 1, constant: 12)
        let collectionViewWidth = NSLayoutConstraint(item: collectionView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: view.bounds.width)
        let collectionViewHeight = NSLayoutConstraint(item: collectionView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: collH)
        NSLayoutConstraint.activate([ collectionViewBottom, collectionViewWidth, collectionViewHeight ])
    }
    
    // 到飲料詳細頁面
    @objc func toDrinkDetail() {
        if let controller = storyboard?.instantiateViewController(identifier: "DrinkDetailViewController") as? DrinkDetailViewController {
            present(controller, animated: true, completion: nil)
        }
    }
    
    // 到訂購清單頁面
    @IBAction func toOrderList(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(identifier: "OrderListViewController") as? OrderListViewController {
//            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
        }
    }
}

