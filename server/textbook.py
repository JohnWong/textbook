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

    for node in doc.findChildren("d"):
        title = node.findChild("t").get_text()
        page = node.findChild("l").get_text()
        if name is None:
            name = title
            continue
        link = fetchimg(indexurl, page)
        titles.append(title)
        links.append(link)
        print(title)
        pass

    data = []
    section = None
    for i in range(len(titles)):
        title = titles[i].split("<br>")
        link = links[i]
        title0 = title[0].replace("<b>", "").replace("</b>", "")
        prev = links[i-1] if i > 0 else None
        next = links[i+1] if i < len(links) - 1 else None
        if len(title) == 1:
            if re.match("\d+", title[0]):
                continue
            if section:
                section["rows"].append({
                    "title": title0,
                    "link": link,
                    "prev": prev,
                    "next": next
                })
                pass
            else:
                data.append({
                    "header": "",
                    "rows": [{
                        "title": title0,
                        "link": link,
                        "prev": prev,
                        "next": next
                    }]
                })
                pass
            pass
        else:
            section = {
                "header": title0,
                "rows": [{
                    "title": title[1],
                    "link": link,
                    "prev": prev,
                    "next": next
                }]
            }
            data.append(section)
            pass
        pass

    jsonstr = json.dumps({
        "name": name,
        "indexs": data})
    with open(filename, "w") as f:
        f.write(jsonstr)
    pass

indexurl = "http://www.pep.com.cn/xiaoyu/jiaoshi/tbjx/kbjiaocai/tb1s/index_2152.xml"
fetchbook(indexurl, "index1s.json")
