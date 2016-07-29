var GoogleMap = require("web/static/js/maps/common").GoogleMap
export var Map = {
  init: function(target){
    this.map = GoogleMap(target)
    return this
  },

  setCoordinates: function(lat, lng) {
    this.map.setZoom(20)
    this.map.setCenter({lat: lat, lng: lng})
  },

  getCoordinates: function() {
    var center = this.map.getCenter(),
        lat = center.lat(),
        lng = center.lng()
    SkipTip.Callbacks.getCoordinates(lat, lng)
    return {lat: lat, lng: lng}
  }
}
