//
//  Helper.swift
//  uploadFiles
//
//  Created by admin on 12/20/16.
//  Copyright © 2016 solu4b. All rights reserved.
//

import Foundation

class Helper {
    
    static func fileCreate( fileName: String, data: NSData){
        
//        let baseURL = "/blob/kid_rJIZClLNg/"
//        let url = baseURL
////        var file = File()
//        
//        var body = "{\"_filename\":\"" + fileName + "\",\"size\":" + url + ",\"mimeType\":\"image/png\"}"//+ "\", \"photoJson\":" + files.json
//        dynamic resultCreateFile = KinveyBase.PostWithEncoded(url, body, KinveyConstant.encodedMaster);
//        var jsonResul = JObject.Parse(resultCreateFile);
//        string idFile = jsonResul._id;
//        string uploadUrl = jsonResul._uploadURL;
//        
//        if (idFile != null) { PutFile(uploadUrl, data); }
//        return idFile;
    }
}

//public static string FileCreate(Files files,byte[] data)
//{
//    
//}
//
//public static string PostWithEncoded(string url, string body, string encoded)
//{
//    
//    byte[] bytedata = Encoding.UTF8.GetBytes(body);
//    
//    var request = WebRequest.Create(url);
//    request.Method = KinveyConstant.REQUEST_POST;
//    request.ContentType = KinveyConstant.CONTENT_TYPE_JSON;
//    request.Headers.Add("Authorization", "Basic " + encoded);
//    
//    request.ContentLength = bytedata.Length;
//    var sendStream = request.GetRequestStream();
//    sendStream.Write(bytedata, 0, bytedata.Length);
//    sendStream.Close();
//    
//    try
//    {
//    HttpWebResponse response = (HttpWebResponse)request.GetResponse();
//    var encoding = UTF8Encoding.UTF8;
//    var reader = new System.IO.StreamReader(response.GetResponseStream(), encoding);
//    string responseText = reader.ReadToEnd();
//    return responseText;
//    }
//    catch (WebException e)
//    {
//    System.Windows.Forms.MessageBox.Show(e.ToString()+"  ||  "+request.ToString());
//    return null;
//    }
//}
