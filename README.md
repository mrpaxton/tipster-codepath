# Pre-work - *SuperTipper*

**SuperTipper** is a tip calculator application for iOS.

Submitted by: **Sarn Wattanasri**

Time spent: **~15** hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [x] UI animations(Bill Amount Field)
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

* [x] Making a bill splitting feature using a UIPickerView to select the number of people
* [x] Styling the application UIs and use Emoji images and UISliders to present the settings
* [x] Making sticky user interfaces(UIPickerView and UISegmentedControl): remembering data across pages
* [x] Add the Camera to take bill photos (working on device but not on simulator)
* [x] Include a custom knob that can work in conjunction with the preset control (most challenging in this app dev so far) 

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

![ALT TEXT](supertipper.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

During this application development, I have experienced some confusion in programming language syntax usage and unique language features.  This is primarily due to the fact that I have recently been programming in Python, Java, and Swift, which is somewhat new to me.
Swift is a young language and takes me some time to familiarize myself with its features such as unwrapping optionals, variable declaration with var VS let, etc.  The other challenge I faced was working on the UIs using Xcode.  
There are various steps to learn and understand to accomplish some tasks such as linking the UI elements to View Controllers, configure attributes, using Outlet and Action, wire Delegate and DataSource(in my optional bill splititng feature)
Overall, it was enjoyable :)

## License

    Copyright [2015] [Sarn Wattanasri]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
