//
//  BusinessRow.swift
//  City Sights App 2
//
//  Created by ANGEL RAMIREZ on 1/23/22.
//

import SwiftUI

struct BusinessRow: View {
    
   @ObservedObject var business: Business
    var body: some View {
        
        
        VStack(alignment: .leading) {
            
            HStack {
                // Image
                
                let uiImage = UIImage(data: business.imageData ?? Data())
                Image(uiImage: uiImage ?? UIImage())
                    .resizable()
                    .frame(width: 58, height: 58)
                    .cornerRadius(5)
                    .scaledToFit()
                    
                
                
                // Name and distance
                VStack(alignment: .leading) {
                    Text(business.name ?? "")
                        .bold()
                    
                    Text(String (format: "%.1f miles away", (business.distance ?? 0) * 0.000621))
                        .font(.caption)
                    
                }
                Spacer()
                
                VStack (alignment: .leading) {
                    Image("regular_\(business.rating ?? 0.0)")
                    Text("\(business.reviewCount ?? 0) Reviews")
                        .font(.caption)
                    
                }
            }
            
            Divider()
        }
        .foregroundColor(.black)
       
    }
}


