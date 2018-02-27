
kansuuji <- function(x) {
  # 漢字から数値へのマッピング
  # 万未満の位
  map_low <- c(
    〇 = 0, 一 = 1, 二 = 2, 三 = 3, 四 = 4,
    五 = 5, 六 = 6, 七 = 7, 八 = 8, 九 = 9,
    十 = 10, 百 = 100, 千 = 1000
  )
  # 万以上の位
  map_up <- c(
    万 = 1e4, 億 = 1e8, 兆 = 1e12
  )
  # 全部
  map_all <- c(map_low, map_up)
  
  # (?<=(十|百|千)) みたいな桁の境界で分割する正規表現を作る
  pattern_low <- sprintf("(?<=(%s))", paste(names(map_low)[map_low >= 10], collapse = "|"))
  pattern_up <- sprintf("(?<=(%s))", paste(names(map_up), collapse = "|"))
  # 万以上の位で分解したときに末尾に位を表す文字がくるのでそれにマッチするパターン
  pattern_digit <- sprintf("(.*)(%s)$", paste(names(map_up), collapse = "|"))
  
  # 万以上の位で分解
  # e.g. "十二億九千六百万千三十三" => ("十二億", "九千六百万", "千三十三")
  numbers <- strsplit(x, pattern_up, perl = TRUE)
  # 位のマッピング
  # e.g. ("十二億", "九千六百万", "千三十三")
  #      => ("億" = ("十二"), "万" = ("九千六百"), "一"  = ("千三十三"))
  numbers <- lapply(numbers, function(n) {
    # USE.NAMES = FALSE にして名前を明示的に位にする
    sapply(n, USE.NAMES = FALSE, function(k) {
      m <- regexpr(pattern_digit, k, perl = TRUE)
      if (m == -1) {
        # 万未満の場合は「一」の位とする
        structure(k, names = "一")
      } else {
        start <- attr(m, "capture.start")
        length <- attr(m, "capture.length")
        value <- substr(k, start[1], start[1] + length[1] - 1)
        digit <- substr(k, start[2], start[2] + length[2] - 1)
        structure(value, names = digit)
      }
    })
  })
  # 万未満の桁分解
  numbers <- lapply(numbers, function(n) strsplit(n, pattern_low, perl = TRUE))
  
  # 数値変換
  sapply(numbers, function(n) {
    # 万未満の数値化
    values <- sapply(n, function(d) {
      # 文字分解
      # e.g. "三十" => ("三", "十")
      char <- strsplit(d, "")
      # 各文字をマッピングに従って数値に変換して積を求める
      # e.g. ("三", "十") => 3 * 10 = 30
      values <- sapply(char, function(v) prod(map_low[v]))
      # あとは足せば完了
      sum(values)
    })
    # 万以上の位の数値化
    # 一の位があるので map_up ではなく map_all を使う
    digits <- map_all[names(n)]
    # 位合わせ
    crossprod(values, digits)
  })
}


replace_kansuji <- function(strs){
  olds <- str_extract_all(strs, "[一二三四五六七八九十]+") %>% 
    map(function(strvec){
      strvec %>% 
        map(function(str){paste0("[^一二三四五六七八九十]+", str, "[^一二三四五六七八九十]+")})})
  news <- str_extract_all(strs, "[一二三四五六七八九十]+") %>% map(function(x){as.character(kansuuji(x))}) 
  new_x <- pmap(list(strs=strs, olds=olds, news=news), 
                function(strs,olds,news){
#                  print(strs)
  #                print(olds)
    #              print(news)
                  str <- strs
                  print(strs)
                  for(i in seq_along(olds)){
#                    print(strs)
#                    print(olds[[i]])
#                    print(news[[i]])
                    str <- str_replace(string = str, pattern=olds[[i]], replacement = news[[i]])
                    print(str)
                  }
                  return(str)
                })
}