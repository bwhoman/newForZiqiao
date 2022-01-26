//
//  IntentHandler.swift
//  AquaSiriIntents
//
//  Created by Benjamin Who on 1/17/22.
//

import Intents
import CoreData

class IntentHandler: INExtension, LogDrinkIntentHandling {
    func resolveQuantity(for intent: LogDrinkIntent, with completion: @escaping (LogDrinkQuantityResolutionResult) -> Void) {
        let result: LogDrinkQuantityResolutionResult
        if let quantity = intent.quantity {
            result = LogDrinkQuantityResolutionResult.success(with: Int(truncating: quantity))
        } else {
            result = LogDrinkQuantityResolutionResult.needsValue()
        }
        completion(result)
    }
    
    public func handle(intent: LogDrinkIntent, completion: @escaping (LogDrinkIntentResponse) -> Swift.Void) {
        let context = PersistenceController.shared.container.viewContext
        let newDrink = WaterIntakeEvent(context: context)
        newDrink.drinkType = intent.drinkType
        newDrink.quantity = intent.quantity as! Float
        newDrink.waterQuantity = intent.quantity as! Float
        newDrink.timeOfConsumption = Date()
        newDrink.id = UUID()
        do {
            try context.save()
            let response = LogDrinkIntentResponse(code: LogDrinkIntentResponseCode.success, userActivity: nil)
            completion(response)
            print("Successfully saved.")
        } catch {
            completion(LogDrinkIntentResponse(code: LogDrinkIntentResponseCode.failure, userActivity: nil))
            print("Error saving.")
        }
    }
    
    public func resolveDrinkType(for intent: LogDrinkIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        let result: INStringResolutionResult
        if let drinkType = intent.drinkType, drinkType.count > 0 {
            result = INStringResolutionResult.success(with: drinkType)
        } else {
            result = INStringResolutionResult.needsValue()
        }
        completion(result)
    }
    

    
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
