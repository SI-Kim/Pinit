//
//  MySideMenuNavigationController.swift
//  FirebasePractice
//
//  Created by 김성일 on 2019/12/28.
//  Copyright © 2019 Skim88.1942. All rights reserved.
//

import UIKit
import SideMenu

class MySideMenuNavigationController: SideMenuNavigationController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        mySidemenu 전역 변수에 사이드바 화면 대입
                appDelegate.mySidemenu = self

        //        사이드메뉴 넓이 설정
                self.menuWidth = 250
                
        //        사이드메뉴 열리는 시간 설정
                self.presentDuration = 0.2
                
        //        사이드바가 나타나는 스타일 설정
                self.presentationStyle = .viewSlideOutMenuIn
    }
    

    
}
