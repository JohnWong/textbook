# -*- coding: utf-8 -*-
import urllib2
import re
from bs4 import BeautifulSoup
import json
import sys

reload(sys)
sys.setdefaultencoding("utf-8")


def replaceurl(url, subfix):
    index = url.rindex("/")
    return url[:index] + subfix[1:]


def fetchimg(indexurl, pageurl):
    url = replaceurl(indexurl, pageurl)
    doc = requesturl(url)
    img = doc.find("img")
    if img:
        src = img.get("src")
        return replaceurl(url, src)
    return ""


def requesturl(url):
    request = urllib2.Request(url)
    response = urllib2.urlopen(request)
    result = response.read().decode("gbk")
    return BeautifulSoup(result)


def fetchbook(indexurl, filename):
    doc = requesturl(indexurl).recs.documents
    name = None
    pages = []

    for node in doc.findChildren("d"):
        titlesplit = node.findChild("t").get_text().split("<br>")
        if name is None:
            name = titlesplit[0].replace("义务教育课程标准实验教科书　", "").replace(" ", "").replace("　", " ")
            continue
        if len(titlesplit) == 2:
            pages.append({
                "title": titlesplit[0],
                "page": 0,
                "link": ""
            })
            title = titlesplit[1]
            pass
        else:
            title = titlesplit[0]
            pass
        link = node.findChild("l").get_text()
        link = fetchimg(indexurl, link)

        backward = 1 if len(titlesplit) == 1 else 2
        if re.match("\d+", title):
            page = int(title)
        else:
            page = pages[len(pages) - backward]["page"] + 1 if len(pages) > 0 and pages[len(pages) - backward]["page"] else 0

        pages.append({
            "title": title,
            "link": link,
            "page": page
        })
        print("%s, %s" % (title, page))
        pass

    jsonstr = json.dumps({
        "name": name,
        "pages": pages
    })
    with open(filename, "w") as f:
        f.write(jsonstr)
    pass

indexurl = "http://www.pep.com.cn/xiaoyu/jiaoshi/tbjx/kbjiaocai/tb1s/index_2152.xml"
fetchbook(indexurl, "index1s.json")
