//
//  PlayerState.swift
//  musicSheet
//
//  Created by Jz D on 2020/2/21.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit

import RxSwift



struct PlayerViewCtrlLayout{
    static let arrowBtnWidth: CGFloat = 36
    static let arrowBtnHeight: CGFloat = 50
    
}


struct PlayerControl {
    static let piano_beats: Double = 1
    static let violin_beats: Double = 1
    
    static let imgPaused = "player_audioPause"
    
    
    static let imgOK = "btn_play_ok"
    static let imgOK_tbd = "btn_play_tbd"
    static let record_OK = "p_record"
}



typealias MusicIndicator = [(Float, Int)]?

struct ComposeLayout {
    var rowHeights: [Int: CGFloat]?
    var rowPaddings: [Int: UIEdgeInsets]?
    var imgList: [String]
    
    var audio_indicator: MusicIndicator
    var tuning_indicator: MusicIndicator

    var durationTuning: Float?
    
    
    init(_ info: MusicScore?){
        
        if let data = info{
               rowHeights = data.heights
               rowPaddings = data.padding
               imgList = data.img_url
               
               audio_indicator = data.audioLollipop
               tuning_indicator = data.tuningMarron
           
               
               if let times = tuning_indicator, let moment = times.last{
                   durationTuning = moment.0
               }
           }
           else{
               rowHeights = nil
               rowPaddings = nil
               imgList = []
               
               audio_indicator = nil
               tuning_indicator = nil
        
               
               durationTuning = nil
           }
    }
    
    
    
}









struct MusicScoreScalar {
    static let pointNum = 3 * 2
    //  from
    //  to
    //  size
}





struct MusicScore: Decodable {
    
    let coordinate: [Int: [CGFloat]]
    let fp_txt: String?
    
    let img_url: [String]
    let metronome: Int
    let number: Int
    private let time_node: [[WhatSoEver]]?
    private let turning_time_node: [[WhatSoEver]]?
    
    let audio_url: String?
    private let beat_speed: WhatSoEver?
    private let musical: String
    private let musical_id: WhatSoEver?
    
    let padding: [Int: UIEdgeInsets]
    let heights: [Int: CGFloat]
    
    let audioLollipop: [(Float, Int)]
    let tuningMarron: [(Float, Int)]
    
    
    let hasTuning: Bool
    
    let version: Int
    
    private enum CodingKeys: String, CodingKey {
        case coordinate, fp_txt
        case img_url, number
        case time_node, turning_time_node
        case audio_url, musical, beat_speed
        case musical_id, metronome = "new_metronome"
        case version
    }
    
    
    init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
         var coordinateInfo: [Int: [CGFloat]] = [0: [0]]
        
         var shallThrow = true
         if let value = try? container.decodeIfPresent([Int: [CGFloat]].self, forKey: .coordinate){
             coordinateInfo = value
             shallThrow = false
         }
         if let gotIt = try? container.decodeIfPresent([String: [CGFloat]].self, forKey: .coordinate) {
             coordinateInfo = Dictionary(uniqueKeysWithValues: gotIt.map { key, value in ( Int(key) ?? 0, value) })
             shallThrow = false
         }
         coordinate = coordinateInfo
        
         if let value = try? container.decodeIfPresent(String?.self, forKey: .fp_txt){
             fp_txt = value
         }
         else{
             fp_txt = ""
         }
     
         if let value = try? container.decodeIfPresent([String].self, forKey: .img_url){
             img_url = value
         }
         else{
             img_url = []
         }
         if let value = try? container.decodeIfPresent(WhatSoEver?.self, forKey: .beat_speed){
             beat_speed = value
         }
         else{
             beat_speed = .int(0)
         }
         if let value = try? container.decodeIfPresent(Int.self, forKey: .number){
             number = value
         }
         else{
             number = 0
         }
        
        
         if let value = try? container.decodeIfPresent(String.self, forKey: .musical){
             musical = value
         }
         else{
             musical = ""
         }
         
         
        
        
         if let value = try? container.decodeIfPresent(Int.self, forKey: .metronome){
             metronome = value
         }
         else{
             metronome = 0
         }
        
         if let value = try? container.decodeIfPresent([[WhatSoEver]]?.self, forKey: .time_node){
             time_node = value
         }
         else{
             time_node = nil
         }
        
         if let value = try? container.decodeIfPresent([[WhatSoEver]]?.self, forKey: .turning_time_node){
            turning_time_node = value
            hasTuning = true
         }
         else{
            turning_time_node = nil
            hasTuning = false
         }
        
        
        
         if let value = try? container.decodeIfPresent(String?.self, forKey: .audio_url){
             audio_url = value
         }
         else{
             audio_url = nil
         }
 
         
         if let value = try? container.decodeIfPresent(WhatSoEver?.self, forKey: .musical_id){
             musical_id = value
         }
         else{
             musical_id = nil
         }
        
// MARK:- 进入 init , computer
 
        var divorcee = [Int: UIEdgeInsets]()
        var mutiny_h_s = [Int: CGFloat]()
        let width = UI.width
        for piece in coordinate{
            guard piece.value.count == MusicScoreScalar.pointNum else {
                continue
            }
            
                let ratio = width/piece.value[5]
                let offsetX = CGFloat(piece.value[0])*ratio
                let offsetY = CGFloat(piece.value[1])*ratio
                let endX = width - CGFloat(piece.value[2])*ratio
                let endY = (piece.value[4] - piece.value[3])*ratio
                divorcee[piece.key] = UIEdgeInsets(top: offsetY, left: offsetX, bottom: endY, right: endX)
//

                let imageHeight = piece.value[4] * ratio
                mutiny_h_s[piece.key] = imageHeight
            
        }
        padding = divorcee
        heights = mutiny_h_s
    
        

        var lollipop: [(Float, Int)] = [(0, -1)]
        if let nodes = time_node{
            for cupcake in nodes{
                lollipop.append((cupcake[0].float, cupcake[1].scalar))
            }
        }
        audioLollipop = lollipop
        
        var lollipop_tune: [(Float, Int)] = [(0, -1)]
        if let nodes = turning_time_node{
            for cupcake in nodes{
                lollipop_tune.append((cupcake[0].float, cupcake[1].scalar))
            }
        }
        tuningMarron = lollipop_tune
        

// MARK:- End it, final
        if let value = try? container.decodeIfPresent(Int.self, forKey: .version){
            version = value
        }
        else{
            version = 0
        }
        
        
///
        
         if shallThrow{
             throw WhatSoEverError.missingValue
         }
        
         return
    }
    
    
    
    
}








extension MusicScore{
    
    
    
    var musicType: Int{
        let val = musical_id?.scalar
        return val ?? 1
    }
}

