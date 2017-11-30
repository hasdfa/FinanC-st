//
//  WalletAdapter.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 18.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class WalletAdapter: NSObject {
    
    weak var delegate: WalletAdapterDelegate? = nil
    weak var collectionView: UICollectionView? = nil {
        didSet {
            if collectionView != nil {
                let nib = UINib(nibName: "CardCell", bundle: nil)
                collectionView!.register(nib, forCellWithReuseIdentifier: "wallet")
            }
        }
    }
    
    init(_ wallets: [Wallet]) {
        super.init()
        self.wallets = wallets
    }
    
    var wallets: [Wallet] = [] {
        didSet {
            delegate?.updateWalletAdapter()
        }
    }
    
    var selectedWalletIndexPath: IndexPath = IndexPath(row: 0, section: 0) {
        didSet {
            self.collectionView?.scrollToItem(at: selectedWalletIndexPath, at: .left, animated: true)
        }
    }
    var selectedWallet: Wallet {
        return wallets[selectedWalletIndexPath.row]
    }
    
    var cellWidth: CGFloat {
        get {
            return collectionView?.visibleCells.first?.bounds.width ?? 1
        }
    }
    
    var isScrolling = false
    
}

protocol WalletAdapterDelegate: NSObjectProtocol {
    func walletDidSelect(at postion: Int, with wallet: Wallet)
    func walletWillOpen(at postion: Int, with wallet: Wallet)
    func updateWalletAdapter()
}

extension WalletAdapter: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wallet", for: indexPath) as! WalletViewCell
        if indexPath.row < 0 || indexPath.row >= wallets.count { return cell }
        
        cell.initWith(wallet: wallets[indexPath.row])
        cell.isSelectedWallet = (indexPath == selectedWalletIndexPath)
        
        return cell
    }
    
    func selectedCell() -> WalletViewCell {
        return collectionView?.cellForItem(at: selectedWalletIndexPath) as! WalletViewCell
    }
}

extension WalletAdapter: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? WalletViewCell
        cell?.isSelectedWallet = true
        
        let wallet = wallets[indexPath.row]
        if indexPath == selectedWalletIndexPath && !isScrolling {
            delegate?.walletWillOpen(at: indexPath.row, with: wallet)
        } else {
            delegate?.walletDidSelect(at: indexPath.row, with: wallet)
        }
        selectedWalletIndexPath = indexPath
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? WalletViewCell
        cell?.isSelectedWallet = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        defer { isScrolling = false }
        isScrolling = true
        
        if let collectionView = self.collectionView {
            targetContentOffset.pointee = scrollView.contentOffset
            var factor: CGFloat = 0.5
            if velocity.x < 0 {
                factor = -factor
            }
            var indexPath = IndexPath(
                row: (Int(scrollView.contentOffset.x/cellWidth + factor)),
                section: 0
            )
            if indexPath.row < 0 || indexPath.row >= self.wallets.count {
                return
            }
            
            if indexPath.row != selectedWalletIndexPath.row {
                if indexPath.row > selectedWalletIndexPath.row {
                    indexPath.row = selectedWalletIndexPath.row + 1
                } else {
                    indexPath.row = selectedWalletIndexPath.row - 1
                }
            }
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            
            self.collectionView(collectionView, didDeselectItemAt: selectedWalletIndexPath)
            self.collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
}




