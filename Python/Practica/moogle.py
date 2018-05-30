import pickle
import util
import ast
import urllib.request
from bs4 import BeautifulSoup

## Keep track of already visited URLs
visitedURLs = []

## Database
db = []

#############################################################################
# Common part
#############################################################################


def authors():
    """Returns a string with the name of the authors of the work."""
    return "David Moreno"



#############################################################################
# Crawler
#############################################################################


def store(db, filename):
    with open(filename, "wb") as f:
        print("store", filename)
        #print(db)
        pickle.dump(db, f)
        print("done")

def getLinks(url, soup):
    """
        Returns a list of urls
    """
    listURLs = []
    newUrl = list(url)
    urlLen = len(newUrl)-1

    # urllib.parse.urljoin not workingu :/
    for i in range(0, urlLen):
        j = urlLen - i
        if (newUrl[j] != '/'):
            newUrl.pop()
        else:
            break

    newUrl = ''.join(newUrl)
    for link in soup.find_all("a"):
        listURLs.append(newUrl+link.get("href"))
    return listURLs

def crawler(url, maxdist):
    """
        Crawls the web starting from url,
        following up to maxdist links
        and returns the built database.
    """
    try:
        response = urllib.request.urlopen(url)
        page = response.read()
        soup = BeautifulSoup(page, "html.parser")
    except Exception:
        print("Crawling: Invalid URL")

    visitedURLs.append(url)
    db.append((url,util.clean_words(soup.title.text)))
    if url == None or maxdist <= 0:
        return None
    listURLs = getLinks(url, soup)
    for urlChild in listURLs:
        if not urlChild in visitedURLs:
            crawler(urlChild, maxdist-1)
    return db



#############################################################################
# Answer
#############################################################################


def load(filename):
    """Reads an object from file filename and returns it."""
    with open(filename, "rb") as f:
        print("load", filename)
        db = pickle.load(f)
        print("done")
        return db


def answer(db, query):
    """
        Returns a list of pages for the given query (a string).
        Each page is a tuple with two fields: the title and the URL.
    """
    queryPy = ast.literal_eval(query)
    # print("Query:",queryPy)
    # print("Database:",db)
    ans = []
    # This could be a parameter for checkURL but
    # it's global so the map is more readable
    global currentSoup
    for url,name in db:
        try:
            response = urllib.request.urlopen(url)
            page = response.read()
            currentSoup = BeautifulSoup(page, "html.parser")
        except Exception:
            print("Answer: Invalid URL")
        if checkURL(queryPy):
            ans.append((name,url))
    return ans

def checkURL(query):
    typeQ = str(type(query))
    if typeQ == "<class \'list\'>":
        return any (map (checkURL, query))
    elif typeQ == "<class \'tuple\'>":
        a,b = query
        return checkURL(a) and checkURL(b)
    else:
        #print("Currenttly exploring:", currentSoup.title.text, "Trying to find:", query)
        text = currentSoup.get_text()
        return query in text
