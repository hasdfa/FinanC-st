//
//  WalletAdapter+UICollectionViewDelegate.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 15.12.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

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
