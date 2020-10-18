//
//  CacheImage.swift
//  musicSheet
//
//  Created by Jz D on 2019/10/28.
//  Copyright © 2019 Jz D. All rights reserved.
//

import UIKit


import Kingfisher



extension KingfisherWrapper where Base: UIImageView {

    @discardableResult
    func img_P(_ name: String) -> String{
        let results = name.matches(for: ".+jpg|.+png")
        var k = ""
        if results.count > 0, let path = URL(string: name) {
            k = results[0]
            
            let resource = ImageResource(downloadURL: path, cacheKey: k)
            setImage(with: resource)
            
        }
        else{
            setImage(with: URL(string: name))
            
        }
        return k
    }
    
}


extension String{
    

    
    func matches(for regex: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error)")
            return []
        }
    }
    

    
}



