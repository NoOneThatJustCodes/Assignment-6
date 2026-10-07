//
//  TheMetWidget.swift
//  TheMet
//
//  Created by Jonathan S. on 10/5/26.
//

import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let object: Object
}

struct Provider: TimelineProvider {
    let query = "persimmon"

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), object: .sample())
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        completion(
            SimpleEntry(
                date: Date(),
                object: .sample(isPublicDomain: false)
            )
        )
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> Void
    ) {
        Task { @MainActor in
            let store = TheMetStore(6)

            await store.fetchObjects(for: query)

            let objects = store.objects.isEmpty
                ? [.sample(), .sample(isPublicDomain: false)]
                : store.objects

            let now = Date()

            let entries = objects.enumerated().map { index, object in
                SimpleEntry(
                    date: Calendar.current.date(
                        byAdding: .hour,
                        value: index,
                        to: now
                    ) ?? now,
                    object: object
                )
            }

            completion(
                Timeline(
                    entries: entries,
                    policy: .atEnd
                )
            )
        }
    }
}

struct TheMetWidgetEntryView: View {
    var entry: Provider.Entry
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("The Met").font(.headline)
            Divider()
            if entry.object.isPublicDomain {
                HStack(alignment: .firstTextBaseline) {
                    Text(entry.object.title)
                    Spacer()
                    Image(systemName: "doc.text.image.fill")
                }
            } else {
                WebIndicatorView(title: entry.object.title)
            }
        }
        .fontWeight(.semibold)
        .widgetURL(URL(string: "themet://\(entry.object.objectID)"))
    }
}

struct TheMetWidget: Widget {
    let kind = "TheMetWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TheMetWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("The Met")
        .description("View objects from the Metropolitan Museum of Art.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

@main
struct TheMetWidgetBundle: WidgetBundle {
    var body: some Widget { TheMetWidget() }
}
