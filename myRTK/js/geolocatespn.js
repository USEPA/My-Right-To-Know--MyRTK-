 var geo_position_js=function() {
	var pub = {};		
	var provider=null;
	pub.getCurrentPosition = function(successCallback,errorCallback,options){
		provider.getCurrentPosition(successCallback, errorCallback,options);			
	}
	
	pub.init = function() {		
		try {
			if (typeof(navigator.geolocation) != "undefined") {
				provider = navigator.geolocation;
				pub.getCurrentPosition = function(successCallback, errorCallback, options) {				
					function _successCallback(p) {
						successCallback(p);
					}
					provider.getCurrentPosition(_successCallback, errorCallback, options);
				}
			} else if (typeof(window.google) != "undefined") {
				provider = google.gears.factory.create('beta.geolocation');	
				pub.getCurrentPosition = function(successCallback, errorCallback, options) {
					try {
						function _successCallback(p) {
							successCallback(p);
						}
						provider.getCurrentPosition(_successCallback, errorCallback, options);
					}
					catch(e) {
						//this is thrown when the request is denied
						errorCallback({message:e,code:1});
					}
				}
			} else { //alert("Your device does not support location services."); 
					var einfo="introducir informaci\363n en la p\341gina de b\372squeda.";
					alert(einfo); }
		}
		catch (e) {
			if (typeof(console) != "undefined") {
				console.log(e);
			}
		}		
		return  provider!=null;
	}
	return pub;
}(); 

var geoLocationOptions = { enableHighAccuracy:true, maximumAge:600000 };

function findUserLocationMap() {
	var mygeo;
	if (getCookie('center')) {
		var acenter = getCookie('center');
		window.location = "map.jsp?point="+acenter;
		return;
	}
	while(mygeo == null) {
		if (navigator.geolocation) {
			mygeo = navigator.geolocation;
		} else if (window.google && google.gears) {
			if(google.gears) {
				var gearsObj = true;
				mygeo = google.gears.factory.create('beta.geolocation');
			}
		} else {
			//alert("Your device does not support Location Services. Please enter an address.");
			var einfo="introducir informaci\363n en la p\341gina de b\372squeda.";
					alert(einfo); 

			if(window.location.href.indexOf("search.jsp") == -1) {
				window.location = "search.jsp";
				break;
			} else {
				break;
			}
		}
	}
	if(mygeo) {
		if(gearsObj == true) {
			if(!mygeo.getPermission()) {
				//alert("You must allow this website to use Google Gears to take advantage of the GeoLocation services.");
				alert("Usted debe permitir que este sitio web use Google Gears para tomar ventaja de los servicios geolocalizaci\363n");
				if(window.location.href.indexOf("search.jsp") == -1) {
					window.location = "search.jsp";
					return false;
				} else {
					return false;
				}
			}
		}
		try {
		mygeo.getCurrentPosition(foundUserLocationMap, noLocationFound, geoLocationOptions);
		} catch(e) {
			console.log(e);
		}
	}
}

function findUserLocationList() {
	var mygeo;
	if (getCookie('bounds')) {
		var bounds = unescape(getCookie('bounds'));
		boundsArray = bounds.split("&");
		if (boundsArray.length == 4) {
			var swlat = boundsArray[0];
			var swlng = boundsArray[1];
			var nelat = boundsArray[2];
			var nelng = boundsArray[3];
			window.location = "list.jsp?"+swlat+"&"+swlng+"&"+nelat+"&"+nelng;
			return;
		}
	} else if (getCookie('center')) {
		var acenter = getCookie('center');
		centerArray = acenter.split(", ");
		if (centerArray.length == 2) {
			var lat = centerArray[0];
			var lng = centerArray[1];
			window.location = "list.jsp?lat="+lat+"&lng="+lng;
			return;
		}
	}
	while(mygeo == null) {
		if (navigator.geolocation) {
			mygeo = navigator.geolocation;
		} else if (window.google && google.gears) {
			if(google.gears) {
				var gearsObj = true;
				mygeo = google.gears.factory.create('beta.geolocation');
			}
		} else {
			//alert("Your device does not support Location Services. Please enter an address.");
			var einfo="introducir informaci\363n en la p\341gina de b\372squeda.";
					alert(einfo); 

			if(window.location.href.indexOf("search.jsp") == -1) {
				window.location = "search.jsp";
				break;
			} else {
				break;
			}
		}
	}
	if(mygeo) {
		if(gearsObj == true) {
			if(!mygeo.getPermission()) {
				//alert("You must allow this website to use Google Gears to take advantage of the GeoLocation services.");
				alert("Usted debe permitir que este sitio web use Google Gears para tomar ventaja de los servicios geolocalizaci\363n");

				if(window.location.href.indexOf("search.jsp") == -1) {
					window.location = "search.jsp";
					return false;
				} else {
					return false;
				}
			}
		}
		try {
		mygeo.getCurrentPosition(foundUserLocationList, noLocationFound, geoLocationOptions);
		} catch(e) {
			console.log(e);
		}
	}
}
	
function geolocMap() {
	var mygeo;
	while (mygeo == null) {
		if (navigator.geolocation) {
			mygeo = navigator.geolocation;
		} else if (window.google && google.gears) {
			if(google.gears) {
				var gearsObj = true;
				mygeo = google.gears.factory.create('beta.geolocation');
			}
		} else {
			//alert("Your device does not support Location Services. Please enter an address.");
			var einfo="introducir informaci\363n en la p\341gina de b\372squeda.";
					alert(einfo); 

			window.location = "search.jsp";
			return false;
		}
	}
	if(mygeo) {
		if(gearsObj == true) {
			if(!mygeo.getPermission()) {
				//alert("You must allow this website to use Google Gears to take advantage of the GeoLocation services.");
				alert("Usted debe permitir que este sitio web use Google Gears para tomar ventaja de los servicios geolocalizaci\363n");

				window.location = "search.jsp";
			}
		}
		try {
		mygeo.getCurrentPosition(foundUserLocationMap, noLocationFound, geoLocationOptions);
		} catch(e) {
			console.log(e);
		}
	}
}
	
function foundUserLocationMap(position) {
	var lat = position.coords.latitude;
	var lang = position.coords.longitude;
	var location = lat + "," + lang;
	window.location = "map.jsp?point="+location;
}

function foundUserLocationList(position) {
	var lat = position.coords.latitude;
	var lng = position.coords.longitude;
	window.location = "list.jsp?lat="+lat+"&lng="+lng;
}

function noLocationFound(error) {
	//alert(error.code);
	switch (error.code) {
		case 0:  //UNKNOWN ERROR
			//alert("There was an unknown error in the GeoLocation services software. Please enter an address.");
			alert("Existe un error desconocido en el software que presta servicios de geolocalizaci\363n. Favor introduzca una direcci\363n ");
			window.location = "search.jsp"
			//alert("Code 0: " + error.message);
			break;
		case 1: // PERMISSION DENIED
			alert("You must share your position with this website to take advantage of the GeoLocation services.");
			window.location = "search.jsp"
			//alert("Code 1: " + error.message);
			break;
		case 2: //POSITION UNAVAILABLE
			//alert("Please enter an address.");
			var einfo="introducir informaci\363n en la p\341gina de b\372squeda.";
					alert(einfo); 
			window.location = "search.jsp"
			//alert("Code 2: " + error.message);
			break;
		case 3: //TIMEOUT
			alert("Code 3: " + error.message);
			break;
		}
	//alert("Location services cannot find your location, please enter an address.");
}