//
//  ViewController.swift
//  FFmpeg_iOS_Demo
//
//  Created by panf on 2019/8/13.
//  Copyright © 2019 无码科技. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        let inputPath = Bundle.main.path(forResource: "video", ofType: "mp4") ?? ""
//        let doc = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
//        let outputPath = (doc as! NSString).appendingPathComponent("videoConver.mov")
        
    
        
        let inputPath = Bundle.main.path(forResource: "video", ofType: "MOV") ?? ""
        let doc = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let outputPath = (doc as! NSString).appendingPathComponent("videoConver.mp4")
        print("outputPath is : \n\(outputPath)")
        if FileManager.default.fileExists(atPath: outputPath) {
            try? FileManager.default.removeItem(atPath: outputPath)
        }

        LEYFFmpegManager.shared().conver(withInputPath: inputPath, outputPath: outputPath, processBlock: { value in
            print("value is : \(value)")
        }) { (error) in
            
        }

    }
}

