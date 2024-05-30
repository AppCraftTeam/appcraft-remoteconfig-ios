//
//  BSDimmBackgroundViewFactory.swift
//  World Run League
//
//  Created by Damian Bazhenov on 3.5.2022.
//  Copyright © 2022 AppCraft. All rights reserved.
//

import UIKit

struct BSDimmBackgroundViewFactory: BSCustomPresentationBackgroundFactory {
    
    let backgroundColor: UIColor
    
    init(backgroundColor: UIColor = UIColor(white: 0, alpha: 0.3)) {
        self.backgroundColor = backgroundColor
    }
    
    func backgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.alpha = 0
        return view
    }
}
