import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3

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
                onActiveChanged: if (active) { window.startSystemMove(); }
            }
            RowLayout {
                anchors.left: parent.left
                spacing: 3
                ToolButton {
                    id: toolButton
                    text: "\u2630"
                    font.pixelSize: Qt.application.font.pixelSize * 1.6
                    onClicked: drawer.open()
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
                text: "Home"
                anchors.centerIn: parent
            }
        }
    }

    Drawer {
        id: drawer
        width: window.width * 0.66
        height: window.height
    }
}
