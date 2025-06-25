# ![alt batrider](https://static.wikia.nocookie.net/dota2_gamepedia/images/0/0d/Batrider_minimap_icon.png/revision/latest?cb=20120717000918) batrider

An iOS application that lets users scan QR codes on vehicles using the camera to instantly show related vehicle details in the app.

![GitHub](https://img.shields.io/github/license/rezo0L/batrider) ![GitHub release (latest by date)](https://img.shields.io/github/release/rezo0L/batrider)

The name of the project is inspired by a hero in [Dota 2](https://www.dota2.com).

>![alt text](https://static.wikia.nocookie.net/dota2_gamepedia/images/f/f2/Batrider_icon.png/revision/latest?cb=20160411220708)
>
>There is no such thing as harmony among the creatures of the Yama Raskav Jungle. By bite, or claw, or pincer, or hoof, even the slightest sign of weakness means a swift death. They say the Rider was just a lad cutting chaff in his family's field when he was taken, swept up by a massive morde-bat looking for take-out. But this boy had a better idea, and wriggled his way from his captor's grip, onto the beast's back, and hacked it down with his tools. Emerging from the bloody wreckage and intoxicated by the thrill of flight, the boy realized he'd found his calling.
>
>The boy grew, and every summer he'd return to his family's field, often setting out into the bush seeking to reclaim that first thrill of facing death in the form of jaws or a fatal fall. The years went on, but his fire only grew stronger. He studied the overgrowth, plunging deeper with each expedition, until finally he found his way to the caves at the heart of hostility. They say the Rider, on the eve of a scorching summer night, had nothing but a rope, a bottle of liquid courage and a burning determination to feel the skies once more, when he plunged inside…

---

## Architecture Overview

- **Modular, package-based structure** with clear separation of concerns.
- **MVVM (Model-View-ViewModel)** for UI logic, especially in SwiftUI screens.
- **Coordinator pattern** for navigation and flow management, integrating UIKit and SwiftUI.
- Designed to be **platform and framework agnostic** where possible, supporting multi-platform usage and easy extension.

## Libraries/Tools Used

- **No external libraries or frameworks are used in the main app or packages.**
- The only third-party dependency is **[pointfreeco/swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing)**, which is used exclusively in the test target for UI snapshot tests.
- **SwiftUI** and **UIKit**: Both are used to demonstrate integration and migration strategies.
- **XCTest**: For unit and snapshot testing.
- **SPM (Swift Package Manager)**: For modularizing `QRCodeScanner`, `NetworkClient`, and `DesignSystem` as reusable packages.

## Design Decisions & Trade-offs

- **UIKit + SwiftUI**: Demonstrates integration and migration, reflecting common team scenarios.
- **Reusable Packages**: `QRCodeScanner` and `NetworkClient` are SPM packages, documented for reuse across apps.
- **Testing**: Mix of native Swift testing and XCTest for demonstration purposes.
- **Error Handling**: Errors are handled gracefully in all packages and domains.
- **Agnostic Code**: Platform/framework-agnostic files for multi-platform support.
- **NetworkClient**: Reduces boilerplate, improves extensibility and developer experience.
- **Minimal CI**: Provided for demonstration, can be extended.
- **Localization**: Ready for localization with centralized string files.
- **Design System**: Minimal, but structured for easy extension.
- **Snapshot Tests**: Recorded on iPhone 15 Pro, iOS 17.5. Always verify on this device/OS. (A guard in the test class is recommended for enforcement.)
- **Readability, Maintainability, Extensibility**: The codebase is structured for clarity and future growth, with modularization and clear abstractions.
- **Adherence to SOLID Principles**:
  - **Single Responsibility**: Each class, struct, and protocol has a focused responsibility (e.g., `VehicleViewModel`, `NetworkClient`).
  - **Open/Closed**: Components are open for extension (e.g., protocols for services and clients) but closed for modification.
  - **Liskov Substitution**: Protocols and abstractions allow for easy mocking and substitution in tests.
  - **Interface Segregation**: Protocols are small and focused (e.g., `QRCodeScanner`, `VehicleService`).
  - **Dependency Inversion**: High-level modules depend on abstractions, not concrete implementations (e.g., dependency injection for services).

## How to Run the Project and Tests

1. Open `Batrider.xcodeproj` in Xcode (15+ recommended).
2. Select the `Batrider` scheme and run on a simulator or device (iOS 16+).
3. To run tests, select the `Vehicle` package or `Batrider` scheme and press ⌘U.
4. **Snapshot tests:** Ensure you are running on iPhone 15 Pro, iOS 17.5. If updating snapshots, use the same device/simulator and OS version.

---

## Additional Notes

- **Design Patterns Used:**
  - **MVVM**: For UI logic separation.
  - **Coordinator**: For navigation and flow.
  - **Protocol-Oriented Programming**: For abstraction and testability (e.g., `NetworkClient`, `QRCodeScanner`).
  - **Dependency Injection**: For testability and flexibility.
- **Architecture**: Modular, package-based, MVVM + Coordinator.
