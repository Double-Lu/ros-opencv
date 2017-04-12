// adapted from ImageItem from Qt MapViewer example
import QtQuick 2.5;
import QtLocation 5.6

MapQuickItem {
    id: droneItem
    property real magnitude: 0.000141421
    property real x_vel: 0.0001
    property real y_vel: 0.0001
    property var nextTarget: null
    property bool movingRight: true
    property bool movingUp: true

    MouseArea {
        anchors.fill: parent
        drag.target: parent
    }

    function setGeometry(startCoords) {
        coordinate.latitude = startCoords.latitude
        coordinate.longitude = startCoords.longitude
    }

    function setVel(x,y){
        this.x_vel = x;
        this.y_vel = y;
    }

    function setNextTarget(targ){
        if(targ.latitude !== coordinate.latitude || targ.longitude !== coordinate.longitude){
            var delta_x = targ.latitude - coordinate.latitude;
            var delta_y = targ.longitude - coordinate.longitude;
            var mag = Math.sqrt(Math.pow(delta_x, 2) + Math.pow(delta_y, 2));
            this.x_vel = (delta_x / mag) * 0.0001;
            this.y_vel = (delta_y / mag) * 0.0001;
            if(delta_x > 0){
                movingRight = true;
            } else {
                movingRight = false;
            }
            if(delta_y > 0) {
                movingUp = true;
            } else {
                movingUp = false;
            }
            console.log('***SETNEXTTARG: next target set. moving up = ' + movingUp + ', moving right = ' + movingRight);
            nextTarget = targ;

        }
    }

    function move(){
        coordinate.latitude += x_vel
        coordinate.longitude += y_vel
    }



    sourceItem: Image {
        id: testImage
        source: "../resources/droneImage.png"
        opacity: 1.0
    }
}
