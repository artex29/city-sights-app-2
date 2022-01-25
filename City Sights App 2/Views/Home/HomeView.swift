//
//  HomeView.swift
//  City Sights App 2
//
//  Created by ANGEL RAMIREZ on 1/23/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var isMapShowing = false
    var body: some View {
        
        if model.restaurants.count != 0 || model.sights.count != 0 {
            
            // Determine if we show list or map
            // El simbolo "!" al lado de isMapShowing nos pregunta si es false. Es lo mismo que decir if isMapShowing = false {}
            
            NavigationView{
                
                if !isMapShowing  {
                    VStack(alignment: .leading){
                        HStack{
                           Image(systemName: "location")
                            Text("Maracaibo")
                            Spacer()
                            
                            Button("Switch to map") {
                                self.isMapShowing = true
                            }
                        }
                        
                        Divider()
                        
                        BusinessList()
                    }
                    .padding([.horizontal, .top])
                    .navigationBarHidden(true)
                    
                }
                else {
                    //Show map
                    BusinessMap()
                        .ignoresSafeArea()
                    
                    
                    
                    
                }
                
                
            }
            
    
            
            
        }
        else {
            // Still waiting for data so show spinner
            ProgressView()
        }
       
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
