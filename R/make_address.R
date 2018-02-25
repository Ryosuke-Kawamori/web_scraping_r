zipfiles <- list.files("/Users/ryosuke/Kyoto/KTN研究/real_estate/data/loglat", recursive = T, full.names = TRUE)
loglatfiles <- list.files("/Users/ryosuke/Kyoto/KTN研究/real_estate/data/loglat_unziped/", full.names = TRUE, recursive = TRUE) %>% 
  str_extract_all(pattern=".*\\.csv$") %>% 
  flatten_chr() 

hokkaido_address <- read_csv(loglatfiles[1], locale=locale(encoding = "shift-jis"))

#jp_map <- read_sf("/Users/ryosuke/Kyoto/KTN研究/real_estate/data/japan_ver81/japan_ver81.shp")

hokkaido_address <- hokkaido_address %>% 
  mutate(住所=paste0(都道府県名, 市区町村名, 大字町丁目名, sep="")) %>% 
  mutate(住所=chartr(x=住所, old="一二三四五六七八九", new="123456789")) %>% 
  mutate(住所=str_replace_all(住所, "[^123456789]十丁目", "10丁目")) %>% 
  mutate(住所=str_replace_all(住所, "[^123456789]十1丁目", "11丁目")) %>% 
  mutate(住所=str_replace_all(住所, "[^123456789]十2丁目", "12丁目")) %>% 
  mutate(住所=str_replace_all(住所, "[^123456789]十3丁目", "13丁目")) %>% 
  mutate(住所=str_replace_all(住所, "[^123456789]十4丁目", "14丁目")) %>% 
  mutate(住所=str_replace_all(住所, "[^123456789]十5丁目", "15丁目")) %>% 
  mutate(住所=str_replace_all(住所, "[^123456789]十6丁目", "16丁目")) %>% 
  mutate(住所=str_replace_all(住所, "[^123456789]十7丁目", "17丁目")) %>% 
  mutate(住所=str_replace_all(住所, "[^123456789]十8丁目", "18丁目")) %>% 
  mutate(住所=str_replace_all(住所, "[^123456789]十9丁目", "19丁目")) %>% 
  mutate(住所=str_replace_all(住所, "2十丁目", "20丁目")) %>% 
  mutate(住所=str_replace_all(住所, "2十1丁目", "21丁目")) %>% 
  mutate(住所=str_replace_all(住所, "2十2丁目", "22丁目")) %>% 
  mutate(住所=str_replace_all(住所, "2十3丁目", "23丁目")) %>%
  mutate(住所=str_replace_all(住所, "2十4丁目", "24丁目")) %>% 
  mutate(住所=str_replace_all(住所, "2十5丁目", "25丁目")) %>% 
  mutate(住所=str_replace_all(住所, "2十6丁目", "26丁目")) %>% 
  mutate(住所=str_replace_all(住所, "2十7丁目", "27丁目")) %>% 
  mutate(住所=str_replace_all(住所, "2十8丁目", "28丁目")) %>% 
  mutate(住所=str_replace_all(住所, "2十9丁目", "29丁目")) %>% 
  mutate(住所=str_replace_all(住所, "3十丁目", "30丁目")) %>% 
  mutate(住所=str_replace_all(住所, "3十1丁目", "31丁目")) %>% 
  mutate(住所=str_replace_all(住所, "3十2丁目", "32丁目")) %>% 
  mutate(住所=str_replace_all(住所, "3十3丁目", "33丁目")) %>% 
  mutate(住所=str_replace_all(住所, "3十4丁目", "34丁目")) %>% 
  mutate(住所=str_replace_all(住所, "3十5丁目", "35丁目")) %>% 
  mutate(住所=str_replace_all(住所, "3十6丁目", "36丁目")) %>% 
  mutate(住所=str_replace_all(住所, "3十7丁目", "37丁目")) %>% 
  mutate(住所=str_replace_all(住所, "3十8丁目", "38丁目")) %>% 
  mutate(住所=str_replace_all(住所, "3十9丁目", "39丁目")) 


