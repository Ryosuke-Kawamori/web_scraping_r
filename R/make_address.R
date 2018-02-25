zipfiles <- list.files("/Users/ryosuke/Kyoto/KTN研究/real_estate/data/loglat", recursive = T, full.names = TRUE)
loglatfiles <- list.files("/Users/ryosuke/Kyoto/KTN研究/real_estate/data/loglat_unziped/", full.names = TRUE, recursive = TRUE) %>% 
  str_extract_all(pattern=".*\\.csv$") %>% 
  flatten_chr() 

hokkaido_address <- read_csv(loglatfiles[1], locale=locale(encoding = "shift-jis"))

#jp_map <- read_sf("/Users/ryosuke/Kyoto/KTN研究/real_estate/data/japan_ver81/japan_ver81.shp")

hokkaido_address <- hokkaido_address %>% 
  mutate(住所=paste(都道府県名, 市区町村名, chartr(old="一二三四五六七八九", new="１２３４５６７８９", 大字町丁目名), sep="")) 
