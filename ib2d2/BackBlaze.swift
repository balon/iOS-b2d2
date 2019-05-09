//
//  BackBlaze.swift
//  ib2d2
//
//  Created by balon on 5/7/19.
//  Copyright © 2019 TJ balon. All rights reserved.
//

import Foundation
import UIKit

// BackBlaze class for handling all BackBlaze Operations
public class BackBlaze {
    private var accountId: String = ""
    private var applicationKey: String = ""
    private var bucketName: String = ""
    private var bucketId: String = ""
    private var accAuthToken: String = ""
    private var upAuthToken: String = ""
    private var uploadUrl: String = ""
    private var apiUrl: String = ""
    private var downUrl: String = ""
    private var fileID: String = ""
    private var downPath: String = ""
    
    init(ai: String, ak: String, bn: String){
        self.accountId = ai
        self.applicationKey = ak
        self.bucketName = bn
    }
    
    // edited b2_authorize_account (source: https://www.backblaze.com/b2/docs/b2_authorize_account.html)
    private func authorize(){
        // Web Requests are Async... We want to lock this to get our API info!
        let sem = DispatchSemaphore(value: 0)
        
        // Create a url and authorization header data
        guard let url = URL(string: "https://api.backblazeb2.com/b2api/v2/b2_authorize_account"),
            let authNData = "\(self.accountId):\(self.applicationKey)".data(using: .utf8) else {
                return
        }
        
        // Create the request. Take note that the authNData must be base64 encoded.
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Basic \(authNData.base64EncodedString())", forHTTPHeaderField: "Authorization")
        
        // Create a  task with the request we created above.
        let task = URLSession.shared.dataTask(with: request) { (data, response, error ) in
            if data != nil {
                //let json = String(data: data!, encoding:.utf8)
                let response = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]

                // get the auth token + bucketID
                if let status = response!["status"] as? [String: Any]{
                    print("bad authorization.. check your settings")
                    print(status)
                    // No use tying up the system.. unlock
                    sem.signal()
                } else {
                    // authorized successfully.. get our data
                    self.accAuthToken = (response!["authorizationToken"] as? String)!
                    self.apiUrl = (response!["apiUrl"] as? String)!
                    self.downUrl = (response!["downloadUrl"] as? String)!
                    //print((response!["authorizationToken"] as? String)!)
                    // now lets unpack the deeper response, and get the bucket id
                    if let nResponse = response!["allowed"] as? [String: Any]{
                        if nResponse["bucketName"] as? String == self.bucketName{
                            self.bucketId = nResponse["bucketId"] as! String
                        } else {
                            print("bad bucket name")
                        }
                    }
                }
                
                // We unpacked all our data from the API.. We can move on
                sem.signal()
            }
        }
        
        // Start the task
        task.resume()
        
        // Wait for this task to complete
        sem.wait()
    }
    
    // edited b2_get_upload_url (source: https://www.backblaze.com/b2/docs/b2_get_upload_url.html)
    private func getUploadUrl(){
        // Web Requests are Async... We want to lock this to get our API info!
        let sem = DispatchSemaphore(value: 0)

        // Create the request
        var request = URLRequest(url: URL(string: "\(self.apiUrl)/b2api/v2/b2_get_upload_url")!)
        request.httpMethod = "POST"
        request.addValue(self.accAuthToken, forHTTPHeaderField: "Authorization")
        request.httpBody = "{\"bucketId\":\"\(self.bucketId)\"}".data(using: .utf8)
        
        // Create the task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let response = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.upAuthToken = response!["authorizationToken"] as! String
                self.uploadUrl = response!["uploadUrl"] as! String
                
                // AAAAAnd.. unlock
                sem.signal()
            }
            
        }
        
        // Start the task
        task.resume()
        
        // Wait for our settings we still need
        sem.wait()
    }
    
    // b2_upload_file (source: )
    private func uploadFile(data: Data, fileName: String, fileType: String, sha1: String){
        // Web Requests are Async... We want to lock this to get our file!
        let sem = DispatchSemaphore(value: 0)
        
        // Create request
        var request = URLRequest(url: URL(string: self.uploadUrl)!)
        request.httpMethod = "POST"
        request.addValue(self.upAuthToken, forHTTPHeaderField: "Authorization")
        request.addValue(fileName, forHTTPHeaderField: "X-Bz-File-Name")
        request.addValue(fileType, forHTTPHeaderField: "Content-Type")
        request.addValue(sha1, forHTTPHeaderField: "X-Bz-Content-Sha1")
        
        // Create task
        let task = URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
            if let data = data {
                let response = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.fileID = response!["fileId"] as! String

                // Unlock our wait then return our file....
                sem.signal()
            }
        }
        
        // Start task
        task.resume()
        
        // Wait to confirm upload
        sem.wait()
    }
    
    
    private func downloadFile(fileID: String){
        // Web Requests are Async... We need to download our file!
        let sem = DispatchSemaphore(value: 0)
        
        // Create the URL
        var urlComponents = URLComponents(string: "\(self.downUrl)/b2api/v2/b2_download_file_by_id")!
        urlComponents.query = "fileId=\(fileID)"
        
        // Create the request
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.addValue(accAuthToken, forHTTPHeaderField: "Authorization")
        
        // Create the task
        let task = URLSession.shared.downloadTask(with: request) { (url, urlResponse, error) in
            // Assuming the download was successful
            self.downPath = (url?.path)!
            
            // Unlock our wait then return our file....
            sem.signal()
        }
        
        // Start the task
        task.resume()
        
        // Wait to confirm download
        sem.wait()
    }
    
    public func upload(data: Data, fileName: String, fileType: String, sha1: String) -> String{
        authorize()
        getUploadUrl()
        uploadFile(data: data, fileName: fileName, fileType: fileType, sha1: sha1)
        return self.fileID
    }
    
    public func download(fileID: String) -> String{
        authorize()
        downloadFile(fileID: fileID)
        return self.downPath
    }
}

