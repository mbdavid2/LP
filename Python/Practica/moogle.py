import pickle
import urllib.request
from bs4 import BeautifulSoup

visitedURLs = []

#############################################################################
# Common part
#############################################################################


def authors():
    """Returns a string with the name of the authors of the work."""
    return "David Moreno Borràs"



#############################################################################
# Crawler
#############################################################################


def store(db, filename):
    with open(filename, "wb") as f:
        print("store", filename)
        pickle.dump(db, f)
        print("done")

def getLink(url):
    response = urllib.request.urlopen(url)
    page = response.read()
    soup = BeautifulSoup(page, "html.parser")
    ## print(soup.title.text)
    ## print(soup.get_text())
    listURLs = []
    newUrl = list(url)
    urlLen = len(newUrl)-1
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
    print("Holita: ", url)
    visitedURLs.append(url)
    if maxdist <= 0:
        return None
    listURLs = getLink(url)
    for urlChild in listURLs:
        if not urlChild in visitedURLs:
            crawler(urlChild, maxdist-1)
    return None



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

    ### Please implement this function as efficiently as possible

    return []
