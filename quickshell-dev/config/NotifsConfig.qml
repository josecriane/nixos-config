import Quickshell.Io

JsonObject {
    property bool actionOnClick: false
    property real clearThreshold: 0.3
    property int defaultExpireTimeout: 5000
    property int expandThreshold: 20
    property bool expire: true
    property int groupPreviewNum: 3
    property Sizes sizes: Sizes {
    }

    component Sizes: JsonObject {
        property int badge: 20
        property int image: 41
        property int width: 400
    }
}
