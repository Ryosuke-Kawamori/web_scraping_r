retrip <- html_session("https://retrip.jp/articles/4532/")

places <- retrip %>%  html_nodes(xpath="//*[@class='expSpotContent']") %>% html_text()

for(i in 1:8){
retrip <- retrip %>% 
  follow_link(xpath="//*[@class='next']")
places <- c(places, retrip %>% html_nodes(xpath="//*[@class='expSpotContent']") %>% html_text())
}
