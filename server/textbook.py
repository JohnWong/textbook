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
    result = response.read()#.decode("gbk")
    return BeautifulSoup(result)


def fetchbook(indexurl, filename):
    print("Book: " + indexurl)
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
        # print("%s, %s" % (title, page))
        pass

    jsonstr = json.dumps({
        "name": name,
        "pages": pages
    })
    with open(filename, "w") as f:
        f.write(jsonstr)
    pass


def fetchsubject(url):
    print("Subject: " + url)
    doc = requesturl(url)
    headers = []
    listurls = []
    sections = []

    for keyword in ["电子课本", "简谱课本", "线谱课本"]:
        kb = doc.find("a", text=keyword)
        if kb:
            headers.append("电子课本")
            listurls.append(url + kb.get("href")[2:])
        pass

    for i in range(len(listurls)):
        doc = requesturl(listurls[i])
        rows = []
        for node in doc.find("table").find_all("td"):
            span = node.find("span")
            if not span:
                continue
            title = span.find("a").get_text()
            href = span.find("a").get("href")[2:]
            link = url + href + "index_2152.xml"
            img = url + node.find("img").get("src")[2:]
            # fetch book josn
            prefix = "www.pep.com.cn/"
            filename = re.search(prefix + ".*", url + href).group()[len(prefix):-1].replace("/", "-")
            print(filename)
            fetchbook(link, filename)

            rows.append({
                "title": title,
                "link": filename,
                "img": img
            })

        sections.append({
            "header": headers[i],
            "rows": rows
        })
        pass
    return sections


def fetchindex(filename):
    url = "http://www.pep.com.cn/"
    doc = requesturl(url)
    cates = []
    xkdh = doc.find(id="xkdh")
    for node in xkdh.find_all("td"):
        catdiv = node.find(class_="darkgreen")
        if not catdiv:
            continue
        catname = node.find(class_="darkgreen").get_text().replace(" ", "")
        subjects = []
        for subject in node.find_all("a"):
            link = url + subject.get("href")[2:]
            subjects.append(fetchsubject(link))
            pass
        cates.append({
            "header": catname,
            "rows": subjects
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
    # indexurl = "http://www.pep.com.cn/xiaoyu/jiaoshi/tbjx/kbjiaocai/tb1s/index_2152.xml"
    # fetchbook(indexurl, "index1s.json")
    fetchindex("index.json")
