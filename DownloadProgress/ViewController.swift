//
//  ViewController.swift
//  DownloadProgress
//
//  Created by SO YOUNG on 2018. 1. 6..
//  Copyright © 2018년 SO YOUNG. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {

    @IBOutlet weak var lbl_percent: UILabel!
    @IBOutlet weak var progress_down: UIProgressView!
    
    var session: URLSession!
    var downloadTask: URLSessionDownloadTask!
    
    @IBAction func downloadClicked(_ sender: UIButton) {
        session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        if let url = URL(string: "http://www.sample-videos.com/audio/mp3/wave.mp3") {
            downloadTask = session.downloadTask(with: url)
            downloadTask.resume()
        }
    }
    
    //MARK: URLSessionDownloadDelegate
    //파일 다운로드 완료시 호출됨
    //location : 다운로드 받은 파일의 경로
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("다운로드 완료! \(location)")
        session.finishTasksAndInvalidate()
        
        //cache 디렉토리
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let catchPath = path[0]
        print("\(catchPath)")
        let destPath = URL(fileURLWithPath: catchPath + "/wave.mp3")
        
        let fileManager = FileManager()
        
        //기존 파일 존재시 파일 삭제 후 다운로드받은 파일 이동
        if fileManager.fileExists(atPath: destPath.path) {
            do {
             try fileManager.removeItem(at: destPath)
            } catch let error {
                print("파일 삭제 에러\(error.localizedDescription)")
            }
        }
        
        do {
         try fileManager.moveItem(at: location, to: destPath)
        } catch let error {
            print("파일 이동 에러\(error.localizedDescription)")
        }
        
        
        
        
    }
    
    
    //파일 다운로드중 호출
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(totalBytesWritten)
        lbl_percent.text = String(Int(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite) * 100)) + "%"
        progress_down.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
    }
    
    
    

}

