//
//  WalletAdapterDelegate.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 15.12.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import Foundation

protocol WalletAdapterDelegate: NSObjectProtocol {
    func walletDidSelect(at postion: Int, with wallet: Wallet)
    func walletWillOpen(at postion: Int, with wallet: Wallet)
    func updateWalletAdapter()
}
