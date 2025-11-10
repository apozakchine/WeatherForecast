//
//  DailyItemView.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import SwiftUI

struct DailyItemView: View {
    
    var geometry: GeometryProxy
    var name: String
    var item: DailyCollectionViewModel
    
    private let fullDateFormatter: DateFormatter = {
        let instance = DateFormatter()
        instance.timeZone = .current
        instance.dateStyle = .long
        return instance
    }()

    private let shortTimeFormatter: DateFormatter = .custom(timezone: .current, format: "HH:mm")
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10.0)
            .fill(Color.white.opacity(0.1))
            .frame(width: geometry.size.width - 32.0, height: geometry.size.height * 0.8)
            .overlay {
                VStack(spacing: 24.0) {
                    VStack(alignment: .center, spacing: 8.0) {
                        Text(name)
                            .font(.headline)
                        Text(fullDateFormatter.string(from: item.date))
                            .font(.headline)
                        HStack {
                            SunView(isUp: true, time: item.sunrise)
                            Spacer()
                            SunView(isUp: false, time: item.sunset)
                        }
                    }
                    List(item.items) { element in
                        TableCell(item: element)
                            .frame(height: 48.0)
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    Spacer()
                }
                .padding(16.0)
            }
    }
    
}

private struct TimeView: View {
    
    let icon: String?
    let time: Date
    
    private let formatter: DateFormatter = .custom(timezone: .current, format: "HH:mm")
    
    var body: some View {
        VStack(alignment: .center, spacing: 4.0) {
            URLImageView(id: icon ?? "")
                .frame(width: 20.0, height: 20.0)
            Text(formatter.string(from: time))
                .font(.subheadline)
        }
    }
}

private struct WeatherView: View {
    
    let title: String
    let subtitle: String?
    
    private let formatter: DateFormatter = .custom(timezone: .current, format: "HH:mm")
    
    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.footnote)
            if let subtitle = subtitle {
                Text("(\(subtitle))")
                    .font(.system(size: 8.0))
            }
        }
    }
}

private struct ParameterView: View {
    
    let item: DailyCollectionViewModel.Item
    
    let keyPath: KeyPath<DailyCollectionViewModel.Item, Double>
    let measureDescription: String
    let imageName: String

    private let formatter: NumberFormatter = {
        let instance = NumberFormatter()
        instance.numberStyle = .decimal
        instance.maximumFractionDigits = 0
        return instance
    }()

    var body: some View {
        VStack(alignment: .center, spacing: 2.0) {
            Image(systemName: imageName)
                .foregroundStyle(Color.blue)
                .frame(width: 20.0, height: 20.0)
            if let text = formatter.string(from: NSNumber(value: item[keyPath: keyPath])) {
                Text("\(text)\(measureDescription)")
                    .font(.footnote)
            } else {
                Text("-")
                    .font(.footnote)
            }
        }
    }
}

private struct TableCell: View {
    
    let item: DailyCollectionViewModel.Item
    
    var body: some View {
        HStack(spacing: 12.0) {
            TimeView(icon: item.imageId, time: item.time)
            Spacer()
            WeatherView(title: item.name ?? "", subtitle: item.description)
            Spacer()
            ParameterView(item: item,
                          keyPath: \.cloud,
                          measureDescription: "%",
                          imageName: "cloud")
            ParameterView(item: item,
                          keyPath: \.wind,
                          measureDescription: "m/s",
                          imageName: "wind")
            ParameterView(item: item,
                          keyPath: \.temperature,
                          measureDescription: "º",
                          imageName: "thermometer.variable")
        }
    }
    
}

private struct SunView: View {
    
    var isUp: Bool
    var time: Date
    
    private let formatter: DateFormatter = .custom(timezone: .current, format: "HH:mm")

    var body: some View {
        if isUp {
            HStack {
                Image(systemName: "sunrise")
                Text(formatter.string(from: time))
            }
        } else {
            HStack {
                Text(formatter.string(from: time))
                Image(systemName: "sunset")
            }
        }
    }
    
}
