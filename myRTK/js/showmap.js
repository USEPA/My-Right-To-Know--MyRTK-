	
       
       var map;
		var markersArray = [];
		var locArray = [];
		var infoWindow;
		var modalState = 0;
		function indexload() {
			var myOptions = { mapTypeId: google.maps.MapTypeId.ROADMAP };      
			var map = new google.maps.Map(document.getElementById("myMap"));      
			var geocoder = new google.maps.Geocoder();      
			geocoder.geocode({'address': 'US'}, function (results, status) {   
				var ne = results[0].geometry.viewport.getNorthEast();     
				var sw = results[0].geometry.viewport.getSouthWest();   
				map.fitBounds(results[0].geometry.viewport);  
				 map.setCenter( new google.maps.LatLng(28.631466106808542, 77.07853317260742), 5); 
				}); 
			
		}
		
