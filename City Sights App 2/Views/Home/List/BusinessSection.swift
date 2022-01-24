//
//  BusinessSection.swift
//  City Sights App 2
//
//  Created by ANGEL RAMIREZ on 1/23/22.
//

import SwiftUI

struct BusinessSection: View {
    var title:String
    var businesses: [Business]
    
    var body: some View {
       
        Section(header: BusinessSectionHeader(title: title)) {
            ForEach(businesses) { business in
                
                NavigationLink {
                    <#code#>
                } label: {
                    BusinessRow(business: business)
                }

                
                Divider()
            }
            
        }
    }
}

