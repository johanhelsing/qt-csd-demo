import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
import Qt.labs.handlers 1.0

ApplicationWindow {
    function toggleMaximized() {
        if (window.visibility === Window.Maximized) {
            window.showNormal();
        } else {
            window.showMaximized();
        }
    }
    id: window
    visible: true
    flags: Qt.FramelessWindowHint
    width: 640
    height: 480
    title: qsTr("Stack")

//    footer: ToolBar {
    header: ToolBar {
        contentHeight: toolButton.implicitHeight
        Item {
            anchors.fill: parent
            TapHandler {
                onTapped: if (tapCount === 2) toggleMaximized()
                gesturePolicy: TapHandler.DragThreshold
            }
            DragHandler {
                grabPermissions: TapHandler.CanTakeOverFromAnything
                onGrabChanged: {
                    if (active) {
                        var position = parent.mapToItem(window.contentItem, point.position.x, point.position.y)
                        window.startSystemMove(position);
                    }
                }
            }
            RowLayout {
                anchors.left: parent.left
                spacing: 3
                ToolButton {
                    id: toolButton
                    text: stackView.depth > 1 ? "\u25C0" : "\u2630"
                    font.pixelSize: Qt.application.font.pixelSize * 1.6
                    onClicked: {
                        if (stackView.depth > 1) {
                            stackView.pop()
                        } else {
                            drawer.open()
                        }
                    }
                }
                Button { text: "home" }
                Button { text: "johan" }
                Button { text: "dev" }
            }

            RowLayout {
                spacing: 0
                anchors.right: parent.right
                anchors.rightMargin: 5
                TextField {
                    placeholderText: "search"
                }
                ToolButton {
                    text: "_"
                    font.pixelSize: Qt.application.font.pixelSize * 1.6
                    onClicked: window.showMinimized();
                }
                ToolButton {
                    text: "#"
                    font.pixelSize: Qt.application.font.pixelSize * 1.6
                    onClicked: window.toggleMaximized()
                }
                ToolButton {
                    text: "x"
                    font.pixelSize: Qt.application.font.pixelSize * 1.6
                    onClicked: window.close()
                }
            }

            Label {
                text: stackView.currentItem.title
                anchors.centerIn: parent
            }
        }
    }

    Drawer {
        id: drawer
        width: window.width * 0.66
        height: window.height

        Column {
            anchors.fill: parent

            ItemDelegate {
                text: qsTr("Page 1")
                width: parent.width
                onClicked: {
                    stackView.push("Page1Form.ui.qml")
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Page 2")
                width: parent.width
                onClicked: {
                    stackView.push("Page2Form.ui.qml")
                    drawer.close()
                }
            }
        }
    }

    StackView {
        id: stackView
        initialItem: "HomeForm.ui.qml"
        anchors.fill: parent
    }
}
