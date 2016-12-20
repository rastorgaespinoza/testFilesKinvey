//
//  CommonHelpers.swift
//  buohIpad
//
//  Created by hugo roman on 12/6/15.
//  Copyright © 2015 hugo roman. All rights reserved.
//

import Foundation
import UIKit

class CommonHelpers : NSObject {
    
    override init() {
        super.init()
    }
    
    // MARK: Helpers
    
//    class func presentOneAlertController(view: UIViewController, alertTitle: String, alertMessage: String, myActionTitle: String, myActionStyle: UIAlertActionStyle)-> Void{
//        
//        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
//        
//        alertController.addAction(UIAlertAction(title: myActionTitle, style: myActionStyle, handler: nil));
//        view.presentViewController(alertController, animated: true, completion: nil)
//    }
    
    /** Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "\(key)") != nil {
            return method.replacingOccurrences(of: "\(key)", with: value)
        } else {
            return nil
        }
    }
    
    /** Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(_ data: Data, completionHandler: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo:[String:String] = [NSLocalizedDescriptionKey : "Ups, No pudimos leer la información obtenida desde el servidor. Favor intente nuevamente. Si el problema persiste, contactar a soporte."]
            completionHandler(nil, NSError(domain: "parseJSONWithCompletionHandler", code: 3, userInfo: userInfo))
            return
        }
        
        completionHandler(parsedResult, nil)
        return
    }
    

    
    /** Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(_ parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joined(separator: "&")
    }
    
    class func validateData(domain: String, data: Data?, response: URLResponse?, error: NSError?, completionForValidation: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void){
        
        func sendError(_ error: String) {

            let userInfo:[String:String] = [NSLocalizedDescriptionKey: error]
            completionForValidation(nil, NSError(domain: domain, code: 1, userInfo: userInfo) )
        }

        /* GUARD: Was there an error? */
        guard (error == nil) else {
            var message = ""
            switch error!.code {
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
                message = "Ocurrió un error durante su solicitud. Revise su conexión a internet.\nDescripción del problema: \(error!.localizedDescription)"
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
                        completionForValidation(nil, err )
                        return
                    }else{
                        let userInfo:[String:String] = [NSLocalizedDescriptionKey: descriptionError]
                        let err = NSError(domain: errorTitle, code: codeError!, userInfo: userInfo)
                        completionForValidation(nil, err)
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
        
        
        
        CommonHelpers.parseJSONWithCompletionHandler(data, completionHandler: completionForValidation )
        return
    }
}
