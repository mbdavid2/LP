def differentElems(l):
    visited = []
    diffElems = 0
    for x in l:
        if not (x in visited):
            diffElems += 1
            visited.append(x)
    return diffElems

def maxList(l):
    return max(l)

def average(l):
    return sum(l)/len(l)

def flatten(l):
    from functools import reduce
    if isinstance(l, int):
        return [l]
    return list(reduce(lambda l1,l2: l1 + flatten(l2), l, []))

l = list([1,[2],[3,4,[5]]])
# eval executa lo de dins
# si es print fa print, etc....
# si es una llista, l'execucio es una llista
# pero eval es perillos! :O
# s = eval(input())
# s = input()
# numbers = list(map(int, s.split()))
#print(differentElems(numbers))
#print(maxList(numbers))
