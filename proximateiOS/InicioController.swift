//
//  InicioController.swift
//  proximateiOS
//
//  Created by Daniel Cedeño García on 11/15/17.
//  Copyright © 2017 Proximate. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Photos
import CoreLocation

class InicioController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate {

    var imagePicker: UIImagePickerController!
    
    var auxFoto: UIImageView! = UIImageView()
    
    var textoUbicacion:UIButton = UIButton()
    
    var locationManager = CLLocationManager()
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        let botonFoto:UIButton = UIButton()
        
        
        
        botonFoto.titleLabel!.font = botonFoto.titleLabel!.font.withSize(CGFloat(15))
        
        
        botonFoto.setAttributedTitle(nil, for: UIControlState())
        botonFoto.setTitle("Tomar Foto", for: UIControlState())
        botonFoto.tag = 0
        
        botonFoto.isSelected = false
        botonFoto.setTitleColor(UIColor(rgba: "#FFFFFF"), for: UIControlState())
        
        
        
        botonFoto.titleLabel!.textColor = UIColor(rgba: "#FFFFFF")
        botonFoto.titleLabel!.numberOfLines = 0
        botonFoto.titleLabel!.textAlignment = .center
        
        botonFoto.backgroundColor = UIColor(rgba:"#∫000000")
        
        botonFoto.sizeToFit()
        
        botonFoto.frame = CGRect(x: 0, y: self.view.frame.height * 0.1, width: self.view.frame.width, height: 50)
        
        
        
        botonFoto.contentHorizontalAlignment = .center
        botonFoto.contentVerticalAlignment = .center
        
        
        
        botonFoto.addTarget(self, action:#selector(InicioController.tomarFoto), for:.touchDown)
        
        self.view.addSubview(botonFoto)
        
        auxFoto.frame = CGRect(x: 0, y: botonFoto.frame.origin.y + botonFoto.frame.height * 1.1, width: self.view.frame.width, height: self.view.frame.height * 0.5)
        
        self.view.addSubview(auxFoto)
        
        
        
        textoUbicacion.titleLabel!.font = textoUbicacion.titleLabel!.font.withSize(CGFloat(15))
        
        
        textoUbicacion.setAttributedTitle(nil, for: UIControlState())
        
        textoUbicacion.tag = 0
        
        textoUbicacion.isSelected = false
        textoUbicacion.setTitleColor(UIColor(rgba: "#FFFFFF"), for: UIControlState())
        
        
        
        textoUbicacion.titleLabel!.textColor = UIColor(rgba: "#FFFFFF")
        textoUbicacion.titleLabel!.numberOfLines = 0
        textoUbicacion.titleLabel!.textAlignment = .center
        
        textoUbicacion.backgroundColor = UIColor(rgba:"#∫000000")
        
        textoUbicacion.sizeToFit()
        
        textoUbicacion.frame = CGRect(x: 0, y: auxFoto.frame.origin.y + auxFoto.frame.height * 1.01, width: self.view.frame.width, height: 50)
        
        
        
        textoUbicacion.contentHorizontalAlignment = .center
        textoUbicacion.contentVerticalAlignment = .center
        
        self.view.addSubview(textoUbicacion)
        
        
        let botonCerrarSesion:UIButton = UIButton()
        
        
        
        botonCerrarSesion.titleLabel!.font = botonCerrarSesion.titleLabel!.font.withSize(CGFloat(15))
        
        
        botonCerrarSesion.setAttributedTitle(nil, for: UIControlState())
        botonCerrarSesion.setTitle("Cerrar Sesión", for: UIControlState())
        botonCerrarSesion.tag = 0
        
        botonCerrarSesion.isSelected = false
        botonCerrarSesion.setTitleColor(UIColor(rgba: "#FFFFFF"), for: UIControlState())
        
        
        
        botonCerrarSesion.titleLabel!.textColor = UIColor(rgba: "#FFFFFF")
        botonCerrarSesion.titleLabel!.numberOfLines = 0
        botonCerrarSesion.titleLabel!.textAlignment = .center
        
        botonCerrarSesion.backgroundColor = UIColor(rgba:"#∫000000")
        
        botonCerrarSesion.sizeToFit()
        
        botonCerrarSesion.frame = CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 50)
        
        
        
        botonCerrarSesion.contentHorizontalAlignment = .center
        botonCerrarSesion.contentVerticalAlignment = .center
        
        
        
        botonCerrarSesion.addTarget(self, action:#selector(InicioController.cerrarSesion), for:.touchDown)
        
        self.view.addSubview(botonCerrarSesion)
        
        
            
        
    }
    
    //MARK: - Cerrar Sesion
    
    @objc func cerrarSesion(){
        
        defaults.removeObject(forKey: "sesion")
        
        self.dismiss(animated: true, completion: nil)
    
        
    }
    
    //MARK: - La Parte de la Foto
    
    func pedirPermisosFotos() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
        //handle authorized status
            print("Todo bien")
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        
        case .notDetermined, .denied, .restricted:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                print("Todo bien")
                self.imagePicker =  UIImagePickerController()
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
                case .denied, .restricted:
                print("Dijeron no")
                
                case .notDetermined:
                    print("algo paso")
                }
            }
        }
    }
    
    @objc func tomarFoto(){
        
        defaults.set(1, forKey: "foto")
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                
                
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                pedirPermisosFotos()
            }
        } else {
            print("Location services are not enabled")
        }
        
        
        
        
        
    }
    
    
    
    func save() {
        UIImageWriteToSavedPhotosAlbum(auxFoto.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        defaults.removeObject(forKey: "foto")
        
        let ubicacion = obtener_ubicacion()
        
        textoUbicacion.setTitle("\(ubicacion.coordinate.latitude),\(ubicacion.coordinate.longitude)", for: .normal)
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            
            let ac = UIAlertController(title: "Problema al salvar", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Salvada!", message: "Foto Guardada", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    //MARK: - Done image capture here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        auxFoto.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        save()
    }
    
    
    //MARK: - Delegados
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    
                    if self.defaults.object(forKey: "foto") !=  nil {
                        
                        self.pedirPermisosFotos()
                        
                    }
                    
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
