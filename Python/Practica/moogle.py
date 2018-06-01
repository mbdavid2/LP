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
    try:
        with open(filename, "wb") as f:
            print("store", filename)
            # print(db)
            pickle.dump(db, f)
            print("done")
    except Exception:
        print("Couldn't store the database")

def getLinks(url, soup):
    """
        Returns a list of urls
    """
    listURLs = []
    for link in soup.find_all("a"):
        newUrl = urllib.parse.urljoin(url, link.get("href"))
        listURLs.append(newUrl)
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
        visitedURLs.append(url)
        db.append((url,util.clean_words(soup.title.text)))
        if url == None or maxdist <= 0:
            return None
        listURLs = getLinks(url, soup)
        for urlChild in listURLs:
            if not urlChild in visitedURLs:
                crawler(urlChild, maxdist-1)
    except Exception:
        print("Crawling: Invalid URL", url)
    return db



#############################################################################
# Answer
#############################################################################


def load(filename):
    """Reads an object from file filename and returns it."""
    try:
        with open(filename, "rb") as f:
            print("load", filename)
            db = pickle.load(f)
            print("done")
    except Exception:
        print("Couldn't load the database")
    return db


def answer(db, query):
    """
        Returns a list of pages for the given query (a string).
        Each page is a tuple with two fields: the title and the URL.
    """
    queryPy = ast.literal_eval(query)
    ans = []
    # This could be a parameter for checkURL but
    # it's global so the map is more readable
    global currentSoup
    for url,name in db:
        try:
            response = urllib.request.urlopen(url)
            page = response.read()
            currentSoup = BeautifulSoup(page, "html.parser")
            if checkURL(queryPy):
                ans.append((name,url))
        except Exception:
            print("Answer: Invalid URL")
    return ans

def checkURL(query):
    typeQ = str(type(query))
    if isinstance(query, list):
        return any (map (checkURL, query))
    elif isinstance(query, tuple):
        a,b = query
        return checkURL(a) and checkURL(b)
    else:
        text = currentSoup.get_text()
        return query in text