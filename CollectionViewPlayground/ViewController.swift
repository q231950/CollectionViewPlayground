//
//  ViewController.swift
//  CollectionViewPlayground
//
//  Created by Martin Kim Dung-Pham on 20.05.21.
//

import UIKit

enum Item {
    static let width: CGFloat = 130
}

class ViewController: UIViewController {

    let dataSource = DataSource()
    var delegate: CollectionViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = dataSource

        delegate = CollectionViewDelegate(collectionView: collectionView)
        collectionView.delegate = delegate
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: view.frame.midX - Item.width/2,
                                                   bottom: 0,
                                                   right: view.frame.midX - Item.width/2)

        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0)
        ])
    }
}

final class CollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: Item.width, height: 50)
    }

    let collectionView: UICollectionView
    var collectionViewWidth: CGFloat {
        collectionView.bounds.size.width
    }

    init(collectionView: UICollectionView) {

        self.collectionView = collectionView
        super.init()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let original = CGPoint(x: targetContentOffset.pointee.x, y: targetContentOffset.pointee.y)
        let remainder = (original.x + collectionView.contentInset.left).truncatingRemainder(dividingBy: Item.width)

        let shouldMoveRight = remainder < Item.width/2
        let delta = shouldMoveRight ? -remainder : Item.width - remainder

        targetContentOffset.pointee = CGPoint(x: original.x + delta, y: original.y)
    }

}

extension ViewController {

    final class Cell: UICollectionViewCell {

        override init(frame: CGRect) {
            super.init(frame: frame)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        func update(using model: CellModel) {
            backgroundColor = model.color
        }
    }

    struct CellModel {
        let index: Int
        var color: UIColor {
            let x = [UIColor.magenta, UIColor.white, UIColor.darkGray, UIColor.blue, UIColor.green] + [UIColor.magenta, UIColor.white, UIColor.darkGray, UIColor.blue, UIColor.green] + [UIColor.magenta, UIColor.white, UIColor.darkGray, UIColor.blue, UIColor.green]
            return x[index]
        }
    }

    final class DataSource: NSObject, UICollectionViewDataSource {
        let configuration =
            UICollectionView.CellRegistration<Cell, CellModel>(handler: { cell, indexPath, item in
                cell.update(using: item)
            })

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            15
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            collectionView.dequeueConfiguredReusableCell(using: configuration, for: indexPath, item: CellModel(index: indexPath.row))
        }

    }
}

