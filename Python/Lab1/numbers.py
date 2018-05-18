import math
def absValue(x):
    if (x < 0): 
        return -x
    else: 
        return x

def power(x,n):
    if (n == 0):
        return 1;
    else:
        return x*power(x,n-1)
    
def is_prime(n):
    if n % 2 == 0 and n > 2: 
        return False
    return all(n%i for i in range(3, int(math.sqrt(n)) + 1, 2))

def slowFib(n):
    if (n == 0):
        return 0
    elif (n == 1):
        return 1
    else:
        return slowFib(n-1)+slowFib(n-2) 
    
def quickFib(n):
    (a,b) = quickFibi(n)
    return a
    
def quickFibi(n):
    if (n == 0): 
        return (0,0)
    elif (n == 1):
        return (1,0)
    else:
        (a,b) = quickFibi(n-1)
        return (a+b, b)
    
n = int(input())
print(quickFib(n))

n = int(input())
print(absValue(n))

x = int(input())
n = int(input())
print(power(x,n))

n = int(input())
print(slowFib(n))
