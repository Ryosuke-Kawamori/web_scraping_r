retty <- read_html("https://retty.me/area/PRE01/LND/")

retty_area_html <- hokkaido %>% 
  html_nodes(xpath="//li[@class='search_line']/a") %>% html_attr("href") %>% 
  read_htmls

retty_area_html <- retty_area_html %>% 
  map(. %>% html_nodes(xpath="//ul[@class='pagination pagination-long']//a") %>% html_attr("href")) %>% 
  flatten_chr %>% 
  read_htmls %>% 
  append(., retty_area_html)


retty_landmark <- retty_area_html %>% 
  map(. %>% html_nodes(xpath="//li[@class='search_line']") %>% html_text) %>% 
  flatten_chr() 

retty_landmark <- tibble(NAME = retty_landmark)
  
#retty_lonlat <- left_join(retty_landmark, hokkaido_landmark_final)
#retty_landmark <- cbind(retty_landmark, geocode(retty_landmark$NAME))

retty_landmark <- retty_landmark %>% 
  filter(!str_detect(NAME, "保育所|保育園|幼稚園|ホテル|旅館|イン|荘|民宿|高校|大学|ゲストハウス|ペンション|専門学校|交差点|ホステル"))



  