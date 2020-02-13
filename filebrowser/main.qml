import QtQuick 2.12
import QtQuick.Shapes 1.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3

Window {
    id: window
    visible: true
    flags: Qt.FramelessWindowHint
    width: 640
    height: 480
    title: qsTr("Stack")
    color: "#99000000"

    function toggleMaximized() {
        if (window.visibility === Window.Maximized) {
            window.showNormal();
        } else {
            window.showMaximized();
        }
    }

    DragHandler {
        id: resizeHandler
        grabPermissions: TapHandler.TakeOverForbidden
        target: null
        onActiveChanged: if (active) {
            const p = resizeHandler.centroid.position;
            let e = 0;
            if (p.x / width < 0.10) { e |= Qt.LeftEdge }
            if (p.x / width > 0.90) { e |= Qt.RightEdge }
            if (p.y / height < 0.10) { e |= Qt.TopEdge }
            if (p.y / height > 0.90) { e |= Qt.BottomEdge }
            console.log("RESIZING", e);
            window.startSystemResize(e);
        }
    }

    Page {
        anchors.fill: parent
        anchors.margins: window.visibility === Window.Windowed ? 5 : 0
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
                    ToolButton { text: "home" }
                    Label { text: "/" }
                    ToolButton { text: "johan" }
                    Label { text: "/" }
                    ToolButton { text: "dev" }
                }

                RowLayout {
                    spacing: 0
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    TextField {
                        placeholderText: "search"
                    }
                    ToolButton {
                        text: "🗕"
                        font.pixelSize: Qt.application.font.pixelSize * 1.6
                        onClicked: window.showMinimized();
                    }
                    ToolButton {
                        text: window.visibility == Window.Maximized ? "🗗" : "🗖"
                        font.pixelSize: Qt.application.font.pixelSize * 1.6
                        onClicked: window.toggleMaximized()
                    }
                    ToolButton {
                        text: "🗙"
                        font.pixelSize: Qt.application.font.pixelSize * 1.6
                        onClicked: window.close()
                    }
                }
            }
        }

        Drawer {
            id: drawer
            width: window.width * 0.66
            height: window.height
            interactive: window.visibility !== Window.Windowed || position > 0
        }

    }
}
