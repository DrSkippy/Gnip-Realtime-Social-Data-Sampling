#!/usr/bin/env python
import math
from itertools import combinations
legsize = 3.
d = 0.2
r = 0.5
a=r*math.sin(2.*math.pi/6)
b=r*math.cos(2.*math.pi/6)
h=legsize*math.sin(2.*math.pi/6)
a1 = (b,a)
a2 = (r,0)
b1 = (legsize/2. - b, h - a)
b2 = (legsize/2. + b, h - a)
c1 = (legsize-b,a)
c2 = (legsize-r,0)

def sub():
    print "%"
    print "\draw [very thick, <->]",a1,"--",b1,";"
    print "\draw [very thick, <->]",b2,"--",c1,";"
    print "\draw [very thick, <->]",c2,"--",a2,";"
    print "%"
    print "\draw [orange, ultra thick] (0,0) circle [radius=",r,"];"
    print "\draw [yellow, ultra thick] (",legsize/2.,",",h,") circle [radius=",r,"];"
    print "\draw [green,  ultra thick] (",legsize   ,",",0,") circle [radius=",r,"];"
    print "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    print """
    \\end{tikzpicture}
\\end{center}
\\end{figure}
%
%
%%%%%"""
    start()

def start():
    print """
%%%%%
% figure  ICON VIEW
%
\\begin{figure}[h]
\\begin{center}
    \\begin{tikzpicture}[scale=0.25]]"""





start()
print "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
print "% generated code"
print "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
tri_com = [ (0,0),(legsize/2., h),(legsize, 0)]
for cx, cy in tri_com:
    verts = [
            (cx, cy),
            (cx-(d+r), cy-(d+r)),
            (cx+(d+r), cy+(d+r))
        ]
    print "\draw [red, very thick, rotate around={60: %s}] %s rectangle%s;"%tuple(verts)
    sub()
verts = [
        (tri_com[0][0], tri_com[0][1]),
        (tri_com[0][0]-(d+r), tri_com[0][1]-(d+r)),
        (tri_com[2][0]+(d+r), tri_com[2][1]+(d+r))
    ]
print "\draw [red, very thick, rotate around={0: %s}] %s rectangle%s;"%tuple(verts)
sub()
print "\draw [red, very thick, rotate around={60: %s}] %s rectangle%s;"%tuple(verts)
sub()
verts = [
        (tri_com[2][0], tri_com[2][1]),
        (tri_com[0][0]-(d+r), tri_com[0][1]-(d+r)),
        (tri_com[2][0]+(d+r), tri_com[2][1]+(d+r))
    ]
print "\draw [red, very thick, rotate around={-60: %s}] %s rectangle%s;"%tuple(verts)
sub()
verts = [
        (tri_com[0][0], tri_com[0][1]),
        (tri_com[0][0]-(d+r), tri_com[0][1]-(d+r)),
        (tri_com[2][0]+(d+r), tri_com[1][1]+(d+r))
    ]
print "\draw [red, very thick, rotate around={0: %s}] %s rectangle%s;"%tuple(verts)
sub()
