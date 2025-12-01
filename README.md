# SchoolBellMenuBar

Small macOS menu bar app for teachers that shows the time remaining to the next school bell.

## Features

- Menu bar countdown to the next bell (format `XmYYs`).
- Multiple schedules (normal / shortened / other school).
- Editor for bell times:
  - add, remove, reorder bells
  - automatic sorting by time
  - import from text (`HH:MM;Label` per line).

## Requirements

- macOS 15+
- Xcode 15+
- SwiftUI, Swift 5.9+

## Installation

1. Open the Xcode project.
2. Build the `SchoolBellMenuBar` target for `My Mac`.
3. In the **Products** group, right-click `SchoolBellMenuBar.app` → **Show in Finder**.
4. Drag the app to your `/Applications` folder.
5. Launch it from Spotlight.

## License

MIT
