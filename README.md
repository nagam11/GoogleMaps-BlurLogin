## Blur login maps
<img src="BlurMapsLogin.gif" width="200">

## Setup
1. Clone/Download/Fork project.
2. Create a GoogleMaps API Token using [these](https://developers.google.com/maps/documentation/ios-sdk/get-api-key) instructions.
3. Add this key in the AppDelegate class in this line. 
~~~~ 
GMSServices.provideAPIKey("Google-Maps-API-TOKEN")
