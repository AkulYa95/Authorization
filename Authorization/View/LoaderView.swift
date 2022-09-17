//
//  LoaderView.swift
//  Authorization
//
//  Created by Ярослав Акулов on 17.09.2022.
//

import UIKit

class LoaderView: UIView {
    @IBOutlet private weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("LoaderView",
                                 owner: self,
                                 options: nil)
        self.alpha = 0
        self.backgroundColor = .clear
        self.addSubview(self.contentView)
        contentView.frame = frame
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Bundle.main.loadNibNamed("LoaderView",
                                 owner: self,
                                 options: nil)
        self.alpha = 0
        self.backgroundColor = .clear
        self.addSubview(self.contentView)
    }
    func showLoader() {
        guard self.alpha != 1  else { return }
        self.alpha = 1
    }
    func hideLoader() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        }
    }
}
