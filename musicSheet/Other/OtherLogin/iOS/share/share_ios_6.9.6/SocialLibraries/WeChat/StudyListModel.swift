//
//  StudyListModel.swift
//  musicSheet
//
//  Created by Jz D on 2019/11/7.
//  Copyright © 2019 Jz D. All rights reserved.
//

import Foundation


struct PracticeList: Decodable{
    let clock: Int
    let is_clock: Int
    
    let scores_data_list: [ScoresDataList]
    
}




struct ScoresDataList: Decodable{
    
    let score_data: [ScoreData]
    
    let total_data: TotalData
    
}



extension ScoresDataList{
    var scoresFiltered: ([ScoreData], Bool){
        if score_data.count > 2{
            return (Array(score_data[0...1]), true)
        }
        else{
            return (score_data, false)
        }
    }
    
    var scoreListValid: [ScoreData]{
        if score_data.count > 30{
            return Array(score_data[0...29])
        }
        else{
            return score_data
        }
    }
    
}


struct ScoreData: Decodable{
    
    let length: Int
    let nums: Int
    let scores_name: String
    
    
}



struct TotalData: Decodable{
    
    let content: String?
    let contrast: Int?
    let scores_nums: Int
    
    
    let total_length: Int
    let total_nums: Int
    
}
