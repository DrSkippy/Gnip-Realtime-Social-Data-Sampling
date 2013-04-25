#!/usr/bin/env python
import scipy.stats as scis
import math

confidence = .90
alpha = (1-confidence)/2.

def norm_bounds(n, mu=0., sig=1., alpha=(1.-0.95)/2.):
    zalpha = scis.norm.ppf(1.-alpha)
    return [mu - zalpha*sig/math.sqrt(n), mu + zalpha*sig/math.sqrt(n)]
    #return [y/math.sqrt(n) for y in scis.norm.interval(1.-2*alpha, loc=mu, scale=sig)]

def poisson_bounds(k, alpha=(1.-0.95)/2.):
    zalpha = scis.norm.ppf(1. - alpha)
    return [ k*(1. - 1./(9.*k) - zalpha/(3.*math.sqrt(k)))**3., (k+1.)*(1. - 1./(9.*(k+1.)) + zalpha/(3.*math.sqrt(k+1.)))**3.] 

def poisson_bounds1(k , alpha=(1.-0.95)/2.):
    # "Fishers' Exact"
    return [scis.chi2.ppf(alpha, 2*k)/2.0, scis.chi2.ppf(1.-alpha, 2*(k+1))/2.0]

def dc(ival, b):
    return 1.0*(ival[1] - ival[0])/float(b)

def int_fmt(i):
    return "[%2.4f, %2.4f]"%tuple(i)

EPS = 0.05
ns = [1,2,3,4,5,6,7,8,9,10,20,30,40,50,60,70,80,90,100,200,300,400,500,750,1000]
with open("./n_intervals.csv","wb") as of:
    res = ['N','Bounds (N>>1)', 'Interval (N>>1)', 'Bounds', 'Interval', 'Relative Interval']
    of.write(" & ".join(res) + "\\\\ \n\hline \n")
    for n in ns:
        s = float(n)
        i1 = norm_bounds(n, mu=float(n), sig=s, alpha=alpha) 
        i2 = poisson_bounds1(n, alpha=alpha)
        if abs(i1[0] - i2[0])/i2[0] < EPS and abs(i1[1] - i2[1])/i2[1] < EPS:
            res = [str(n), 
                int_fmt(i1),
                "%2.4f"%dc(i1, 1),
                int_fmt(i2),
                "%2.4f"%dc(i2, 1),
                "%2.4f"%(dc(i2, 1)/float(n))]
        else:
            res = [str(n),
                "-",
                "-",
                int_fmt(i2),
                "%2.4f"%dc(i2, 1),
                "%2.4f"%(dc(i2, 1)/float(n))]
        of.write(" & ".join(res) + "\\\\ \n")


note = """
db = 10
for j in range(1,10):
    for b in range(db, 10*db, db):
        n = j*b
#a = 1.9
#n = 1
#while n < 1000:
#    n = int(a)
        s = float(n) 
        #res = [n] + norm_bounds(n, mu=float(n), sig=s, alpha=alpha)+ poisson_bounds(n, alpha=alpha) + poisson_bounds1(n, alpha=alpha)
        res = [j, b, 
                dc(norm_bounds(n, mu=float(n), sig=s, alpha=alpha), b), 
                dc(poisson_bounds(n, alpha=alpha), b), 
                dc(poisson_bounds1(n, alpha=alpha), b)]
        print ','.join(["%2.4f"%i for i in res])
#    a = a**1.1
"""
