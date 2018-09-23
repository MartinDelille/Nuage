import QtQuick 2.11
import QtMultimedia 5.4

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

    Camera {
        id: camera
        captureMode: Camera.CaptureStillImage

        imageCapture {
            onImageCaptured: {
                preview.source = preview
                stillControls.previewAvailable = true
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
        source: camera
        anchors.fill: parent
        focus : visible // to receive focus and capture key events when visible
    }

    CaptureControls {
        id: stillControls
        anchors.fill: parent
        camera: camera
        visible: cameraUI.state == "Capture"
        onPreviewSelected: cameraUI.state = "Preview"
    }
}
