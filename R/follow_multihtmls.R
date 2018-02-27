follow_links <- function(session, xpath){
  session_len <- session %>% html_nodes(xpath=xpath) %>% seq_along()
  duration <- rexp(n=session_len, rate=1)
  session_len %>% map(., function(i){
    Sys.sleep(duration[i])
    follow_link(session, xpath=xpath, i=i)})
}
read_htmls <- function(urls){
  map(urls, read_html)
}