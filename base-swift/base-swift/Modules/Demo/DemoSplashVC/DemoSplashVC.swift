//
//  DemoSplashVC.swift
//  base-swift
//
//  Created by ThiemJason on 25/04/2023.
//  Copyright © 2023 BaseSwift. All rights reserved.
//

import UIKit

class DemoSplashVC: BaseViewModelController<DemoSplashVM> {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        replaceRoot(to: TranslaterVC(), withTransitionType: .push, andTransitionSubtype: .fromRight)
    }
}
