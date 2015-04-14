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
    titles = []
    links = []
    pages = []

    for node in doc.findChildren("d"):
        title = node.findChild("t").get_text()
        link = node.findChild("l").get_text()
        if name is None:
            name = title
            continue
        link = fetchimg(indexurl, link)
        titles.append(title)
        links.append(link)
        if re.match("\d+", title):
            page = int(title)
        else:
            page = pages[len(pages) - 1] + 1 if len(pages) > 0 and pages[len(pages) - 1] > 0 else 0
        pages.append(page)
        print("%s, %s" % (title, page))
        pass

    data = []
    section = None
    for i in range(len(titles)):
        titlesplit = titles[i].split("<br>")
        title0 = titlesplit[0].replace("<b>", "").replace("</b>", "")
        title = title0 if len(titlesplit) == 1 else titlesplit[1]
        item = {
            "title": title,
            "link": links[i],
            "page": pages[i]
        }
        if len(titlesplit) == 1:
            if re.match("\d+", titlesplit[0]):
                continue
            if section:
                section["rows"].append(item)
                pass
            else:
                data.append({
                    "header": "",
                    "rows": [item]
                })
                pass
            pass
        else:
            section = {
                "header": title0,
                "rows": [item]
            }
            data.append(section)
            pass
        pass

    jsonstr = json.dumps({
        "name": name,
        "index": data})
    with open(filename, "w") as f:
        f.write(jsonstr)
    pass

indexurl = "http://www.pep.com.cn/xiaoyu/jiaoshi/tbjx/kbjiaocai/tb1s/index_2152.xml"
fetchbook(indexurl, "index1s.json")
