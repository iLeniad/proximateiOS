//
//  ViewController.swift
//  proximateiOS
//
//  Created by Daniel Cedeño García on 11/15/17.
//  Copyright © 2017 Proximate. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class ViewController: UIViewController,UITextFieldDelegate,URLSessionDelegate,URLSessionTaskDelegate {
    
    var usuario:UITextField! = UITextField()
    var contrasena:UITextField! = UITextField()
    
    var defaults = UserDefaults.standard
    
    var db:DB_Manager = DB_Manager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        defaults.set("proximate.sqlite", forKey: "base")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if defaults.object(forKey: "sesion") != nil {
            
            self.performSegue(withIdentifier: "logintoinicio", sender: self)
            
        }
        
        else {
        crear_login()
        }
    }
    
    func crear_login(){
        
        let subvistas = self.view.subviews
        
        for subvista in subvistas {
            
            subvista.removeFromSuperview()
            
        }
        
        var offset:CGFloat = self.view.frame.height/2 - self.view.frame.height/4
        
        
        
        
        let usuarioLabel:UILabel = UILabel()
        let contrasenaLabel:UILabel = UILabel()
        
        
        
        
        
        usuarioLabel.text = "Usuario"
        
        
        usuarioLabel.font = usuarioLabel.font.withSize(CGFloat(15))
        
        usuarioLabel.frame = CGRect(x: self.view.frame.width/2 - 150, y: offset, width: 100, height: 30)
        
        usuario.frame = CGRect(x: self.view.frame.width/2 - 50, y: offset, width: self.view.frame.width/2, height: 30)
        
        usuario.borderStyle = .roundedRect
        
        usuario.keyboardAppearance = .dark
        
        usuario.autocorrectionType = .no
        
        usuario.returnKeyType = .done
        
        usuario.autocapitalizationType = .none
        
        usuario.delegate = self
        
        usuario.text = ""
        
        
        usuario.font = usuario.font?.withSize(CGFloat(15))
        
        
        
        offset += 50
        
        contrasenaLabel.text = "Contrasena"
        
        
        contrasenaLabel.font = contrasenaLabel.font.withSize(CGFloat(15))
        
        
        contrasenaLabel.frame = CGRect(x: self.view.frame.width/2 - 150, y: offset, width: 100, height: 30)
        
        contrasena.frame = CGRect(x: self.view.frame.width/2 - 50, y: offset, width: self.view.frame.width/2, height: 30)
        
        contrasena.borderStyle = .roundedRect
        
        contrasena.keyboardAppearance = .dark
        
        contrasena.isSecureTextEntry = true
        
        contrasena.returnKeyType = .done
        
        contrasena.delegate = self
        
        contrasena.text = ""
        
        usuario.text = "prueba@proximateapps.com"
        contrasena.text = "12digo16digo18#$"
        
        contrasena.font = contrasena.font?.withSize(CGFloat(15))
        
        offset += 50
        
        
        let botonEntrar:UIButton = UIButton()
        
        
        
        botonEntrar.titleLabel!.font = botonEntrar.titleLabel!.font.withSize(CGFloat(15))
        
        
        botonEntrar.setAttributedTitle(nil, for: UIControlState())
        botonEntrar.setTitle("ENTRAR", for: UIControlState())
        botonEntrar.tag = 0
        
        botonEntrar.isSelected = false
        botonEntrar.setTitleColor(UIColor(rgba: "#FFFFFF"), for: UIControlState())
        
        
        
        botonEntrar.titleLabel!.textColor = UIColor(rgba: "#FFFFFF")
        botonEntrar.titleLabel!.numberOfLines = 0
        botonEntrar.titleLabel!.textAlignment = .center
        
        botonEntrar.backgroundColor = UIColor(rgba:"#∫000000")
        
        botonEntrar.sizeToFit()
        
        botonEntrar.frame = CGRect(x: 0, y: offset, width: self.view.frame.width, height: 50)
        
        
        
        botonEntrar.contentHorizontalAlignment = .center
        botonEntrar.contentVerticalAlignment = .center
        
        
        
        botonEntrar.addTarget(self, action:#selector(ViewController.iniciar_sesion), for:.touchDown)
        
        offset += 70
        
        
        
        
        self.view.addSubview(usuarioLabel)
        self.view.addSubview(contrasenaLabel)
        self.view.addSubview(usuario)
        self.view.addSubview(contrasena)
        self.view.addSubview(botonEntrar)
        
        
        print("pantala login creada")
        
    }
    
    // MARK: Delegados
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        
        return true
    }
    
    @objc func iniciar_sesion(){
        
        
        guard Reachability.isConnectedToNetwork() else {
            
            
            //actualizar texto cargador
            
            let controladorActual = UIApplication.topViewController()
            
            DispatchQueue.main.async {
                
                self.mostrarCargador()
                
                let subvistas = controladorActual?.view!.subviews
                
                for subvista in subvistas! where subvista.tag == 179 {
                    
                    let subvistasCargador = subvista.subviews
                    
                    for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                        
                        (subvistaCargador as! UIButton).setTitle("Necesitas tener una conexión a internet", for: .normal)
                        
                    }
                    
                    let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                    singleTap.cancelsTouchesInView = false
                    singleTap.numberOfTapsRequired = 1
                    subvista.addGestureRecognizer(singleTap)
                    
                }
                
            }
            
            //fin actualizar texto cargador
            
         return
        }
        
        
        //actualizar texto cargador
        
        let controladorActual = UIApplication.topViewController()
        
        DispatchQueue.main.async {
            
            self.mostrarCargador()
            
            let subvistas = controladorActual?.view!.subviews
            
            for subvista in subvistas! where subvista.tag == 179 {
                
                let subvistasCargador = subvista.subviews
                
                for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                    
                    (subvistaCargador as! UIButton).setTitle("Iniciando Sesión...", for: .normal)
                    
                }
                
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                singleTap.cancelsTouchesInView = false
                singleTap.numberOfTapsRequired = 1
                subvista.addGestureRecognizer(singleTap)
                
            }
            
        }
        
        //fin actualizar texto cargador
        
        
        let ligaLogin: String = "https://serveless.proximateapps-services.com.mx/catalog/dev/webadmin/authentication/login"
        guard let url = URL(string: ligaLogin) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        
        let configuracion:URLSessionConfiguration = URLSessionConfiguration.ephemeral
        
        let sesion = URLSession(configuration: configuracion, delegate: self, delegateQueue: nil)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        
        let preParametros = "{\"correo\":\"\(self.usuario.text!)\",\"contrasenia\":\"\(contrasena.text!)\"}"
        
        urlRequest.httpBody = preParametros.data(using: .utf8)
        
        //print(urlRequest)
        
        let tarea = sesion.dataTask(with: urlRequest) {
            (data, response, error) in
            // Errores
            guard error == nil else {
                print(" Error en la petición del servicio policy")
                print(error!)
                return
            }
            //Hay data
            guard let responseData = data else {
                print("Error: servicio viene vacio")
                return
            }
            //checar si es diccionario o arreglo
            //print(data as Any)
            //print("la respuesta es")
            let realResponse = response as! HTTPURLResponse
            //print(realResponse)
            switch realResponse.statusCode {
                
            case 200:
                
                print("estatus 200")
                
                do {
                
                guard let datos = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: AnyObject] else {
                        print("No es diccionario")
                        
                        
                        return
                }
                
                //print("es diccionario")
                
                //print(datos.description)
                
                let base = self.defaults.object(forKey: "base") as! String
                    
                self.db.open_database(base)
                    
                let sql = "delete from login"
                    
                _ = self.db.execute_query(sql)
                    
                let resultado = self.db.insert_bulk("login", datos: [datos])
                    
                //print(resultado)
                    
                    if resultado.0 {
                        
                        self.irPorPerfil()
                        
                    }
                
                }catch  {
                    print("error al parsear el json")
                    return
                }
                
                
            case 401:
                
                print("Credenciales incorrectas")
                
            
                
            default:
                print("Estatus http no manejado \(realResponse.statusCode)")
                
                
               
                
                
            }
            
            
        }
        tarea.resume()
        
        
    }
    
    func irPorPerfil(){
        
        
        //actualizar texto cargador
        
        let controladorActual = UIApplication.topViewController()
        
        DispatchQueue.main.async {
            
           
            
            let subvistas = controladorActual?.view!.subviews
            
            for subvista in subvistas! where subvista.tag == 179 {
                
                let subvistasCargador = subvista.subviews
                
                for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                    
                    subvistaCargador.removeFromSuperview()
                    
                }
                
                let sql = "select * from login"
                
                let resultadoLogin = self.db.select_query_columns(sql)
                
                let auxTexto = "success: \(resultadoLogin[0]["success"]!)\nerror: \(resultadoLogin[0]["error"]!)\nmessage: \(resultadoLogin[0]["message"]!) \ntoken: e\(resultadoLogin[0]["token"]!)\nid: \(resultadoLogin[0]["id"]!)"
                
                let textoCargador:UITextView = UITextView()
                
                textoCargador.frame = CGRect(x: 0, y: subvista.frame.height*0.70, width: subvista.frame.width, height: subvista.frame.height*0.5)
                
                let auxColor:UIColor = UIColor(rgba: "#000000")
                
                textoCargador.text = auxTexto
                textoCargador.textColor =  auxColor
                
                textoCargador.textAlignment = .left
                
                subvista.addSubview(textoCargador)
                
                
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                singleTap.cancelsTouchesInView = false
                singleTap.numberOfTapsRequired = 1
                subvista.addGestureRecognizer(singleTap)
                
            }
            
        }
        
        //fin actualizar texto cargador
        
        
        let ligaLogin: String = "https://serveless.proximateapps-services.com.mx/catalog/dev/webadmin/users/getdatausersession"
        guard let url = URL(string: ligaLogin) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        
        let configuracion:URLSessionConfiguration = URLSessionConfiguration.ephemeral
        
        let sesion = URLSession(configuration: configuracion, delegate: self, delegateQueue: nil)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let sql = "select * from login"
        
        let resultadoLogin = self.db.select_query_columns_string(sql)
        
        var token = ""
        
        for renglon in resultadoLogin {
            
            token = renglon["token"]!
        }
        
        //print(token)
        
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        
        
        //print(urlRequest)
        
        let tarea = sesion.dataTask(with: urlRequest) {
            (data, response, error) in
            // Errores
            guard error == nil else {
                print(" Error en la petición del servicio policy")
                print(error!)
                return
            }
            //Hay data
            guard let responseData = data else {
                print("Error: servicio viene vacio")
                return
            }
            //checar si es diccionario o arreglo
            //print(data as Any)
            //print("la respuesta es")
            let realResponse = response as! HTTPURLResponse
            //print(realResponse)
            switch realResponse.statusCode {
                
            case 200:
                
                print("estatus 200")
                
                do {
                    
                    guard let datos = try JSONSerialization.jsonObject(with: responseData, options: [])
                        as? [String: AnyObject] else {
                            print("No es diccionario")
                            
                            
                            
                            
                            return
                    }
                    
                    //print("es diccionario")
                    
                    //print(datos.description)
                    
                    //print(datos.description)
                    
                    let auxData = datos["data"] as! [[String:AnyObject]]
                    
                    var sql = "delete from perfil"
                    
                    _ = self.db.execute_query(sql)
                    
                    let resultadoPerfil = self.db.insert_bulk("perfil", datos: auxData)
                    
                    //print(resultadoPerfil)
                    
                    
                    
                    let secciones = auxData[0]["secciones"] as! [[String:AnyObject]]
                    
                    //print(secciones)
                    
                    sql = "delete from secciones"
                    
                    _ = self.db.execute_query(sql)
                    
                    let resultadoSecciones = self.db.insert_bulk("secciones", datos: secciones)
                    
                    //print(resultadoSecciones)
                    
                    if resultadoPerfil.0 && resultadoSecciones.0 {
                       
                        let base = self.defaults.object(forKey: "base") as! String
                        
                        self.db.close_database(base)
                       
                        let alertController = UIAlertController(title: "Hola", message: "Perfil descargado correctamente, oprima ok para continuar", preferredStyle: .alert)
                        
                        
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("click ok")
                            
                            self.defaults.set(1, forKey: "sesion")
                            
                            self.performSegue(withIdentifier: "logintoinicio", sender: self)
                            
                            
                        }
                        
                        
                        alertController.addAction(okAction)
                        
                        
                        
                        // Present the controller
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                    }
                    
                }catch  {
                    print("error al parsear el json")
                    return
                }
                
                
            case 401:
                
                print("Credenciales incorrectas")
                
                
                
            default:
                print("Estatus http no manejado \(realResponse.statusCode)")
                
                
                
                
                
            }
            
            
        }
        tarea.resume()
        
        
        
        
    }
    
    // MARK: - Funciones Cargador
    
    
    func mostrarCargador(){
        
        let controladorActual = UIApplication.topViewController()
        
        //print(controladorActual as Any)
        
        let vistaCargador:UIScrollView = UIScrollView()
        
        let subvistas = vistaCargador.subviews
        
        for subvista in subvistas {
            
            subvista.removeFromSuperview()
            
        }
        
        vistaCargador.tag = 179
        
        vistaCargador.frame = (controladorActual?.view!.frame)!
        
        vistaCargador.backgroundColor = UIColor.white
        
        let auxColor:UIColor = UIColor(rgba: "#000000")
        
        let vistaLoading = NVActivityIndicatorView(frame: CGRect(x: vistaCargador.frame.width/4, y: vistaCargador.frame.height/4, width: vistaCargador.frame.width/2, height: vistaCargador.frame.height/2),color:auxColor)
        
        vistaLoading.type = .pacman
        
        vistaCargador.addSubview(vistaLoading)
        
        controladorActual?.view!.addSubview(vistaCargador)
        
        vistaLoading.startAnimating()
        
        let textoCargador:UIButton = UIButton()
        
        textoCargador.frame = CGRect(x: 0, y: vistaCargador.frame.height*0.70, width: vistaCargador.frame.width, height: vistaCargador.frame.height*0.1)
        
        textoCargador.setTitle("Contactando al servidor...", for: .normal)
        textoCargador.setTitleColor(auxColor, for: .normal)
        
        textoCargador.setAttributedTitle(nil, for: UIControlState())
        
        //textoCargador.titleLabel!.font = UIFont(name: fontFamilia, size: CGFloat(3))
        
        textoCargador.titleLabel!.font = textoCargador.titleLabel!.font.withSize(CGFloat(20))
        
        
        textoCargador.isSelected = false
        
        //textoCargador.backgroundColor = auxColor
        
        
        textoCargador.titleLabel!.textColor = auxColor
        textoCargador.titleLabel!.numberOfLines = 0
        textoCargador.titleLabel!.textAlignment = .center
        
        vistaCargador.addSubview(textoCargador)
        
        
    }
    
    

    
    @objc func ocultarCargador(sender:UITapGestureRecognizer){
        
        let subvistas = sender.view!.superview!.subviews
        
        for subvista in subvistas where subvista.tag == 179 {
            
            DispatchQueue.main.async {
                
                subvista.removeFromSuperview()
                
            }
            
        }
        
        
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("tenemos challege")
        
        guard challenge.previousFailureCount == 0 else {
            challenge.sender?.cancel(challenge)
            // Inform the user that the user name and password are incorrect
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        let usuario = self.usuario.text!
        let contrasena = self.contrasena.text!
        
        defaults.set(usuario, forKey: "ultimoUsuario")
        defaults.set(contrasena, forKey: "ultimaContrasena")
        
        let proposedCredential = URLCredential(user: usuario, password: contrasena, persistence: .none)
        completionHandler(.useCredential, proposedCredential)
    }
    
    
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
        
        print("tenemos challege task")
        
        
        if challenge.previousFailureCount > 0 {
            
            print("Credenciales incorrectas")
            
            //actualizar texto cargador
            
            let controladorActual = UIApplication.topViewController()
            
            DispatchQueue.main.async {
                
                let subvistas = controladorActual?.view!.subviews
                
                for subvista in subvistas! where subvista.tag == 179 {
                    
                    let subvistasCargador = subvista.subviews
                    
                    for subvistaCargador in subvistasCargador where subvistaCargador is UIButton {
                        
                        (subvistaCargador as! UIButton).setTitle("Credenciales incorrectas. Toque para volver intentar", for: .normal)
                        
                    }
                    
                    
                    let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.ocultarCargador(sender:)))
                    singleTap.cancelsTouchesInView = false
                    singleTap.numberOfTapsRequired = 1
                    subvista.addGestureRecognizer(singleTap)
                    
                    
                }
                
            }
            
            //fin actualizar texto cargador
            
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        } else {
            
            let usuario = self.usuario.text!
            let contrasena = self.contrasena.text!
            
            defaults.set(usuario, forKey: "ultimoUsuario")
            defaults.set(contrasena, forKey: "ultimaContrasena")
            
            
            
            let credential = URLCredential(user:usuario, password:contrasena, persistence: .none)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential,credential)
        }
        
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

