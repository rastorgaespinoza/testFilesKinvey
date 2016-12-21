//
//  KinveyConvenience.swift
//  buohIpad
//
//  Created by Rodrigo Astorga on 17-06-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation

// MARK: - Write in Kinvey
extension KinveyClient {

    // MARK: - Upload files
    func uploadFiles(fileName: String, data: NSData,  completion: @escaping (_ success: Bool, _ error: Error?) -> Void){
        
        let baseURL = Paths.BaseFiles

        let httpMethod = HTTPMethods.POST
        
        let body: [String: AnyObject] = [
            "_filename": fileName as AnyObject,
            "mimeType": "image/png" as AnyObject
        ]
        
        guard let url = kinveyURL(baseURL) else {
            let userInfo:[String:String] = [NSLocalizedDescriptionKey: "Problema al generar url"]
            let err = NSError(domain: "InvalidNSURL", code: 2, userInfo: userInfo)
            completion(false, err)
            return
        }
        
        taskForMethod(url, HTTPMethod: httpMethod, HTTPBody: body) { (result, error) in
            
            guard error == nil else {
                DispatchQueue.main.async{
                    completion(false, error! as Error)
                }
                return
            }
            
            if let result = result as? [String: AnyObject]{
                
                DispatchQueue.main.async {
                    
                    print(result)
                    
                    if let uploadURL = result["_uploadURL"] as? String{
                        print(uploadURL)
                        self.putPhoto(url: uploadURL, data: data, completion: { (anyobject, error) in
                            guard error == nil else {
                                print(error!)
                                completion(false, error! as Error)
                                return
                            }
                            
                            if let anyobject = anyobject {
                                print(anyobject)
                                completion(true, nil)
                            }else{
                                let userInfo:[String:String] = [NSLocalizedDescriptionKey: "error de formato al leer la información luego de guardar en Files Google (al utilizar función putPhoto)"]
                                let err = NSError(domain: "saveFileBadFormat", code: 5, userInfo: userInfo)
                                completion(false, err)
                            }
                        })
                    }
                }
                
            }else {
                DispatchQueue.main.async {
                    let userInfo:[String:String] = [NSLocalizedDescriptionKey: "error de formato al leer la información luego de guardar en Files Kinvey"]
                    let err = NSError(domain: "saveFileBadFormat", code: 5, userInfo: userInfo)
                    completion(false, err)
                }
                
            }
        }
        
    }
    
    func putPhoto(url: String, data: NSData,  completion: @escaping (_ result: AnyObject?, _ error: Error?) -> Void){
        
        let httpMethod = HTTPMethods.PUT
        
        guard let newURL = kinveyURL(url) else {
            return
        }
        
        // 1. Configuración del request
        var request = URLRequest(url: newURL)
        request.httpMethod = httpMethod
        //        request.addValue(ParameterKeys.AppJSon, forHTTPHeaderField: ParameterKeys.ContentTypeJSon)
        request.addValue("\(data.length)", forHTTPHeaderField: "Content-Length")
        request.setValue(userCredentials, forHTTPHeaderField: ParameterKeys.Authorization)
        request.addValue("image/png", forHTTPHeaderField: "Content-Type")
        
        let task = session.uploadTask(with: request, from: data as Data) { (data, response, error) in
            DispatchQueue.main.async{
                
                func sendError(_ error: String) {
                    
                    let userInfo:[String:String] = [NSLocalizedDescriptionKey: error]
                    let err = NSError(domain: "InvalidParseInformation", code: 1, userInfo: userInfo)
                    completion(nil, err as Error )
                }
                
                /* GUARD: Was there an error? */
                guard (error == nil) else {
                    var message = ""
                    
                    let error = error as! NSError
                    switch error.code {
                    case -1001: //NSURLErrorDomain
                        message = "La solicitud tardó más de lo normal. Revise su conexión a Internet."
                    case -1003:
                        message = "No se pudo encontrar el servidor con el hostname especificado."
                    case -1005:
                        message = "La conexión a Internet se perdió."
                    case -1009:
                        message = "La conexión a Internet parace estar desactivada."
                    case 3840:
                        message = "No se encontró valor. "
                    default:
                        message = "Ocurrió un error durante su solicitud. Revise su conexión a internet.\nDescripción del problema: \(error.localizedDescription)"
                    }
                    sendError(message)
                    return
                }
                
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    sendError("Su solicitud no retornó datos")
                    return
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                    
                    let codeError = (response as? HTTPURLResponse)?.statusCode
                    
                    
                    if JSONSerialization.isValidJSONObject(data) {
                        print("se puede serializar el error de status")
                    }else{
                        print("no se puede serializar el error de status")
                    }
                    // revisa el error en Kinvey:
                    let dataNew: AnyObject!
                    do{
                        dataNew = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                        
                        if let errorTitle = dataNew["error"] as? String,
                            let descriptionError = dataNew["description"] as? String{
                            
                            //Kinvey errors:
                            if let errorKinvey = KVErrorTitle(rawValue: errorTitle)
                            {
                                var message = ""
                                switch errorKinvey {
                                case .InvalidCredentials:
                                    message = "Credenciales Inválidas. El nombre de usuario y/o contraseña es incorrecta. Por favor intente nuevamente con credenciales válidas."
                                case .UserNotFound:
                                    message = "No se encontró usuario en la base de datos."
                                default:
                                    message = descriptionError
                                }
                                
                                let userInfo:[String:String] = [NSLocalizedDescriptionKey: message]
                                let err = NSError(domain: errorTitle, code: codeError!, userInfo: userInfo)
                                completion(nil, err )
                                return
                            }else{
                                let userInfo:[String:String] = [NSLocalizedDescriptionKey: descriptionError]
                                let err = NSError(domain: errorTitle, code: codeError!, userInfo: userInfo)
                                completion(nil, err)
                                return
                            }
                        }
                        else if let descriptionError = dataNew["description"] as? String {
                            sendError(descriptionError)
                        }else{
                            sendError("Su solicitud retornó un código de estado distinto de 2xx!")
                        }
                    }catch {
                        sendError("Su solicitud retornó un código de estado distinto de 2xx!")
                        return
                    }
                    
                    
                    return
                }
                
                
                if JSONSerialization.isValidJSONObject(data) {
                    var parsedResult: AnyObject!
                    
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                    } catch {
                        let userInfo:[String:String] = [NSLocalizedDescriptionKey : "Ups, No pudimos leer la información obtenida desde el servidor. Favor intente nuevamente. Si el problema persiste, contactar a soporte."]
                        let err = NSError(domain: "parseJSONWithCompletionHandler", code: 3, userInfo: userInfo)
                        completion(nil, err as Error)
                        return
                    }
                    
                    completion(parsedResult, nil)
                }else{
                    print("error al parsear info obtenida.")
                    let userInfo:[String:String] = [NSLocalizedDescriptionKey : "Ups, No pudimos leer la información obtenida desde el servidor. Favor intente nuevamente. Si el problema persiste, contactar a soporte."]
                    let err = NSError(domain: "parseJSONWithCompletionHandler", code: 3, userInfo: userInfo)
                    completion(nil, err as Error)
                }
                
                
                
                return
            }
        }
        
        task.resume()

    }

}

