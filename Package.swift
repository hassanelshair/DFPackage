// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FormBuilderPackage",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FormBuilderPackage",
            targets: ["FormBuilderPackage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.6.0")),
        .package(url: "https://github.com/gordontucker/FittedSheets.git", .upToNextMajor(from: "2.6.1")),
        .package(url: "https://github.com/nicklockwood/Expression.git", .upToNextMajor(from: "0.13.8")),
        .package(url: "https://github.com/SwiftKickMobile/SwiftMessages.git", .upToNextMajor(from: "10.0.0")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.11.0")),
        .package(url: "https://github.com/huynguyencong/EzPopup.git", .upToNextMajor(from: "1.2.4")),
        .package(url: "https://github.com/MoathOthman/MOLH.git", .upToNextMajor(from: "1.2.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FormBuilderPackage",
            dependencies: [
                           "RxSwift",
                           .product(name: "RxCocoa", package: "RxSwift"),
                           "FittedSheets",
                           "Expression",
                           "SwiftMessages",
                           "Kingfisher",
                           "EzPopup",
                           "MOLH"
                       ]
        ),
        
        .testTarget(
            name: "FormBuilderPackageTests",
            dependencies: ["FormBuilderPackage"]),
    ]
)

//    .package(url: "https://github.com/4taras4/EzPopup.git", from: "1.0.0"),
//    .package(url: "https://github.com/gordontucker/FittedSheets.git", from: "2.4.0"),
//    .package(url: "https://github.com/nicklockwood/Expression.git", from: "0.13.0"),
//    .package(url: "https://github.com/SwiftKickMobile/SwiftMessages.git", from: "8.0.0"),
//    .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.0.0"),
//    .package(url: "https://github.com/onevcat/Kingfisher.git", from: "6.0.0"),
//    .package(url: "https://github.com/onmyway133/Dropdown.git", from: "2.3.0")
