//
//  ContentView.swift
//  Converter
//
//  Created by Наташа Яковчук on 10.12.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm = ViewModel()
    
    var body: some View {
        ZStack {
            Color(.teal.opacity(0.6))
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                    .frame(height: 190)
                
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundStyle(.white)
                        .padding(.bottom, -50)
                    
                    VStack {
                        HStack {
                            Image(systemName: "star")
                                .foregroundStyle(.yellow)
                            
                            Picker("", selection: $vm.favPick) {
                                //                поява кнопки дьоргає все вью
                                //                не зберігаються юзер дефолтс
                                ForEach(vm.listFavourite, id: \.self) {i in
                                    Text(i).tag(i)
                                }
                            }.padding(5)
                                .frame(height: 35)
                                .tint(.teal)
                                .background(RoundedRectangle(cornerRadius: 25)
                                    .foregroundColor(.white)
                                    .shadow(radius: 2))
                                .opacity(vm.listFavourite.isEmpty ? 0: 1)
                                .animation(.easeInOut, value: vm.listFavourite)
                        }.padding(.trailing, 30)
                        
                        HStack(spacing: 0) {
                            Image(systemName: "arrow.turn.left.down")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                                .foregroundColor(.mint.opacity(0.4))
                                .padding(10)
                            
                            VStack {
                                HStack {
                                    TextField("00.00", text: $vm.value1)
                                        .valueView()
                                        .keyboardType(.numberPad)
                                    
                                    Menu {
                                        ForEach(vm.ratesDict.keys.sorted(), id: \.self) { i in
                                            Button(action: {
                                                vm.selestedCurrency1 = i
                                            }, label: {
                                                Text(i)
                                            })
                                        }
                                    } label: {
                                        Text(vm.selestedCurrency1)
                                            .currencyView()
                                    } .padding(5)
                                }
                                
                                HStack {
                                    Text(vm.value2)
                                        .foregroundColor(vm.isTextBlack ? .black : .gray.opacity(0.6) )
                                        .valueView()
                                    
                                    Menu {
                                        ForEach(vm.ratesDict.keys.sorted(), id: \.self) { i in
                                            Button(action: {
                                                vm.selestedCurrency2 = i
                                            }, label: {
                                                Text(i)
                                            })
                                        }
                                    } label: {
                                        Text(vm.selestedCurrency2)
                                            .currencyView()
                                    } .padding(5)
                                }
                            }.padding(5)
                            
                            Button {
                                vm.ReplaceSelested()
                            } label: {
                                Image(systemName: "arrow.up.arrow.down")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                                    .padding(10)
                                    .foregroundColor(.teal)
                                    .background(Circle()
                                        .foregroundColor(.white)
                                    ) .shadow(radius: 2)
                            }
                        } .padding(.vertical, 20)
                        
                        Button(action: {
                            vm.ButtonConvert()
                        }, label: {
                            Text("Convert")
                                .foregroundColor(.white)
                                .font(.title)
                                .bold()
                                .padding(20)
                                .background(.mint)
                                .cornerRadius(35)
                                .shadow(radius: 3)
                        })
                        
                        Button {
                            vm.addToFavourites()
                        } label: {
                            HStack {
                                Image(systemName: "star")
                                Text("Add pair to favourites")
                            } .foregroundColor(.white)
                                .padding(14)
                                .background(RoundedRectangle(cornerRadius: 25)
                                    .foregroundColor(.teal.opacity(0.9))
                                    .shadow(radius: 1)
                                )
                        }.padding(.vertical, 30)
                    }.padding(.top, 40)
                }
            }
            
        }.alert(isPresented: $vm.showAlert) {
            Alert(title: Text(vm.titleAlert),
                  message: Text(vm.textAlert))
        }
        .onTapGesture {
            vm.hideKeyboard()
        }
        .onAppear {
            vm.Start()
        }
    }
}
#Preview {
    ContentView()
}
