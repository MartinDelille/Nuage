import QtQuick 2.0
import QtMultimedia 5.4

FocusScope {
    property Camera camera
    property bool previewAvailable : false

    property int buttonsPanelWidth: buttonPaneShadow.width

    signal previewSelected

    id : captureControls

    Rectangle {
        id: buttonPaneShadow
        width: bottomColumn.width + 16
        height: parent.height
        anchors.top: parent.top
        anchors.right: parent.right
        color: Qt.rgba(0.08, 0.08, 0.08, 1)

        Column {
            anchors {
                right: parent.right
                top: parent.top
                margins: 8
            }

            id: buttonsColumn
            spacing: 8

            FocusButton {
                camera: captureControls.camera
                visible: camera.cameraStatus == Camera.ActiveStatus && camera.focus.isFocusModeSupported(Camera.FocusAuto)
            }

            CameraButton {
                text: "Capture"
                visible: camera.imageCapture.ready
                onClicked: camera.imageCapture.capture()
            }

            CameraButton {
                text: "View"
                onClicked: captureControls.previewSelected()
                visible: captureControls.previewAvailable
            }
        }

        Column {
            anchors {
                bottom: parent.bottom
                right: parent.right
                margins: 8
            }

            id: bottomColumn
            spacing: 8
        }


    }
}
