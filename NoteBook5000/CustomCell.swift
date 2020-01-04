//
//  CustomCell.swift
//  FarmersMarked
//
//  Created by Grp5000 on 17/10/2019.
//  Copyright © 2019 Haulik. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    var message : String?
    var mainImage : UIImage?
    var imageTekst : String?
    
   /* init(tekst:String, image:String, imageObj:UIImage? = nil) {
       // self.titel = titel
        self.message = tekst
        self.imageTekst = image
        self.mainImage = imageObj
    }*/
    
    var messageView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    var mainImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(mainImageView)
        self.addSubview(messageView)
        
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
 /* */  mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
 /* */  mainImageView.bottomAnchor.constraint(equalTo: self.messageView.topAnchor).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        messageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        messageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    /*  mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mainImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        messageView.leftAnchor.constraint(equalTo: self.mainImageView.rightAnchor).isActive = true
        messageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        messageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    */
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let message = message {
            messageView.text = message
        }
        if let image = mainImage {
            mainImageView.image = image
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

