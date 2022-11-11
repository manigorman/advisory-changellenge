//
//  TabBarViewController.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import UIKit

protocol ITabBarView: AnyObject {
    func setControllers(_ controllers: [UIViewController], animated: Bool)
}

final class TabBarViewController: UITabBarController {
    
    // Dependencies
    private let presenter: ITabBarPresenter
    
    // Private
    
    // MARK: - Initialization
    
    init(presenter: ITabBarPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

// MARK: - ITabBarView

extension TabBarViewController: ITabBarView {
    func setControllers(_ controllers: [UIViewController], animated: Bool) {
        self.setViewControllers(controllers, animated: animated)
    }
}
