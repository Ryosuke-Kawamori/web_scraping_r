#環状線沿線の賃貸物件
html <- "https://suumo.jp/jj/chintai/ichiran/FR301FC001/?ar=060&bs=040&ra=027&rn=2415&cb=0.0&ct=9999999&mb=0&mt=9999999&et=9999999&cn=9999999&shkr1=03&shkr2=03&shkr3=03&shkr4=03&sngz=&po1=12"
#まずは1ページめを読み込み
simple <- read_html(html)

#ページ数
page_num <- simple%>% 
  html_nodes(xpath="//ol[@class = 'pagination-parts']//li/a") %>% 
  html_text %>% 
  tail(1) %>% 
  as.numeric 

urls <- c()
next_url <- html
duration <- rexp(page_num, rate=1)

#まずは賃貸詳細ページのurlを集める
#for(i in 1:(page_num-1)){
for(i in 1:3){
  print(i)
  page <- read_html(next_url)
  
  urls <- page %>% 
    html_nodes(xpath="//div//td[@class = 'ui-text--midium ui-text--bold']") %>% 
    html_children() %>% 
    html_attr(name="href") %>% 
    paste("http://suumo.jp", ., sep="") %>% 
    c(.,urls)
  
  next_url <- page %>% 
    html_nodes(xpath="//p[@class = 'pagination-parts']") %>% 
    html_nodes("a") %>% 
    html_attr("href") %>% 
    tail(1) %>% 
    paste0("http://suumo.jp", ., collapse="")

  Sys.sleep(duration[i])
}


#各賃貸詳細ページから情報を集める
duration <- rexp(length(urls), rate=1)
suumo_df <- map2(urls, seq_along(urls), function(url,i){
  
  print(paste("reading", i, "th url"))
  
  #もしページの読み込みに失敗した場合はループを終了
  detail_page <- tryCatch(read_html(url),
                          error = function(e){'empty page'})
  
  if(detail_page[1] == "empty page"){
    print(paste("error loading", i ,"th url"))
    return(tibble(info="NA", moyori="NA", sentence="NA", tokutyou="NA", gaiyou="NA"))
    
  }else{
    
  detailinfo <- detail_page %>% 
    html_nodes(xpath="//div[@class = 'detailinfo']//tr") %>% 
    html_text()
  
  moyori <- detail_page %>% 
    html_nodes(xpath="//div[@class = 'detailnote-value']") %>% 
    html_text
  
  sentence <- detail_page %>% 
    html_nodes(xpath="//div[@class = 'cassettepoint-desc']") %>% 
    html_text
  
  tokutyou <- detail_page %>% 
    html_nodes(xpath="//ul[@class = 'inline_list']") %>% 
    html_text
  
  gaiyou <- detail_page %>% 
    html_nodes(xpath="//table[@class = 'data_table table_gaiyou']") %>% 
    html_text

  #一秒待機ルール（指数分布待機）
  Sys.sleep(duration[i])
  return(tibble(info=detailinfo, moyori=moyori, sentence=sentence, tokutyou=tokutyou, gaiyou=gaiyou))
  }
  
}) %>% 
  bind_rows()


