#!/usr/bin/env python
"""
    See https://xkcd.com/936/ for why you might want to generate these
    passphrases.

    Does require /usr/share/dict/words to be a file with words on
    multiple lines. On Debian derived OS like Ubuntu install wbritish-insane
    package and `sudo select-default-wordlist` to set it as the default.
"""

import random
import re
import sys



def randomWords(num=4, dictionaryfile="/usr/share/dict/words"):
    r = random.SystemRandom() # i.e. preferably not pseudo-random
    f = open(dictionaryfile, "r")
    chosen = []
    wordlist = []
    prog = re.compile("^[a-z]{5,9}$") # reasonable length, no proper nouns
    if(f):
        for word in f:
            if(prog.match(word)):
                wordlist.append(word)
        # Not sure how python calculates length, im assuming 32bits of mem vs
        # counting it evry time is a good trade.
        wordlistlen = len(wordlist)
        for i in range(num):
            word = wordlist[r.randint(0,wordlistlen)]
            chosen.append(word.strip())
    return chosen


if __name__ == "__main__":
    num = 4
    if (len(sys.argv) > 1 and str.isdigit(sys.argv[1])):
        num = int(sys.argv[1])

    print ".".join(randomWords(num))
