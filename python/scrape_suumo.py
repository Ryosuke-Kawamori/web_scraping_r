from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.phantomjs.webdriver import WebDriver
from selenium.webdriver.common.action_chains  import ActionChains
import numpy as np
import numpy.random as rd
import pandas as pd
import time

driver = webdriver.Chrome('/usr/local/bin/chromedriver')
#driver = WebDriver('/usr/local/bin/phantomjs')
#スクレイピングしたい住宅情報一覧の開始ページ
driver.get("http://suumo.jp/jj/chintai/ichiran/FR301FC005/?shkr1=03&cb=0.0&shkr3=03&shkr2=03&rn=2080&ts=1&ts=2&smk=&mt=9999999&ar=060&bs=040&shkr4=03&ct=9999999&ra=027&cn=9999999&mb=0&fw2=&et=9999999&ae=20801")
house_df = pd.DataFrame(columns=[0,1,2,3,4])

for j in range(100000):
    print(str(j)+"ページ目")
    details = driver.find_elements_by_css_selector("a.js-cassetLinkHref")
    for (i, detail) in enumerate(details):
        print(i)
        try:
            actions = ActionChains(driver)
            actions.move_to_element(detail).perform()
            time.sleep(rd.exponential(1, size=1))
            time.sleep(1)
        except:
            print("スクロールすること能わず。")
        #driver.execute_script("arguments[0].scrollIntoView();", detail)
        try:
            detail.click()
            WebDriverWait(driver, 2).until(lambda d: len(d.window_handles) > 1)
            handles = driver.window_handles
            driver.switch_to.window(handles[1])

            try:
                detail = driver.find_element_by_css_selector("div.detailinfo").text
                moyori = driver.find_element_by_css_selector("div.detailnote-value-list").text
                point = driver.find_element_by_css_selector("div.cassettepoint-desc").text
                facility = driver.find_element_by_css_selector("div.bgc-wht.ol-g").text
                gaiyou = driver.find_element_by_css_selector("table.data_table.table_gaiyou").text

                house = pd.DataFrame([detail, moyori, point, facility, gaiyou]).T
                house_df = pd.concat([house_df, house], ignore_index=True)
            except:
                print("詳細の形式がいつものタイプではない。")
                pass

            driver.close()
            driver.switch_to.window(handles[0])

        except:
            print("クリックすること能わず。")
    try:
        time.sleep(rd.exponential(1, size=1))
        time.sleep(2)
        tugihe = driver.find_element_by_link_text(u"次へ")
        actions = ActionChains(driver)
        actions.move_to_element(tugihe).perform()
        tugihe.click()
        print("次のページへ")
    except:
        print("全ページ回った")
        break
house_df.to_csv("house_df_9_.csv", sep=",")
#driver.quit()
