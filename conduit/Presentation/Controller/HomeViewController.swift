//
//  HomeViewController.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 19/05/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    private let tags = ["lmao", "ded", "ooomphless"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTagCollection()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private func setupTagCollection() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.register(UINib(nibName: "UIMaterialChip", bundle: nil),
                                   forCellWithReuseIdentifier: UIMaterialChip.reuseIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let chip = collectionView.dequeueReusableCell(withReuseIdentifier: UIMaterialChip.reuseIdentifier,
                                                      for: indexPath) as! UIMaterialChip
        chip.label.text = tags[indexPath.row]
        return chip
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelWidth = tags[indexPath.row].size(withAttributes: [.font: UIMaterialChip.labelFont]).width
        return CGSize(width: labelWidth + 40, height: 40)
    }
}
