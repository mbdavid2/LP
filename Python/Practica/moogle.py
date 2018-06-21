import pickle
import util
import ast
import urllib.request
from bs4 import BeautifulSoup

# Keep track of already visited URLs
visitedURLs = []

# Database, Map: word -> [(link, name)]
db = {}

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
            pickle.dump(db, f)
            print("done")
    except Exception:
        print("Couldn't store the database")


def getLinks(url, soup):
    """
        Returns a list of urls
    """
    currentWords = []
    listURLs = []
    wordsInPage = soup.get_text()
    for word in wordsInPage.split():
        currentWords.append(word)
        if word not in db:
            db[word] = [(util.clean_words(soup.title.text), url)]
        elif word not in currentWords:
                db[word].append((util.clean_words(soup.title.text), url))
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
        if url not in visitedURLs:
            visitedURLs.append(url)
            response = urllib.request.urlopen(url)
            page = response.read()
            soup = BeautifulSoup(page, "html.parser")
            if url is None or maxdist <= 0:
                return None
            listURLs = getLinks(url, soup)
            for urlChild in listURLs:
                crawler(urlChild, maxdist-1)
        else:
            return []
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
    ans = checkURL(queryPy, db)
    return ans


def checkURL(query, db):
    if isinstance(query, list):
        ans = []
        for el in query:
            ans += checkURL(el, db)
        return ans
    elif isinstance(query, tuple):
        a, b = query
        resA = checkURL(a, db)
        resB = checkURL(b, db)
        if (resA == [] or resB == []):
            return []
        else:
            return intersection(resA, resB)
    else:
        if query in db:
            return db[query]
        else:
            return []


def intersection(listA, listB):
    res = [x for x in listA if x in listB]
    return res
