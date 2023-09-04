//
//  ContentView.swift
//  StressDectect
//
//  Created by Transirizo on 2023/5/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            BackGroundView(topColor: .blue, bottomColor: .white)

            VStack(spacing: 10) {
                Text("Cupertino, CA")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
                    .padding()
                VStack {
                    Image(systemName: "cloud.sun.fill")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 180)
                    Text("30°")
                        .font(.system(size: 70, weight: .medium))
                        .foregroundColor(.white)
                }
                HStack {
                    WeatherView(weatherImage: "cloud.sun.fill", dayOfWeek: "MON", temperture: 28)
                    WeatherView(weatherImage: "cloud.sun.fill", dayOfWeek: "TUE", temperture: 28)
                    WeatherView(weatherImage: "cloud.sun.fill", dayOfWeek: "WED", temperture: 28)
                    WeatherView(weatherImage: "cloud.sun.fill", dayOfWeek: "THU", temperture: 30)
                    WeatherView(weatherImage: "cloud.sun.fill", dayOfWeek: "FRI", temperture: 31)
                    WeatherView(weatherImage: "cloud.sun.fill", dayOfWeek: "SAT", temperture: 32)
                    WeatherView(weatherImage: "cloud.sun.fill", dayOfWeek: "SUN", temperture: 33)
                }

                Spacer()

                Button {} label: {
                    Text("Change Day Time")
                        .frame(width: 280, height: 50)
                        .background(Color.white)
                        .font(.system(size: 20, weight: .bold))
                        .cornerRadius(15)
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WeatherView: View {
    var weatherImage: String
    var dayOfWeek: String
    var temperture: Int
    var body: some View {
        VStack(alignment: .center) {
            Text(dayOfWeek)
                .font(.system(size: 16))
                .foregroundColor(.white)

            Image(systemName: weatherImage)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(temperture)°")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct BackGroundView: View {
    var topColor: Color
    var bottomColor: Color
    var body: some View {
        LinearGradient(colors: [topColor, bottomColor], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
    }
}
