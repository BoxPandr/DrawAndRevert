//
//  OilForAll.swift
//  musicSheet
//
//  Created by Jz D on 2020/10/12.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Foundation



enum WhatSoEverError:Error {
    case missingValue
}



enum WhatSoEver: Decodable{

    case val(Double), patrol(Float), int(Int), txt(String)

       init(from decoder: Decoder) throws {
           if let value = try? decoder.singleValueContainer().decode(Double.self) {
               self = .val(value)
               return
           }
        
            if let gotIt = try? decoder.singleValueContainer().decode(Float.self) {
                self = .patrol(gotIt)
                return
            }
        
            if let text = try? decoder.singleValueContainer().decode(String.self) {
                self = .txt(text)
                return
            }
            
            if let int = try? decoder.singleValueContainer().decode(Int.self) {
                self = .int(int)
                return
            }

           throw WhatSoEverError.missingValue
       }

    var float: Float{
        switch self {
        case .val(let doub):
            return Float(doub)
        case .patrol(let pat):
            return pat
        case .int(let interg):
            return Float(interg)
        case .txt(let text):
            return Float(text) ?? 0
        }
    }
    
    
    
    var scalar: Int{
        switch self {
        case .val(let doub):
            return Int(doub)
        case .patrol(let pat):
            return Int(pat)
        case .int(let interg):
            return interg
        case .txt(let text):
            return Int(text) ?? 0
        }
    }
}

