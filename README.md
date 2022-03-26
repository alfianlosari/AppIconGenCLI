# App Icon Generator Swift CLI Tool for Ubuntu Linux & macOS

![Alt text](./promo.jpg?raw=true "App Icon Generator Swift CLI Tool")

Generate Asset Icons easily to your iPhone, iPad, Mac, and Apple Watch using CLI Tool

## Features
The app has several main features:
1. Generate assets to iPhone/iPad/Mac/Apple Watch by providing file image path and export path
2. Uses Swift Argument Parser

## Usage
Pass input image file path (1024x1024) and export path arguments. Optionally, you can pass options to generate iconsets only for specific platform. If you don't pass, it will generate for all platforms. The zip contains folders specific to each platform. It contains AppIcon.iconset folder which you can just drag and drop to Xcode XCAssets panel.

ARGUMENTS:
  <input-image-path>      Input image file path
  <export-path>           Export path

OPTIONS:
  --all                   passing this flag will overrides all the other flags
  --iOS                   Generate iPhone and iPad icons in single iOS folder
  --iPhone
  --iPad
  --mac
  --watch
  -h, --help              Show help information.

## Getting Started
- Install Swift 5.6

## Installation
- Install LibGD Ubuntu: `apt-get install libgd-dev`
- Install LibGD macOS: `brew install gd`
- build using `swift build`

## Tutorial
This project is based on the YouTube tutorial series that you can watch at [YouTube](https://youtu.be/RGNRh4KZNG0)
