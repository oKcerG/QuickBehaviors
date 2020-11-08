# QuickBehaviors

A set of Qt Quick Behaviors to easily and declaratively animate an Item when one of its property changes.

```qml
Timer {
    id: timer
    property bool toggle: true
    running: true
    repeat: true
    interval: 1000
    onTriggered: toggle = !toggle
}
Text {
    text: timer.toggle ? "ON" : "OFF"
}
Text {
    text: timer.toggle ? "ON" : "OFF"
    CrossFadeBehavior on text { }
}
Text {
    text: timer.toggle ? "ON" : "OFF"
    FadeBehavior on text { }
}
Text {
    text: "ON"
    visible: timer.toggle
    VisibleBehavior on visible { }
}
```

![preview](preview.gif)

Read the implementation files and the [demo project](demo/main.qml) to get more details about the features and possibilities.
You can also preview the demo project in [video](https://imgur.com/a/7DZOYv5).
