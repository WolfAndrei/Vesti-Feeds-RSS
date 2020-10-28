//
//  DetailController.swift
//  Vesti Feeds RSS
//
//  Created by Andrei Volkau on 27.10.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    // root view
    let detailView = DetailView()
    
    
    // viewController lifeCycle
    override func loadView() {
        view = detailView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    // setting up navigation Bar
    private func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        title = "Новость"
    }
}

