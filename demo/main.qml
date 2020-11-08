import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: root
    width: 600
    height: 750
    visible: true
    title: "QuickBehaviors Demo"

    property int counter: 0
    property bool toggle: true

    property list<Page> demoPages: [
        DemoPage {
            title: "CrossFadeBehavior"
            description: `
\`CrossFadeBehavior\` allows to easily and declaratively crossfade 2 graphical copies
of an \`Item\` when one of its property changes,
one made before the property has changed and one made after.
`
            demoItems: [
                CounterText {
                    objectName: "No Behavior"
                },
                CounterText {
                    objectName: 'CrossFadeBehavior (default on opacity)'
                    CrossFadeBehavior on text {}
                },
                CounterText {
                    objectName: 'CrossFadeBehavior, sequential'
                    CrossFadeBehavior on text { sequential: true}
                },
                CounterText {
                    objectName: 'CrossFadeBehavior on scale'
                    CrossFadeBehavior on text { fadeProperty: "scale" }
                },
                CounterText {
                    objectName: 'CrossFadeBehavior on scale and opacity'
                    CrossFadeBehavior on text { fadeProperties: ["scale", "opacity"] }
                },
                CounterText {
                    objectName: 'CrossFadeBehavior on x'
                    CrossFadeBehavior on text { fadeProperty: "x"; exitValue: fadeTarget.width + 20 }
                },
                CounterText {
                    objectName: 'CrossFadeBehavior with custom animations'
                    CrossFadeBehavior on text {
                        //sorry, verbose code ahead
                        id: textCfb
                        exitAnimation: ParallelAnimation {
                            id: exit
                            property Item target
                            NumberAnimation {
                                target: exit.target
                                property: "opacity"
                                to: 0
                                easing.type: Easing.InQuad
                            }
                            NumberAnimation {
                                target: exit.target
                                property: "x"
                                to: textCfb.fadeTarget.width
                                easing.type: Easing.InQuad
                            }
                        }
                        enterAnimation: ParallelAnimation {
                            id: enter
                            property Item target
                            NumberAnimation {
                                target: enter.target
                                property: "opacity"
                                from: 0
                                to: 1
                                easing.type: Easing.InQuad
                            }
                            NumberAnimation {
                                target: enter.target
                                property: "x"
                                from: -textCfb.fadeTarget.width
                                to: 0
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                },
                CounterText {
                    id: counterText
                    objectName: "CrossFadeBehavior on custom target (and on scale)"
                    CrossFadeBehavior on text { fadeTarget: counterText.textItem; fadeProperty: "scale" }
                }

            ]
        },
        DemoPage {
            title: "CrossFadeBehavior Image"
            description: `
\`CrossFadeBehavior\` has an optional property named \`delayWhile\`,
it can be used to delay the starts of the animations while a condition is met.

In the last of the following examples the \`delayWhile\` property is bound to the Image's \`status\` property,
this allows to only start the animations if the Image new source has actually changed and loaded.
`
            demoItems: [
                EmojiImage {
                    objectName: "No Behavior"
                },
                EmojiImage {
                    objectName: 'CrossFadeBehavior'
                    CrossFadeBehavior on source {}
                },
                EmojiImage {
                    objectName: 'CrossFadeBehavior with delayWhile loading'
                    CrossFadeBehavior on source { delayWhile: fadeTarget.status === Image.Loading }
                },
                EmojiImage {
                    objectName: 'CrossFadeBehavior on scale with delayWhile loading'
                    CrossFadeBehavior on source { fadeProperty: "scale"; delayWhile: fadeTarget.status === Image.Loading }
                }
            ]
        },
        DemoPage {
            title: "FadeBehavior"
            description:`
\`FadeBehavior\` is a simpler Behavior than \`CrossFadeBehavior\`,
instead of making and animating graphical copies of the target object, it directly animates it.
This means it can only be sequential, animating the oject out,
actually changing the target property and animating the object back in.
`
            demoItems: [
                CounterText {
                    objectName: "No Behavior"
                },
                CounterText {
                    objectName: 'FadeBehavior (default on scale)'
                    FadeBehavior on text {}
                },
                CounterText {
                    objectName: 'FadeBehavior on opacity'
                    FadeBehavior on text { fadeProperty: "opacity" }
                },
                CounterText {
                    objectName: 'FadeBehavior on x'
                    FadeBehavior on text { fadeProperty: "x"; fadeValue: fadeTarget.width + 20 }
                },
                CounterText {
                    objectName: 'FadeBehavior on custom target'
                    FadeBehavior on text { fadeTarget: targetProperty.object.textItem }
                }
            ]
        },
        DemoPage {
            title: "VisibleBehavior"
            description:`
\`VisibleBehavior\` is a special case of \`FadeBehavior\`.
It can declaratively animates an Item when its visibility changes and only the relevant animation is ran
(the enter animation when the Item goes visible and the exit one when it is being hidden).

This allow avoiding the infamous following snippet:

    property bool shown: someCondition
    visible: opacity
    opacity: shown ? 1 : 0
    Behavior on opacity { NumberAnimation {} }

and results in clearer code with no added custom property:

    visible: someCondition
    VisibleBehavior on visible {}
`
            demoItems: [
                HidingRectangle {
                    objectName: "No Behavior"
                },
                HidingRectangle {
                    objectName: 'VisibleBehavior (default on opacity)'
                    VisibleBehavior on visible {}
                },
                HidingRectangle {
                    objectName: 'VisibleBehavior on scale'
                    VisibleBehavior on visible { fadeProperty: "scale" }
                },
                HidingRectangle {
                    objectName: 'VisibleBehavior on width'
                    VisibleBehavior on visible { fadeProperty: "width" }
                },
                HidingRectangle {
                    objectName: 'VisibleBehavior on x'
                    VisibleBehavior on visible { fadeProperty: "x"; fadeValue: fadeTarget.width + 20 }
                },
                HidingRectangle {
                    objectName: 'VisibleBehavior on custom property bound to width and height'
                    property real progress: 1
                    width: 50 * progress
                    height: 50 * progress
                    VisibleBehavior on visible { fadeProperty: "progress" }
                }
            ]
        }
    ]
    Timer {
        running: true
        repeat: true
        interval: 1500
        onTriggered: {
            root.counter = (root.counter + 1) % 10;
            root.toggle = !root.toggle;
        }
    }

    component DemoPage: Page {
        id: page
        property string description
        required property list<Item> demoItems

        header: Label {
            text: page.description
            wrapMode: Text.Wrap
            padding: 10
            font.weight: Font.DemiBold
            textFormat: Text.MarkdownText
        }

        ListView {
            id: listView
            spacing: 20
            clip: true
            anchors {
                fill: parent
                margins: 20
            }
            model: page.demoItems
            delegate: RowLayout {
                width: listView.width
                Label {
                    id: label
                    text: modelData.objectName
                    Layout.fillWidth: true
                    font.pixelSize: 14
                    elide: Text.ElideRight
                }
                Item {
                    width: 50
                    height: 50
                    children: modelData
                }
            }
        }
    }
    component CounterText: Rectangle {
        property string text: root.counter
        readonly property Item textItem: textItem
        width: 50
        height: 50
        radius: width / 2
        border.width: 2
        Text {
            id: textItem
            anchors.centerIn: parent
            anchors.alignWhenCentered: false
            text: parent.text
            font.pixelSize: 30
        }
    }
    component EmojiImage: Image {
        width: 50
        fillMode: Image.PreserveAspectFit
        cache: false
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        readonly property url smilingFaceUrl: "http://deelay.me/20/http://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/60/google/56/white-smiling-face_263a.png"
        readonly property url winkingFaceUrl: "http://deelay.me/20/http://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/60/google/56/winking-face_1f609.png"
        source: root.toggle ? smilingFaceUrl : winkingFaceUrl
    }
    component HidingRectangle: Rectangle {
        width: 50
        height: 50
        border.width: 2
        visible: root.toggle
    }
    header: TabBar {
        id: tabBar
        Repeater {
            model: root.demoPages
            TabButton {
                text: modelData.title
            }
        }
    }
    StackLayout {
        currentIndex: tabBar.currentIndex
        anchors.fill: parent
        children: root.demoPages
    }
}
