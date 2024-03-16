//
//  ContentView.swift
//  WeSplit
//
//  Created by William Koonz on 3/16/24.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0
    @State private var tipPercentage = 20
    
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var totalAmount: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let totalAmount = checkAmount + tipValue
        return totalAmount
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($amountIsFocused)
                    }
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section("How much tip do you want to leave?") {
                    
                    NavigationLink {
                        TipPercentageView(tipPercentage: $tipPercentage)
                    } label: {
                        Text("Tip percentage")
                        Spacer()
                        Text("\(tipPercentage)%")
                    }
                }
                
                Section("Total Amount") {
                    Text(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                
                Section("Amount per person") {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}


struct TipPercentageView: View {
    @Binding var tipPercentage: Int
    
    var body: some View {
        Form {
            Section("Tip Percentage") {
                Picker("Tip percentage", selection: $tipPercentage) {
                    ForEach(0..<101) {
                        Text("\($0)%")
                    }
                }
                .pickerStyle(.wheel)
            }
        }
        .navigationTitle("Tip Percentage")
    }
}

#Preview {
    ContentView()
}

/*
- Once the keyboard appears for the check amount entry, it never goes away
 This is a problem with the decimal and number keypads, because the regular alphabetic keyboard has a return key on there to dismiss the keyboard. However, with a little extra work we can fix this:
 1. We need to give SwiftUI some way of determining whether the check amount box should currently have focus - should be receiving text input from the user
 2. We need to add some kind of button to remove that focus when the user wants, which will in turn cause the keyboard to go away
 
 - @FocusState: Similar to @State, except it's specifically designed to handle input focus in our UI
 
 @FocusState private var amountIsFocused: Bool
 
 Now you can attach that to your text field, so that when the text field is focused amountIsFocused is true, otherwise its false. Add this modifier to your TextField:
 .focused($amountIsFocused)
 
 .toolbar {
     if amountIsFocused {
         Button("Done") {
             amountIsFocused = false
         }
     }
 }
 
 1. The .toolbar() modifier lets you specify toolbar items for a view. These toolbar items might appear in various places on the screen - in the navigation bar at the top, in a special toolbar area at the bottom and so on
 2. The condition checks whether amountIsFocused is currently true, so we only show the button when the text field is active
 3. The Button view we're using here displays some tappable text, which in our case is "Done". We also need to provide it with some code to run when the button is pressed, which in our case sets amounIsFocused to false so that the keyboard is dismissed
 */
