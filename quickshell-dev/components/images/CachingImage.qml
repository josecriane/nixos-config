import qs.utils
// import Caelestia // Removed Caelestia dependency
import Quickshell
import QtQuick

Image {
    id: root

    property string path
    source: path // Direct path usage without caching

    property int sourceWidth
    property int sourceHeight

    asynchronous: true
    fillMode: Image.PreserveAspectCrop
    sourceSize.width: sourceWidth
    sourceSize.height: sourceHeight
}