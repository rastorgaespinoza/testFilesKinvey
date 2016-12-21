//
//  SearchFileViewController.swift
//  uploadFiles
//
//  Created by admin on 12/20/16.
//  Copyright © 2016 solu4b. All rights reserved.
//

import UIKit
import Kinvey

class SearchFileViewController: UIViewController {

    var localPath: URL?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func searchPhoto(_ sender: Any) {
        pickAnImageFrom(sourceType: UIImagePickerControllerSourceType.photoLibrary)
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        
        guard localPath != nil,
            let image = imageView.image else {
                let alert = UIAlertController(title: "Seleccione Imagen", message: "Seleccione una imagen para almacenar", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil) )
                
                present(alert, animated: true, completion: nil)
            return
        }
        
        if let data = UIImagePNGRepresentation(image) as NSData? {
            KinveyClient.sharedInstance().uploadFiles(fileName: "asset.png", data: data, completion: { (success, error) in
                guard error == nil else {
                    print(error!)
                    return
                }
                
                print(success)
            })
        }
        
    }
    
    
    func pickAnImageFrom(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        
        present(pickerController, animated: true, completion: nil)
    }
}

extension SearchFileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let imageUrl          = info[UIImagePickerControllerReferenceURL] as? NSURL
            let imageName         = imageUrl?.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let photoURL          = NSURL(fileURLWithPath: documentDirectory)
            let localPath         = photoURL.appendingPathComponent(imageName!)
            
            self.localPath = localPath
            
            print("image: \(image)")
            print("imageUrl: \(imageUrl)")
            print("imageName: \(imageName)")
            print("documentDirectory: \(documentDirectory)")
            print("photoURL: \(photoURL)")
            print("localPath: \(localPath)")
            
            if !FileManager.default.fileExists(atPath: localPath!.path) {
                do {
                    try UIImageJPEGRepresentation(image, 1.0)?.write(to: localPath!)
                    print("file saved")
                }catch {
                    print("error saving file")
                }
            }
            else {
                print("file already exists")
            }
            
        }
        
        dismiss(animated: true, completion: nil)

    }

}
