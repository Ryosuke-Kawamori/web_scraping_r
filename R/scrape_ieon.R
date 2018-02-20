ieons_html <- read_html("http://www.aeonretail.jp/shop/") %>% 
  html_nodes(xpath = "//dd/a") %>% 
  html_attr("href") %>% 
  map(read_html) 

ieons_address <- ieons_html[c(1,2,4,6)] %>% 
  map(.,function(x){x %>% html_nodes(xpath="//dd[@class = 'add sp_dd']") %>% html_text %>% str_replace_all(pattern="\n| ", replacement="")}) %>% 
  flatten_chr()
