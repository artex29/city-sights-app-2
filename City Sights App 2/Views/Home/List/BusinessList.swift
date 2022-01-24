//
//  BusinessList.swift
//  City Sights App 2
//
//  Created by ANGEL RAMIREZ on 1/23/22.
//

import SwiftUI

struct BusinessList: View {
    
    @EnvironmentObject var model:ContentModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]){
                
                BusinessSection(title: "Restaurants", businesses: model.restaurants)
       
                BusinessSection(title: "Sights", businesses: model.sights)
                
            }
        }
        }
    }

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessList()
    }
}
