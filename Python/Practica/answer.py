#!/usr/bin/env python3.6


import argparse
import sys
import moogle
import pprint
import util


def main():

    parser = argparse.ArgumentParser(
        description="Answer module for the µoogle project",
        epilog=moogle.authors(),
    )

    parser.add_argument("-q", "--query", type=str, help="query (use single quotes for more than one word")
    parser.add_argument("-d", "--database", type=str, help="filename of the database", default="moogle.dat")

    args = parser.parse_args(sys.argv[1:])

    db = moogle.load(args.database)
    answer = moogle.answer(db, args.query)
    pprint.pprint(answer)


if __name__ == "__main__":
    main()
