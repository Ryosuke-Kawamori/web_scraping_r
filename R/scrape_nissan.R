nissan <- read_html("https://www.nissan-global.com/JP/COMPANY/PROFILE/ESTABLISHMENT/")

nissan_address <- nissan %>% 
  html_nodes(xpath = "//div[@class = 'tableBlock']/table") %>% 
  html_table %>% 
  map(function(x){x[1,2]}) %>% 
  flatten_chr()
  