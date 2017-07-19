//
//  InternalFileManager.swift
//  WidgetApp
//
//  Created by VCS on 7/19/17.
//  Copyright © 2017 Nemetschek. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//TODO if some 1 deletes the images

class InternalFileManager {
    static var imageList: [NSManagedObject] = []
    
    public static func requestImage(_ imageName:String){
        if isPresentOnDevice(imageName) {
            print("PRESENT")
        } else {
            print("NOT PRESENT")
            // download image
        }
    }
    
    public static func saveImage(_ image:UIImage) {
        saveToDataBase()
        saveToInternalStorage(image)
    }
    
    public static func isPresentOnDevice(_ imageName:(String)) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("AppDelegate not found")
            return false
        }
        var itemsFound: [NSManagedObject] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Image")
        fetchRequest.predicate = NSPredicate(format: "imageName == %@", imageName)
        
        do {
            itemsFound = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not read image data" + error.description)
            return false
        }
        
        if(itemsFound.isEmpty){
            return false
        } else {
            return true
        }
    }
    
    private static func saveToInternalStorage(_ image:UIImage) {
        let pngImageData = UIImagePNGRepresentation(image)
        
        do {
            try pngImageData?.write(to: getDocumentsDirectory(), options: .atomic)
             print("Write done")
        } catch let error as NSError {
            print("Write error" + error.description)
        }
    }
    
    private static func saveToDataBase(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName:"Image", in: managedContext)
        let image = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        image.setValue("asd", forKeyPath:"imageName");
        
        do {
            try managedContext.save()
            imageList.append(image)
        } catch let error as NSError {
            print("Could not save image" + error.description)
        }
    }
    
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
