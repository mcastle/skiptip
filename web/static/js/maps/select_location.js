export var Map = {
  init: function(target){

    this.element = $("#" + target)
    var hue = "#eff3f6"
    var waterColor = "#76c6ff"
    var highwayColor = "#7c9eb6"
    var roadColor = "#beceda"
    var arterialRoadColor = "#9db6c8"
    var roadLabelColor = "#ffffff"

    var center = {
      lat: 33.81910649351353,
      lng: -84.36374562358856
    }
    var zoom = 18

    var mapStyles = [
      {
        stylers: [ {hue: hue}, ]
      },
      {
        featureType: 'water',
        stylers: [{color: waterColor}]
      },
      {
        featureType: 'road.local',
        elementType: 'geometry',
        stylers: [{color: roadColor}]
      },
      {
        featureType: 'road.local',
        elementType: 'labels.text.stroke',
        stylers: [ {color: roadColor} ]
      },
      {
        featureType: 'road.highway',
        elementType: 'geometry',
        stylers: [{color: highwayColor}]
      },
      {
        featureType: 'road.highway',
        elementType: 'labels.text.stroke',
        stylers: [ {color: highwayColor} ]
      },
      {
        featureType: 'road.arterial',
        elementType: 'geometry',
        stylers: [{color: arterialRoadColor}]
      },
      {
        featureType: 'road.arterial',
        elementType: 'labels.text.stroke',
        stylers: [ {color: arterialRoadColor} ]
      },
      {
        featureType: 'road',
        elementType: 'labels.text.fill',
        stylers: [
          {color: roadLabelColor}
        ]
      }
    ]

    this.map = new google.maps.Map(document.getElementById(target), {
      center: center,
      zoom: zoom,
      minZoom: 4,
      disableDefaultUI: true
    })

    this.map.set('styles', mapStyles)
  },

  setLocation: function(lat, lng) {
    this.map.setZoom(20)
    this.map.setCenter({lat: lat, lng: lng})
  }
}
