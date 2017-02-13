# pyKDL
SWIG Python bindings to KDL, making use of numpy arrays.

## Features
An extensive list of features implemented at this time are explained in the following code.

```
f = Frame()
f0 = Frame(R,v)
print f

v = Vector()
v0 = Vector()
print v

R = Rotation()
R0 = Rotation()
print R

v1 = v + v0
v2 = v - v1
v3 = v1 * v2
v4 = Vector()
v4.assign(v)

v4 = R * v
R1 = R * R0
R2 = Rotation()
R2.assign(R)

f1 = Frame()
f1.assign(f0)
v5 = f * v
f2 = f * f0
f_p = f.p()     # reference to position vector in Frame
f_o = f.M()
print f
f_p.assign(Vector(1,2,3))
print f         # frame changed
```
