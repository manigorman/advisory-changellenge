//
//  TabBarPresenter.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import UIKit

protocol ITabBarPresenter: AnyObject {
    func viewDidLoad()
}

final class TabBarPresenter {
    
    // Dependencies
    weak var view: ITabBarView?
    
    // Private
    
    // Models
    
    // MARK: - Initialization
    
    init() {
    }
    
    // MARK: - Private
}

// MARK: - ITabBarPresenter

extension TabBarPresenter: ITabBarPresenter {
    func viewDidLoad() {
    }
}
