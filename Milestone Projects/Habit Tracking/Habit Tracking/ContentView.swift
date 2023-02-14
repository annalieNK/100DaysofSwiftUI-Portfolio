//
//  ContentView.swift
//  Habit Tracking
//
//  Created by Annalie Kruseman on 10/5/22.
//

import SwiftUI

//struct ContentView: View {
//    @StateObject var habits = Activities()
//    @State private var showingActivity = false
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(habits.activities, id: \.id) { activity in
//                    NavigationLink {
//                        DetailView()
//                    } label: {
//                        Text(activity.title)
//                    }
//                }
//                //                .onDelete(perform: removeItems)
//                .navigationTitle("Habit Tracking")
//                .toolbar {
//                    Button {
//                        //   let habit = Activity(title: "Test")
//                        //   habits.activities.append(habit)
//                        showingActivity = true
//                    } label: {
//                        Image(systemName: "plus")
//                    }
//                }
//                .sheet(isPresented: $showingActivity) {
//                    AddActivityView(habits: habits)
//                }
//            }
//        }
//    }
//
//    //    func removeItems(at offsets: IndexSet) {
//    //        habits.activities.remove(atOffsets: offsets)
//    //    }
//}

struct ContentView: View {
    @StateObject var habits = Activities()
    @State private var showingActivity = false
    
//    let deleteItems: (IndexSet) -> Void
    
    var body: some View {
        NavigationView {
            //List(habits.activities) { activity in
            List {
                ForEach(habits.activities, id: \.id) { activity in
                    NavigationLink {
                        DetailView(habits: habits, activity: activity)
                    } label: {
                        HStack {
                            Text(activity.title)
                            Text(activity.description)
                            Spacer()
                            Text(String(activity.completionCount))
                                .font(.caption.weight(.black))
                                .padding(5)
                                .frame(minWidth: 50)
                                .background(color(for: activity))
                                .clipShape(Capsule())
                        }
                    }
                }
//                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Habit Tracking")
            .toolbar {
                Button {
                    showingActivity.toggle()
                } label: {
                    Label("Add new activity", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingActivity) {
            AddActivityView(habits: habits)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() //deleteItems: { _ in }
    }
}
