//
//  HideKeyboardExtension.swift
//  TodoSample
//
//  Created by kuehar on 2021/06/13.
//

import SwiftUI

#if canImport(UIKit)
extension View{
    func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),to:nil,from: nil, for: nil)
    }
}

#endif
