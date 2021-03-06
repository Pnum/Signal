Signal
======
Signal is a coherent noise generator for use with the DM language. Visit http://www.byond.com for more information.

What is coherent noise?
-----------------------
From http://libnoise.sourceforge.net/coherentnoise/index.html, coherent noise is a type of smooth pseudorandom noise
generated by a function with the following properties:
* Passing in the same input value will always return the same output value.
* A small change in the input value will produce a small change in the output value.
* A large change in the input value will produce a pseudorandom change in the output value.

Why is coherent noise useful?
-----------------------------
Coherent noise has a variety of applications. It is typically used for generating textures and terrain for use in
games. It can be used in place of any pseudorandom process to create a more "natural" sequence of
pseudorandom numbers.

How do I use Signal?
--------------------
Download the library at http://www.byond.com/developer/Koil/Signal and include it in your project.

Signal also provides a .DLL that certain functions can offload their computations to in order to provide quicker
results. It is highly recommended that you make use of the .DLL if possible. You will need to manually copy the
/lib folder from the Signal library into your own project to make use of it. If you have moved the .DLL somewhere
else or if the /lib folder is not in the root folder of your project, you must set the variable SIGNAL_DLL_PATH
to the correct location. Example:

```dm
SIGNAL_USE_DLL = TRUE // set to FALSE to disable the .DLL entirely. This is not generally recommended.
SIGNAL_DLL_PATH = "/lib/Signal.dll" // or "/path/to/Signal.dll" If you are hosting on Linux, you may use the .lib file instead.

/*
You also can use the procs SIGNAL_DISABLE_DLL() and SIGNAL_ENABLE_DLL() to turn the .DLL off and on in your code.

Note that version matching is done between the DLL and the library. Versions must match or the DLL will fail to load.
*/
```

After you've done those steps, you're ready to use Signal!

Let's begin!
------------
The Noise object is the base object from which every other object you'll be using from Signal is derived from. Every
Noise object has a `seed` variable that you can set with `setSeed(seed)` as long as the seed is from -65535 to 65535.
You can also use `randSeed()` to set seed to a random value form -65535 to 65535. `getSeed()` will return the current
seed. We will discuss the `seed` property later.

Every Noise object also maintains a list of "sources," which are just other Noise objects. This is useful because
many different types of Noise objects modify other Noise objects in some way, so this is how you will tell your
Noise object what it will be modifying. Some Noise objects don't need any source objects. Trying to add a source to a Noise
object that does not use it will result in your program crashing.

To add a single source object, call `addSource(Noise/source)` or `setSource(Noise/source)`. `setSource()` is useful if
the Noise object you are using only requires a single source. Call `addSource()` for as many sources as you need. You can
also use `setSources(list/sources)` to set every source you need at once. `overrideSource(source_number, Noise/new_source)`
will overwrite the source object at the specified location, and `clearSources()` will clear all sources from your
object. Other related procs include `getSource()` to retrieve the first source, `getSources()` to retrieve the list of sources,
`getSourceCountReq()` to get the number of sources your object requires. This may seem confusing at first, but it will make
sense as we move on!

A Noise object?
---------------
Just creating a simple Noise object like `var/Noise/noise = new` isn't useful! It won't do anything. Signal provides a large
variety of predefined Noise objects for you to use. We will be discussing them soon.

It is important now to know that every Noise object also has two procs, they are `get2(x, y)` and `get3(x, y, z)`. Calling
these procs will make your Noise object calculate the noise value located at the coordinates you specify. `get2()` is for
calculating 2D noise and `get3()` is used for calculating 3D noise. Note that 3D noise is generally more complex and computation
times can be significant. Use the 2D `get2()` function when possible.

How are these Noise objects supposed to know what values you want to get? This is where we begin to build noise!

Signal categorizes Noise objects into combiners, generators, modifiers, transformers, and miscellaneous. Generators are the objects
that compute your chosen type of noise. Combiners take other Noise objects and combine them in some way. Modifiers modify the output
value of a Noise object (the value you get from `get2()` and `get3()`). Transformers modify the coordinates you supply to the `get2()`
and `get3()` functions to alter the output values you get. There are also other miscellaneous Noise objects we will discuss later.

The library is structured in this way to allow you to chain together all the different types of Noise objects to compute complex
noise that is very specific to your needs. An example:

```dm
var
	Noise/Generator/Simplex/simplex_generator = new // create a simplex noise generator
	Noise/Generator/Simplex/simplex_generator2 = new // create another simplex noise generator
	Noise/Combiner/Add/add_combiner = new // create a combiner that adds together other Noise objects

add_combiner.setSources(list(simplex_generator, simplex_generator2)) // tells the combiner that we want to add these two generators together

world << add_combiner.get2(0.5, 0.5) // this will give us the same result as doing simplex_generator.get2(0.5, 0.5) + simplex_generator2.get2(0.5, 0.5)

// Note that noise generators can stand alone. While other Noise objects require sources to work on, the generators do not. You can call a generator's get2()
// and get3() functions with no other objects needed.
```

We'll discuss all the types of noise generators (including simplex) later. Right now let's talk about that `seed` property from before. The
seed property of Noise objects is important because `get2()` and `get3()` functions return the same exact value for any given coordinate every
time you use that coordinate. All Noise objects have an initial seed of 0. So you can have 200 different simplex noise objects but they're going
to give you the exact same value for `get2(0.5, 0.5)` because they have the same seed. Changing the seed value will "move" the space your noise
is calculated in around. A small change in the seed will result in a small change in the resultant noise, and a large change in the seed will result in a
large change in the resultant noise. Setting the seed allows you to achieve pseudorandom noise!

So what the heck is a simplex noise generator? Simplex noise is a function created by Ken Perlin (the creator of "classic" perlin noise) to calculate
noise comparable to his original noise function except with less complexity and faster computation time. Simplex noise is probably the most "useful" noise
and is probably the most used type of noise (other than classic perlin noise, which this library does not implement).

Simplex noise is just one of several noise types that Signal can generate. In the following section, you will see every Noise object that Signal provides
along with examples of how to use them and what they result in. The example pictures are calculated from slices of noise that are then colorized and drawn
by my Canvas library (http://www.byond.com/developer/Koil/Canvas). There is example code at the bottom to show exactly how I generated the pictures.

One more very important thing to know is that noise generators (for the most part) work in the range -1 to 1. You will need to scale the values you get to
something more relevant to your needs. An example of how to do this can be found in the sections below. When supplying coordinates to the `get` functions,
you generally should avoid using only integer numbers (1, 2, 3, 4, etc). Noise is generated by interpolating between points to give you a smooth "flowing"
result, so if you are, for example, loop through a slice of noise, you would want to scale your coordinates by some factor so that they are smaller (0.05 instead
of 1, for example). Again, an example below can demonstrate this.

Base Noise Generators
================
The following noise generators are considered "base" generators. Other generators typically make use of one of these in some way.

White
-----
White noise is the simplest type of noise. You can create a white noise generator like so:

```dm
var/Noise/Generator/White/white_noise = new

// The white noise generator has no properties to set.
```

![white noise generator 1x zoom](http://i.imgur.com/x5cpM5I.png "1x zoomed white noise")
![white noise generator 8x zoom](http://i.imgur.com/X9Xd3G6.png "8x zoomed white noise")

Value
-----
Value noise is another simple type of noise that interpolates between values at "lattice points" (integers) to give
the noise value. You can see where the lattice points are in the images. They are where integers are passed as
coordinates, resulting in a visible grid-like shape. This function is often used as the basis for other functions.

```dm
var/Noise/Generator/Value/value_noise = new

// The value noise generator has no properties to set.
// This generator can offload computation to the DLL for faster results.
```

![value noise generator 16x zoom](http://i.imgur.com/2MMKFnb.png "16x zoomed value noise")
![value noise generator 64x zoom](http://i.imgur.com/uvFHWhW.png "64x zoomed value noise")

Gradient
--------
Gradient noise improves upon value noise by interpolating smoothly between lattice points instead of just at the lattice
points themselves like value noise does. This function is often used as the basis for other functions.

```dm
var/Noise/Generator/Gradient/gradient_noise = new

// The gradient noise generator has no properties to set.
// This generator can offload computation to the DLL for faster results.
```

![gradient noise generator 16x zoom](http://i.imgur.com/ktQyUC2.png "16x zoomed gradient noise")
![gradient noise generator 64x zoom](http://i.imgur.com/12V1YVH.png "64x zoomed gradient noise")

GradientValue
-------------
This generator combines the results from a value noise generator and a gradient noise generator, then normalizes
them so the values are between -1 and 1. Combining gradient and value noise results in a better looking noise. This
function can be used as the basis for other functions.

```dm
var/Noise/Generator/GradientValue/gradientvalue_noise = new

gradientvalue_noise.setValueWeight(weight = 0.5) // this sets the amount of value noise in the result
gradientvalue_noise.setGradientWeight(weight = 0.5) // this sets the amount of gradient noise in the result

gradientvalue_noise.getValueWeight() // returns the value weight
gradientvalue_noise.getGradientWeight() // returns the gradient weight
```

![gradientvalue noise generator 16x zoom](http://i.imgur.com/MVH5N3K.png "16x zoomed gradientvalue noise")
![gradientvalue noise generator 64x zoom](http://i.imgur.com/XtnUhcE.png "64x zoomed gradientvalue noise")

Simplex
-------
Simplex noise is one of the most popular methods of generating noise. It was designed by Ken Perlin, known for creating
the classic "Perlin noise" that simplex noise is designed to improve upon. Simplex noise is great because it produces
noise with no noticeable artifacts and because of how quickly it can be computed.

```dm
var/Noise/Generator/Simplex/simplex_noise = new

// The simplex noise generator has no properties to set.
// This generator can offload computation to the DLL for faster results.
```

![simplex noise generator 16x zoom](http://i.imgur.com/t8MuiAq.png "16x zoomed simplex noise")
![simplex noise generator 64x zoom](http://i.imgur.com/kexrs7r.png "64x zoomed simplex noise")
![simplex noise generator 128x zoom](http://i.imgur.com/rj2EiOe.png "128x zoomed simplex noise, rainbow gradient")

Cellular Noise Generators
=========================
Cellular noise generators are named so because they generate "cells." The cellular noise generators have the following procs:

```dm
var/Noise/Cellular/cellular_noise // this base object does not actually generate anything. it is just the parent type for other cellular generators

noise.setDistanceFunction(distance_function) // sets the distance function used by the generator
// distance_function can be one of: DISTANCE_EUCLIDEAN (default), DISTANCE_MANHATTAN, or DISTANCE_CHEBYSHEV

noise.setCoefficients(F1, F2, F3, F4) // sets coefficients 
noise.setCoefficient1(F1)
noise.setCoefficient2(F2)
noise.setCoefficient3(F3)
noise.setCoefficient4(F4)

noise.getDistanceFunction()
noise.getCoefficient1()
noise.getCoefficient2()
noise.getCoefficient3()
noise.getCoefficient4()

// The cellular noise generators can be computed on the DLL and it is highly recommended that you do so
// because they are extremely slow in pure DM.
```

Cellular noise is easiest to understand when visualized. Changing the distance function and coefficients can cause wildly varied results.
The available cellular noise generators are as follows.

Voronoi
----------------------
This generates noise much like a Voronoi diagram.

```dm
var/Noise/Cellular/Voronoi/voronoi_noise = new

// See above for list of procs.
```

![voronoi noise generator 32x zoom](http://i.imgur.com/exPKnYt.png "32x zoomed voronoi noise, Euclidean distance")
![voronoi noise generator 32x zoom](http://i.imgur.com/wMUXWLO.png "32x zoomed voronoi noise, Manhattan distance")
![voronoi noise generator 32x zoom](http://i.imgur.com/BFx0Sok.png "32x zoomed voronoi noise, Chebyshev distance")
![voronoi noise generator 32x zoom](http://i.imgur.com/A1sics9.png "32x zoomed voronoi noise, rainbow gradient")

Worley
---------------------
See http://en.wikipedia.org/wiki/Worley_noise for more information.

```dm
var/Noise/Cellular/Worley/worley_noise = new

// See above for list of procs. Note that coefficients can be modified to change the output of voronoi noise as well.
```

![worley noise generator 32x zoom](http://i.imgur.com/xJ2MDIZ.png "32x zoomed worley noise, Euclidean distance, F1 = 1")
![worley noise generator 32x zoom](http://i.imgur.com/zWxWkSs.png "32x zoomed worley noise, Manhattan distance, F1 = 1")
![worley noise generator 32x zoom](http://i.imgur.com/akLL3cn.png "32x zoomed worley noise, Chebyshev distance, F1 = 1")
![worley noise generator 32x zoom](http://i.imgur.com/zUqz7Cp.png "32x zoomed worley noise, Euclidean distance, F1 = -1, F2 = 1")
![worley noise generator 32x zoom](http://i.imgur.com/KY3vL0y.png "32x zoomed worley noise, Manhattan distance, F1 = -1, F2 = 1")
![worley noise generator 32x zoom](http://i.imgur.com/o97R9Ys.png "32x zoomed worley noise, Euclidean distance, F1 = -1, F2 = 1")

Rings
-----------
```dm
var/Noise/Cellular/Rings/rings_noise = new

// In addition to all of the parameters for the other cellular functions, this generator also has:
rings_noise.setScale(scale = 256) // sets the size of the rings
rings_noise.setFrequency(frequency = 1) // sets the frequency
rings_noise.setAmplitude(amplitude = 1) // sets the amplitude
rings_noise.setPhase(phase = 0) // sets the phase

rings_noise.getScale()
rings_noise.getFrequency()
rings_noise.getAmplitude()
rings_noise.getPhase()

// Changing the distance function for this will result in diamonds (Manhattan distance) and squares (Chebyshev distance).
```

![rings noise generator 64x zoom](http://i.imgur.com/o79LMRC.png "64x zoomed rings noise, Euclidean distance")
![rings noise generator 64x zoom](http://i.imgur.com/50UM06n.png "64x zoomed rings noise, Manhattan distance")
![rings noise generator 64x zoom](http://i.imgur.com/BCw6cgL.png "64x zoomed rings noise, Chebyshev distance")
![rings noise generator 64x zoom](http://i.imgur.com/daiZ6id.png "64x zoomed rings noise, Euclidean distance, incandescent gradient")
![rings noise generator 64x zoom](http://i.imgur.com/5UUhPUS.png "64x zoomed rings noise, Manhattan distance, metallic gradient")

Fractal Noise Generators
========================

Plasma fractal
--------------

Ridged multifractal
-------------------

Billow fractal
--------------

Shape Generators
================

Checkerboard
------------

Spheres
-------

Cylinders
---------

Modifiers
=========

Abs
---

Clamp
-----

Exponent
--------

Interpolate
-----------

Invert
------

Multiply
--------

ScaleBias
---------

Terrace
-------

Threshold
---------

Combiners
========

Add
---

Average
-------

Max
---

Min
---

Multiply
--------

Power
-----

Transformers
============

Displace
--------

RotatePoint
-----------

ScalePoint
----------

TranslatePoint
--------------

Turbulence
----------

Miscellaneous
=============

Blend
-----

Cache
-----

DynamicCache
------------

NormalMap
---------

Select
------

Shader
------

Code Examples
=============

Drawing noise on a canvas
-------------------------

Creating a random map
---------------------