import QtQuick 2.11
import QtMultimedia 5.4
import ai.lipr.clouddetector 1.0

Rectangle {
    id: cameraUI

    width: 800
    height: 480

    color: "black"
    state: "Capture"

    states: [
        State {
            name: "Capture"
            StateChangeScript {
                script: {
                    camera.captureMode = Camera.CaptureStillImage
                    camera.start()
                }
            }
        },
        State {
            name: "Preview"
        }
    ]

    CloudDetector {
        id: detector
    }

    Camera {
        id: camera
        captureMode: Camera.CaptureStillImage

        imageCapture {
            onImageCaptured: {
                cloudPreview.source = preview
                detector.url = preview
                captureControls.previewAvailable = true
                cameraUI.state = "Preview"
            }
        }

        videoRecorder {
             resolution: "640x480"
             frameRate: 30
        }
    }

    Preview {
        id : cloudPreview
        anchors.fill : parent
        onClosed: cameraUI.state = "Capture"
        visible: cameraUI.state == "Preview"
        focus: visible
    }

    VideoOutput {
        id: viewfinder
        visible: cameraUI.state == "Capture"

        x: 0
        y: 0
        width: parent.width - buttonPaneShadow.width
        height: parent.height

        source: camera
        autoOrientation: true
    }

    FocusScope {
        id: captureControls
        anchors.fill: parent
        property bool previewAvailable : false

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
                    camera: camera
                    visible: camera.cameraStatus == Camera.ActiveStatus && camera.focus.isFocusModeSupported(Camera.FocusAuto)
                }

                CameraButton {
                    text: "Capture"
                    visible: camera.imageCapture.ready && cameraUI.state == "Capture"
                    onClicked: camera.imageCapture.capture()
                }

                CameraButton {
                    text: "View"
                    onClicked: cameraUI.state = "Preview"
                    visible: captureControls.previewAvailable && cameraUI.state == "Capture"
                }

                CameraButton {
                    text: "Submit"
                    onClicked: detector.submit()
                    visible: captureControls.previewAvailable && cameraUI.state == "Preview"
                }

                CameraButton {
                    text: "Restart"
                    onClicked: cameraUI.state = "Capture"
                    visible: captureControls.previewAvailable && cameraUI.state == "Preview"
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
}
