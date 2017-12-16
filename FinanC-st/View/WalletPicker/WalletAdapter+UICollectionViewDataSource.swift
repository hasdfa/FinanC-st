//
//  WalletAdapter+UICollectionViewDataSource.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 15.12.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

extension WalletAdapter: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallets.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == wallets.count {
            
        }
        
        let cell = collectionView   .dequeueReusableCell(withReuseIdentifier: "wallet", for: indexPath) as! WalletViewCell
        if indexPath.row < 0 || indexPath.row >= wallets.count { return cell }
        
        cell.initWith(wallet: wallets[indexPath.row])
        cell.isSelectedWallet = (indexPath == selectedWalletIndexPath)
        
        return cell
    }
    
    func selectedCell() -> WalletViewCell {
        return collectionView?.cellForItem(at: selectedWalletIndexPath) as! WalletViewCell
    }
}
