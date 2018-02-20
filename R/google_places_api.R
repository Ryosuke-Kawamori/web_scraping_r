google_place_api <- function(lon,lat,radius,types,key="AIzaSyAVs1m2rgzpRuOZUJKyF3cVJOsQoUWMHNI",...){
  paste0("https://maps.googleapis.com/maps/api/place/nearbysearch/json?",
         "location=", lat, ",", lon, 
         "&radius=", radius,
         "&types=", types,
         "&language=ja",
         "&key=", key,
         sep="") %>% 
    jsonlite::fromJSON(., ...)
}
