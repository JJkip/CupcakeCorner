//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Joseph Langat on 03/07/2023.
//

import SwiftUI

struct CheckoutView: View {
    @ObservableObject var order: Order
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
