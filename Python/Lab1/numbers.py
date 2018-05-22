import math
def absValue(x):
    if (x < 0): 
        return -x
    else: 
        return x

def power(x,n):
    if (n == 0): return 1;
    else: return x*power(x,n-1)

def has2Divs(i,n):
  if (i*i > n): return False
  elif (n%i == 0): return True
  else: return has2Divs(i+1, n)
    
def isPrime(n):
    if (n < 2): return False
    else: return not has2Divs(2, n)

def slowFib(n):
    if (n == 0): return 0
    elif (n == 1): return 1
    else: return slowFib(n-1) + slowFib(n-2) 
    
def quickFib(n):
    a,b = quickFibi(n)
    return a
    
def quickFibi(n):
    if (n == 0): 
        return (0,0)
    elif (n == 1):
        return (1,0)
    else:
        (a,b) = quickFibi(n-1)
        return (a+b, a)

# a = int(input())
# print(slowFib(a))

# a = int(input())
# print(quickFib(a))

# a = int(input())
# print(isPrime(a))

# n = int(input())
# print(absValue(n))

# x = int(input())
# n = int(input())
# print(power(x,n))
