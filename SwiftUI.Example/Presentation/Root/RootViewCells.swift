//
//  RootViewCells.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import SwiftUI

struct WeatherCell: View {
    
    let value: ForecastResponse.Weather
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10.0)
            .fill(Color.white.opacity(0.1))
            .frame(height: .itemSideSize)
            .overlay {
                VStack(spacing: 2.0) {
                    URLImageView(id: value.icon)
                        .frame(width: 64.0, height: 64.0)
                    Text(value.main)
                        .font(.headline)
                    Text(value.description ?? "")
                        .font(.subheadline)
                }
            }
    }
    
}

struct MainCell: View {
    
    let value: ForecastResponse.Main
    
    var formatter: NumberFormatter = {
        let instance = NumberFormatter()
        instance.numberStyle = .decimal
        instance.maximumFractionDigits = 0
        return instance
    }()
    
    var mainText: String {
        return "\(formatter.string(from: NSNumber(value: value.temp)) ?? " - ")º"
    }

    var feelsLikeText: String {
        return "\(formatter.string(from: NSNumber(value: value.temp)) ?? " - ")º"
    }

    var body: some View {
        
        RoundedRectangle(cornerRadius: 10.0)
            .fill(Color.white.opacity(0.1))
            .frame(height: .itemSideSize)
            .overlay {
                VStack(spacing: 18.0) {
                    Image(systemName: "thermometer.variable")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32.0, height: 32.0)
                    VStack(spacing: 2.0) {
                        HStack(alignment: .bottom, spacing: 16.0) {
                            Text("average:")
                                .font(.footnote)
                                .foregroundStyle(.white.opacity(0.5))
                            Text(mainText)
                                .font(.headline)
                        }
                        HStack(alignment: .bottom, spacing: 16.0) {
                            Text("feels like:")
                                .font(.footnote)
                                .foregroundStyle(.white.opacity(0.5))
                            Text(feelsLikeText)
                                .font(.subheadline)
                        }
                    }
                }
            }
        
    }
}

struct WindCell: View {
    
    let value: ForecastResponse.Wind
    
    var formatter: NumberFormatter = {
        let instance = NumberFormatter()
        instance.numberStyle = .decimal
        instance.maximumFractionDigits = 0
        return instance
    }()
    
    var text: String {
        return "\(formatter.string(from: NSNumber(value: value.speed)) ?? " - ")m/s"
    }

    var subtitle: String {
        return "\(formatter.string(from: NSNumber(value: value.deg)) ?? " - ")º"
    }

    var body: some View {
        
        RoundedRectangle(cornerRadius: 10.0)
            .fill(Color.white.opacity(0.1))
            .frame(height: .itemSideSize)
            .overlay {
                VStack(spacing: 18.0) {
                    Image(systemName: "wind")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32.0, height: 32.0)
                    VStack(spacing: 2.0) {
                        HStack(alignment: .bottom, spacing: 16.0) {
                            Text("speed:")
                                .font(.footnote)
                                .foregroundStyle(.white.opacity(0.5))
                            Text(text)
                                .font(.headline)
                        }
                        HStack(alignment: .bottom, spacing: 16.0) {
                            Text("direction:")
                                .font(.footnote)
                                .foregroundStyle(.white.opacity(0.5))
                            Text(subtitle)
                                .font(.subheadline)
                        }
                    }
                }
            }
        
    }
}

struct CloudCell: View {
    
    let value: ForecastResponse.Clouds
    
    var formatter: NumberFormatter = {
        let instance = NumberFormatter()
        instance.numberStyle = .decimal
        instance.maximumFractionDigits = 0
        return instance
    }()
    
    var text: String {
        return "\(formatter.string(from: NSNumber(value: value.all)) ?? " - ")%"
    }

    var body: some View {
        
        RoundedRectangle(cornerRadius: 10.0)
            .fill(Color.white.opacity(0.1))
            .frame(height: .itemSideSize)
            .overlay {
                VStack(spacing: 18.0) {
                    Image(systemName: "cloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32.0, height: 32.0)
                    VStack(spacing: 2.0) {
                        HStack(alignment: .bottom, spacing: 16.0) {
                            Text("cloudness:")
                                .font(.footnote)
                                .foregroundStyle(.white.opacity(0.5))
                            Text(text)
                                .font(.headline)
                        }
                        HStack(alignment: .bottom, spacing: 16.0) {
                            Text("")
                                .font(.footnote)
                                .foregroundStyle(.white.opacity(0.5))
                            Text("")
                                .font(.subheadline)
                        }
                    }
                }
            }
        
    }
}

struct SunCell: View {
    
    let value: Double
    
    let isUp: Bool
    
    var imageName: String {
        return isUp ? "sunrise" : "sunset"
    }
    
    private let formatter: DateFormatter = .custom(timezone: .current, format: "HH:mm")
    
    var text: String {
        return formatter.string(from: Date(timeIntervalSince1970: value))
    }

    var body: some View {
        
        RoundedRectangle(cornerRadius: 10.0)
            .fill(Color.white.opacity(0.1))
            .frame(height: .itemSideSize)
            .overlay {
                VStack(spacing: 18.0) {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32.0, height: 32.0)
                    VStack(spacing: 2.0) {
                        HStack(alignment: .bottom, spacing: 16.0) {
                            Text(imageName)
                                .font(.footnote)
                                .foregroundStyle(.white.opacity(0.5))
                            Text(text)
                                .font(.headline)
                        }
                    }
                }
            }
        
    }
}
