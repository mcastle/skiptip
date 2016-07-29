var hue = "#eff3f6",
    waterColor = "#76c6ff",
    highwayColor = "#7c9eb6",
    roadColor = "#beceda",
    arterialRoadColor = "#9db6c8",
    roadLabelColor = "#ffffff",
    zoom = 18,
    mapStyles = [
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
    ],
    mapOptions = {
      center: { lat: 33.81910649351353, lng: -84.36374562358856 },
      zoom: zoom,
      minZoom: 4,
      styles: mapStyles,
      disableDefaultUI: true
    }

export var GoogleMap = function(target) {
  var element = document.getElementById(target)
  return new google.maps.Map(element, mapOptions)
}
