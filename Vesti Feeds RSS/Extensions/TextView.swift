//
//  TextView.swift
//  Vesti Feeds RSS
//
//  Created by Andrei Volkau on 27.10.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class TextView: UITextView {
    var sideInset: CGFloat = 0.0 {
        didSet {
            textContainerInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        }
    }
}
