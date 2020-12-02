//
//  FileDownloadManager.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/12/02.
//

import Foundation
import Alamofire
public extension Notification.Name {
    static let naruFileDownloadProgressDidChange = Notification.Name("naruFileDownloadProgressDidChange_observer")
}
public class NaruFileDownloadManager {    
    public func download(url:URL?,complete:@escaping(_ downloadFileURL:URL?)->Void) {
        guard let url = url else {
            return
        }
        if let fileUrl = UserDefaults.standard.url(forKey: url.absoluteString) {
            if FileManager.default.fileExists(atPath: fileUrl.path) == true {
                complete(fileUrl)
                return
            }
        }
        
        let audioFileName = url.lastPathComponent
        
        let destination: DownloadRequest.Destination = { _, _ in
               var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
               documentsURL.appendPathComponent(audioFileName)
               return (documentsURL, [.removePreviousFile])
        }

        AF.download(url, to: destination)
            .downloadProgress(closure: { (progress) in
                NotificationCenter.default.post(
                    name: .naruFileDownloadProgressDidChange,
                    object: nil, userInfo: ["url":url,"progress":progress])
            })
            .responseURL { (response) in
            if let fileUrl = response.fileURL {
                complete(fileUrl)
                UserDefaults.standard.set(fileUrl, forKey: url.absoluteString)
            }
            else {
                complete(nil)
            }
            
        }
        
    }
}
