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
                let nib = UINib(nibName: "WalletCell", bundle: nil)
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
