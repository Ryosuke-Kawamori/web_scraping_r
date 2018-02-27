gooday <- read_html("http://www.visit-hokkaido.jp/spot/search?area%5B0%5D=1&area%5B1%5D=2&area%5B2%5D=3&area%5B3%5D=4&area%5B4%5D=5&area%5B5%5D=6&area%5B6%5D=7&area%5B7%5D=8&area%5B8%5D=9&area%5B9%5D=10&area%5B10%5D=11&area%5B11%5D=12&p=1")

gooday_html <- gooday %>% 
  html_nodes(xpath="//a[@class='page_link']") %>% html_attr("href") %>% 
  read_htmls

gooday_df <- gooday_html %>%
  map(.,function(one_page){
    
tibble(EVE = one_page %>% html_nodes(xpath="//dl[@class='event_card']") %>% 
  html_nodes(xpath="//dt") %>% html_text %>% .[c(-1,-22)] %>% str_replace_all("\t|\n", ""),

  DATE = one_page %>% html_nodes(xpath="//dl[@class='event_card']") %>% 
    html_nodes(xpath="//span[@class='event_date']") %>% html_text %>% str_replace_all("\t|\n", ""),
  
  LOC = one_page %>% html_nodes(xpath="//dl[@class='event_card']") %>% 
    html_nodes(xpath="//span[@class='event_location']") %>% html_text %>% str_replace_all("\t|\n", ""),
  
  HOUR = one_page %>% html_nodes(xpath="//dl[@class='event_card']") %>% 
    html_nodes(xpath="//span[@class='event_hour']") %>% html_text %>% str_replace_all("\t|\n", "")
  )
}) %>% 
  bind_rows() %>% 
  mutate(EVE = str_replace_all(EVE, ".*エリア", ""))

lonlat <- geocode(gooday_df$EVE)
gooday_df <- cbind(gooday_df, lonlat)
na_lon <- gooday_df %>% 
  filter(is.na(lon))
syusei <- cbind(gooday_df %>% filter(is.na(lon)) %>% select(-lon, -lat), na_lon) 

gooday_df <- left_join(gooday_df, syusei, by=c("EVE", "DATE", "LOC", "HOUR"))

gooday_df <- gooday_df %>% 
  mutate(lon = if_else(!is.na(lon.x), lon.x, lon.y)) %>% 
  mutate(lat = if_else(!is.na(lat.x), lat.x, lat.y)) %>% 
  select(-lon.x,-lon.y,-lat.x,-lat.y)

m <- gooday_df %>% 
  leaflet() %>% 
  #addTiles() %>% 
  addProviderTiles(providers$OpenStreetMap) %>% 
  addCircleMarkers() %>% 
  addPopups(popup=~paste0("<img src = ", "/Users/ryosuke/Pictures/kawamori.jpg", ' hegiht="30%" width="30%">')) 

saveWidget(m, file="map.html")
