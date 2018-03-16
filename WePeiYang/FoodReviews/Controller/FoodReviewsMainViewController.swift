//
//  FoodReviewsMainViewController.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/3/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class FoodReviewsMainViewControloler: UIViewController {
    
    typealias DiningHallData = (title: String, image: UIImage)
    fileprivate let DiningHallDatas: [DiningHallData] = [
        (title: "学一食堂", image: UIImage(named: "梅")!), (title: "学二食堂", image: UIImage(named: "兰")!),
        (title: "学三食堂", image: UIImage(named: "棠")!), (title: "学四食堂", image: UIImage(named: "竹")!),
        (title: "学五食堂", image: UIImage(named: "桃")!), (title: "学六食堂", image: UIImage(named: "菊")!),
        (title: "留园食堂", image: UIImage(named: "留")!), (title: "青园食堂", image: UIImage(named: "青")!)]
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.view.bounds.width/4, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        
        collectionView.register(DiningHallCollectionViewCell.self, forCellWithReuseIdentifier: "FoodCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        self.view.addSubview(collectionView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(red: 0.1059, green: 0.6352, blue: 0.9019, alpha: 1)), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.tintColor = .white
    }
    
    
    
}

extension FoodReviewsMainViewControloler: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DiningHallDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell", for: indexPath) as? DiningHallCollectionViewCell {
            let data = DiningHallDatas[indexPath.row]
            cell.imageView.image = data.image
            cell.titleLabel.text = data.title
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}
