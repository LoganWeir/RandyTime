# RandyTime - Garmin Connect IQ Watch App

## Project Overview

RandyTime is a Garmin Connect IQ watch application written in Monkey C, designed for the Garmin Instinct 2 series. This is a watch app that provides a custom interface accessible through the device's menu system.

## Project Structure

- **Source Code**: `/source/` - Contains all Monkey C application files
  - `RandyTimeApp.mc` - Main application entry point
  - `RandyTimeView.mc` - Main view implementation
  - `RandyTimeDelegate.mc` - Main input delegate
  - `RandyTimeMenuDelegate.mc` - Menu input handling
- **Resources**: `/resources/` - Application resources and assets
  - `strings/strings.xml` - String resources and localization
  - `layouts/layout.xml` - UI layout definitions
  - `menus/menu.xml` - Menu structure definitions
  - `drawables/` - Icons and visual assets
- **Configuration**: 
  - `manifest.xml` - App metadata, permissions, and target devices
  - `monkey.jungle` - Project build configuration
- **Build Output**: `/bin/` - Generated files and build artifacts

## Development Environment

This is a Garmin Connect IQ project that requires:
- **Connect IQ SDK** for development and building
- **Visual Studio Code** with Connect IQ extension (recommended)
- **Monkey C** programming language

## Target Device

- **Primary Target**: Garmin Instinct 2 (product ID: `instinct2`)
- **API Level**: Minimum 1.5.0
- **Language**: English (eng)

## Key Features

Based on the project structure:
- Custom watch app interface
- Menu-driven interaction
- Custom launcher icon
- Localized strings support

## Build Commands

This project uses the Garmin Connect IQ SDK build system:

```bash
# Build the application (requires Connect IQ SDK)
# Typically done through VS Code Connect IQ extension or:
connectiq build

# Simulate on device
connectiq simulate

# Package for distribution
connectiq package
```

## Development Workflow

1. **Setup**: Install Garmin Connect IQ SDK and VS Code extension
2. **Development**: Edit `.mc` files in `/source/` directory
3. **Resources**: Modify XML files in `/resources/` for UI and strings
4. **Testing**: Use Connect IQ simulator for testing
5. **Build**: Use VS Code Connect IQ commands or SDK CLI
6. **Deploy**: Package and install on compatible Garmin devices

## Configuration Notes

- The `manifest.xml` is generated and should be edited through VS Code commands
- Use "Monkey C: Edit Application" to modify app attributes
- Use "Monkey C: Set Products by Product Category" to add target devices
- Build artifacts are generated in `/bin/` directory

## File Extensions

- `.mc` - Monkey C source files
- `.xml` - Resource and configuration files
- `.svg` - Vector graphics for icons
- `.jungle` - Project configuration

This project follows standard Garmin Connect IQ application structure and conventions.