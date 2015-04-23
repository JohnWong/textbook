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
    result = response.read().decode("gb18030")
    return BeautifulSoup(result)


def fetchbook(indexurl, filename, booktitle):
    print("Book: " + indexurl)
    if os.path.isfile(filename):
        return
    lockfile = filename + ".lock"
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
        if link.find("../../../../../../../") >= 0:
            continue
        link = fetchimg(indexurl, link)

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
        # print("%s, %s" % (title, page))
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
        if listurl.find("xe/jszx/tbjxzy") < 0:
            sublisturls = [listurl]
        else:
            sublisturls = map(lambda (a, b, c): b, parseTable(listurl))
            pass

        for sublisturl in sublisturls:
            for (booktitle, href, img) in parseTable(sublisturl):
                link = href + "index_2152.xml"
                # fetch book json
                prefix = "www.pep.com.cn/"
                filename = re.search(prefix + ".*", href).group()[len(prefix):-1].replace("/", "-") + ".json"
                fetchbook(link, filename, booktitle)
                rows.append({
                    "title": booktitle.replace("《品德与生活》", "品生").replace("《品德与社会》", "品社"),
                    "link": filename,
                    "img": img
                })
                pass
            sections.append({
                "header": title + headers[i],
                "rows": rows
            })
            pass
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
        if catname == "相关教育":
            continue
        subjects = []
        for subject in node.find_all("a"):
            link = url + subject.get("href")[2:]
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
