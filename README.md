# ImageBar

---
<img width="330" alt="6-22-25 imagebar screenshot" src="https://github.com/user-attachments/assets/e74f7452-acdb-493b-a031-ce81692dd289" />

---

A Menubar image conversion and resizing tool for MacOS with drag-and-drop support, built with SwiftUI's `MenuBarExtra API`. Supports JPEG, HEIC, TIFF and PNG through ImageIO.


## Why I Built ImageBar

Ever since my first project, I struggled with resizing images and icons for various platforms (web, mobile, mac, etc.) While I was able to resize files through Preview, this process was extremely tedious. I built ImageBar as a simple utility that allows users like myself to drag and drop images onto its menubar icon and quickly receive a converted image without jumping through so many hoops.

## Tech Stack
- `SwiftUI` for the user interface
- `UIKit` for the file destination picker
- `ImageIO` for the image conversion utility

## Usage
- Open the application to select desired output format, output size, and the output file suffix. (A blank suffix will allow you to overwrite the original file)
- Drag your images into the application icon in the menu bar
- Select a destination for the converted images through the file picker interface

## Special Thanks
- The [MenuBarExtraAccess](https://github.com/orchetect/MenuBarExtraAccess) library, which allowed me to access the `NSStatusItem` AppKit API, which I needed to enable the file drag-and-drop functionality.
- [This GitHub Issue](https://github.com/localsend/localsend/issues/1615) which gave me the code inspiration to implement drag-and-drop
