torikizoku_top <- html_session(url = "https://sp.torikizoku.co.jp/list/")
torikizoku_ken <- follow_links(torikizoku_top, "//li[@class = 'linkBox']/a")
torikizoku_tiku <- map(torikizoku_ken, follow_links,  xpath="//li[@class = 'linkBox']/a") %>% flatten
torikizoku_tenpo <- map(torikizoku_tiku, follow_links, xpath="//li[@class = 'linkBox']/a") %>% flatten