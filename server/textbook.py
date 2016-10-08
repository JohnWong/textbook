#! /usr/bin/env python
# -*- coding: utf-8 -*-
import urllib2
import re
from bs4 import BeautifulSoup
import json
import sys
import os
import HTMLParser

reload(sys)
sys.setdefaultencoding("utf-8")


htmlparser = HTMLParser.HTMLParser()


def replaceurl(url, subfix):
    index = url.rindex("/")
    if subfix.startswith("/"):
        return "http://www.pep.com.cn" + subfix
    else:
        return url[:index] + subfix[1:]


def fetchimg(indexurl, pageurl):
    url = replaceurl(indexurl, pageurl)
    doc = requesturl(url)
    img = doc.find("img")
    if img:
        src = img.get("src")
        return replaceurl(url, src)
    return ""


def requesturl(url, encoding="gb18030"):
    print(url, encoding)
    request = urllib2.Request(url)
    response = urllib2.urlopen(request)
    content = response.read()
    try:
        result = content.decode(encoding)
        pass
    except Exception, e:
        result = content.decode("gbk")
        raise
    else:
        pass
    finally:
        pass
    return BeautifulSoup(result, "html.parser")


def fetchbook(indexurl, filename, booktitle):
    print("Book: " + indexurl)
    if os.path.isfile(filename):
        return
    lockfile = filename + ".lock"
    if os.path.isfile(lockfile):
        return
    with open(lockfile, "w") as f:
        f.write("")
    doc = requesturl(indexurl).recs.documents
    isfirst = True
    pages = []

    for node in doc.findChildren("d"):
        text = node.findChild("t").get_text()
        titlesplit = text.split("<br>") if text.find("<br>") >= 0 else text.split("</br>")
        if isfirst:
            isfirst = False
            if titlesplit[0] != "扉页":
                continue
            pass
        if len(titlesplit) == 2:
            pages.append({
                "title": htmlparser.unescape(titlesplit[0]),
                "page": 0,
                "link": ""
            })
            title = titlesplit[1]
            pass
        else:
            title = titlesplit[0]
            pass
        link = node.findChild("l").get_text()
        # see http://www.pep.com.cn/xe/jszx/tbjxzy/ltyy/ltw/dzkb/200703/t20070314_334538.htm
        if link.find("../../../../..") >= 0:
            continue
        link = fetchimg(indexurl, link)
        if link.find("../../../../..") >= 0:
            continue
        
        backward = 1 if len(titlesplit) == 1 else 2
        print(title)
        if re.match("^\d+$", title):
            page = int(title)
        else:
            page = pages[len(pages) - backward]["page"] + 1 if len(pages) > 0 and pages[len(pages) - backward]["page"] else 0

        pages.append({
            "title": htmlparser.unescape(title),
            "link": link,
            "page": page
        })
        pass

    jsonstr = json.dumps({
        "name": booktitle,
        "pages": pages
    })
    with open(filename, "w") as f:
        f.write(jsonstr)
    os.remove(lockfile)
    pass


def parseTable(listurl):
    # 部分页面没有课本列表的按钮，需要手动拼接
    if listurl.find("sxpd/js/tbjx/jsys") >= 0 or \
            listurl.find("ce/czyy/tbjxzy") >= 0 or\
            listurl.find("tiyu/jszx123/tbjxzy123") >= 0 or \
            listurl.find("sxzz/js/tbjx/kb/jsys") >= 0 or \
            listurl.find("gzhx/gzhxjs/0pl/kb/dzkb") >= 0 or \
            listurl.find("gzhx/gzhxjs/0pl/kb/jsys") >= 0 or \
            listurl.find("sxzz/js/tbjx/kb/jsys") >= 0 or \
            listurl.find("gzls/js/tbjx/kb/jsys") >= 0:
        listurl = listurl[:listurl[:-1].rindex("/") + 1]
    elif listurl.find("czls/js/tbjx") >= 0:
        listurl = "http://www.pep.com.cn/czls/js/tbjx/jsys/"
        pass

    doc = requesturl(listurl)
    ret = []
    for node in doc.find("table").find_all("td"):
        span = node.find("span")
        if not span:
            continue
        booktitle = span.find("a").get_text()
        href = listurl + span.find("a").get("href")[2:]
        img = listurl + node.find("img").get("src")[2:] if node.find("img") else ""
        ret.append((
            booktitle,
            href,
            img
        ))
    return ret


def fetchsubject(url, title):
    if url == 'http://xiaoyu.pep.com.cn/':
        url = 'http://www.pep.com.cn/xiaoyu/'
        pass
    print("Subject: " + url)
    doc = requesturl(url)
    headers = []
    listurls = []
    sections = []

    for keyword in ["电子课本", "教师用书", "简谱课本", "线谱课本"]:
        kb = doc.find("a", text=keyword)
        if kb:
            headers.append(keyword)
            listurls.append(kb.get("href")[2:])
            pass
        pass

    if len(headers) == 0:
        print("Not found: %s" % url)
        pass

    for i in range(len(listurls)):
        listurl = url + listurls[i]
        rows = []
        # 小学英语课本列表两层嵌套
        if listurl.find("xe/jszx/tbjxzy") < 0:
            sublisturls = [listurl]
            subheaders = [headers[i]]
        else:
            subitems = parseTable(listurl)
            sublisturls = map(lambda (a, b, c): b, subitems)
            subheaders = map(lambda (a, b, c): headers[i] + "-" + a, subitems)
            pass

        for j in range(len(sublisturls)):
            sublisturl = sublisturls[j]

            for (booktitle, href, img) in parseTable(sublisturl):
                if href.find("sxpd/js/tbjx/jsys/") >= 0 or \
                        href.find("czls/js/tbjx/jsys") >= 0 or \
                        href.find("sxzz/js/tbjx/kb/jsys") >= 0 or \
                        href.find("gzls/js/tbjx/kb/jsys") >= 0:
                    link = href + "index_2151.xml"
                else:
                    link = href + "index_2152.xml"
                    pass
                # fetch book json
                prefix = "www.pep.com.cn/"
                filename = re.search(prefix + ".*", href).group()[len(prefix):-1].replace("/", "-") + ".json"
                booktitle = booktitle.replace("《品德与生活》", "品生").replace("《品德与社会》", "品社").replace("新疆教材语文一年级上册教师用书", "新疆一年级上册")
                fetchbook(link, filename, booktitle)
                rows.append({
                    "title": booktitle,
                    "link": filename,
                    "img": img
                })
                pass
            if len(rows) >= 0: # TODO > 0
                sections.append({
                    "header": title + "-" + subheaders[j],
                    "rows": rows
                })
                pass
            pass
        pass
    return sections


def fetchindex(filename):
    url = "http://www1.pep.com.cn/rjwgw/"
    doc = requesturl(url, encoding="utf-8")
    cates = []
    xkdh = doc.find(class_="main1_bg")
    for node in xkdh.find_all("li"):
        catdiv = node.find("h2")
        if not catdiv:
            continue
        catname = catdiv.get_text().replace(" ", "")
        if catname == "相关教育" or catname == "职业教育":
            continue
        subjects = []
        for subject in node.find_all("a"):
            link = subject.get("href");
            title = subject.get_text()
            for sub in fetchsubject(link, title):
                subjects.append(sub)
            pass
        cates.append({
            "name": catname,
            "items": subjects
        })
        pass

    jsonstr = json.dumps({
        "cates": cates
    })
    with open(filename, "w") as f:
        f.write(jsonstr)
    print("Index Done!")
    pass


if __name__ == '__main__':
    # indexurl = "http://www.pep.com.cn/pdysh/jszx/tbjxzy/dzkb/pdysh2x/index_2152.xml"
    # fetchbook(indexurl, "indexs.json")
    fetchindex("index.json")
