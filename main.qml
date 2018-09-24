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
        id: viewfinder
        visible: cameraUI.state == "Capture"

        x: 0
        y: 0
        width: parent.width - stillControls.buttonsPanelWidth
        height: parent.height

        source: camera
        autoOrientation: true
    }

    CaptureControls {
        id: stillControls
        anchors.fill: parent
        camera: camera
        visible: cameraUI.state == "Capture"
        onPreviewSelected: cameraUI.state = "Preview"
    }
}
