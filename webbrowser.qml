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
    property int bw: 5

    function toggleMaximized() {
        if (window.visibility === Window.Maximized) {
            window.showNormal();
        } else {
            window.showMaximized();
        }
    }

    // The mouse area is just for setting the right cursor shape
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: {
            const p = Qt.point(mouseX, mouseY);
            const b = bw + 10; // Increase the corner size slightly
            if (p.x < b && p.y < b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y >= height - b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y < b) return Qt.SizeBDiagCursor;
            if (p.x < b && p.y >= height - b) return Qt.SizeBDiagCursor;
            if (p.x < b || p.x >= width - b) return Qt.SizeHorCursor;
            if (p.y < b || p.x >= height - b) return Qt.SizeVerCursor;
        }
        acceptedButtons: Qt.NoButton // don't handle actual events
    }

    DragHandler {
        id: resizeHandler
        grabPermissions: TapHandler.TakeOverForbidden
        target: null
        onActiveChanged: if (active) {
            const p = resizeHandler.centroid.position;
            const b = bw + 10; // Increase the corner size slightly
            let e = 0;
            if (p.x < b) { e |= Qt.LeftEdge }
            if (p.x >= width - b) { e |= Qt.RightEdge }
            if (p.y < b) { e |= Qt.TopEdge }
            if (p.y >= height - b) { e |= Qt.BottomEdge }
            window.startSystemResize(e);
        }
    }

    Page {
        anchors.fill: parent
        anchors.margins: window.visibility === Window.Windowed ? bw : 0
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
                    anchors.right: parent.right
                    spacing: 3
                    Layout.fillWidth: true
                    TabBar {
                        spacing: 0
                        Repeater {
                            model: ["Google", "GitHub - johanhelsing/qt-csd-demo", "Unicode: Arrows"]
                            TabButton {
                                id: tab
                                implicitWidth: 150
                                text: modelData
                                padding: 0
                                contentItem: Item {
                                    implicitWidth: 120
                                    implicitHeight: 20
                                    clip: true
                                    Label { 
                                        id: tabIcon
                                        text: "↻" 
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        width: 30
                                    }
                                    Text {
                                        anchors.left: tabIcon.right
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        text: tab.text
                                        font: tab.font
                                        opacity: enabled ? 1.0 : 0.3
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        elide: Text.ElideRight
                                    }
                                    Rectangle {
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        anchors.right: tab.checked ? closeButton.left : parent.right
                                        width: 20
                                        gradient: Gradient {
                                            orientation: Gradient.Horizontal
                                            GradientStop { position: 0; color: "transparent" }
                                            //GradientStop { position: 1; color: palette.button }
                                            GradientStop { position: 0.7; color: tab.background.color }
                                        }
                                    }
                                    Button {
                                        id: closeButton
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        anchors.top: parent.top
                                        visible: tab.checked
                                        text: "🗙"
                                        contentItem: Text {
                                            text: closeButton.text
                                            font: closeButton.font
                                            opacity: enabled ? 1.0 : 0.3
                                            color: "black"
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            elide: Text.ElideRight
                                        }
                                        background: Rectangle {
                                            implicitWidth: 10
                                            implicitHeight: 10
                                            opacity: enabled ? 1 : 0.3
                                            color: tab.background.color
                                        }
                                    }
                                }
                            }
                        }
                    }
                    RowLayout {
                        spacing: 0
                        ToolButton { text: "+" }
                        Item { Layout.fillWidth: true }
                        ToolButton {
                            text: "🗕"
                            onClicked: window.showMinimized();
                        }
                        ToolButton {
                            text: window.visibility === Window.Maximized ? "🗗" : "🗖" 
                            onClicked: window.toggleMaximized()
                        }
                        ToolButton {
                            text: "🗙"
                            onClicked: window.close()
                        }
                    }
                }
            }
        }

        Page {
            anchors.fill: parent
            header: ToolBar {
                RowLayout {
                    spacing: 0
                    anchors.fill: parent
                    ToolButton { text: "←" }
                    ToolButton { text: "→" }
                    ToolButton { text: "↻" }
                    TextField {
                        text: "https://google.com"
                        Layout.fillWidth: true
                    }
                    ToolButton {
                        id: toolButton
                        text: "\u2630"
                        onClicked: drawer.open()
                    }
                }
            }
        }

        Drawer {
            id: drawer
            width: window.width * 0.66
            height: window.height
            edge: Qt.RightEdge
            interactive: window.visibility !== Window.Windowed || position > 0
        }

    }
}
