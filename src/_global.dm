var
	SIGNAL_USE_DLL = TRUE
	SIGNAL_DLL_PATH = "lib/Signal.dll"

	const
		DISTANCE_EUCLIDEAN = 1
		DISTANCE_MANHATTAN = 2
		DISTANCE_CHEBYSHEV = 3

proc
	SIGNAL_DISABLE_DLL() SIGNAL_USE_DLL = FALSE
	SIGNAL_ENABLE_DLL() SIGNAL_USE_DLL = TRUE

#define __FNV_16_PRIME  3697
#define __FNV_16_OFFSET 85
#define __FNV_MASK_8    ((1 << 8) - 1)

#define __DISTANCE_EUCLIDEAN /proc/__distanceEuclidean
#define __DISTANCE_MANHATTAN /proc/__distanceManhattan
#define __DISTANCE_CHEBYSHEV /proc/__distanceChebyshev

// These are used internally when sending data to the Signal DLL.
#define __VALUE2_NOISE 1
#define __VALUE3_NOISE 2
#define __GRAD2_NOISE 3
#define __GRAD3_NOISE 4

#define __MIN_SEED -65535
#define __MAX_SEED 65535

// This value must match the value within the Signal DLL for it to load.
#define __DLL_VERSION "1.0"

// These are the names of the corresponding functions in the Signal DLL
#define __DLL_HASH2 "getHash2"
#define __DLL_HASH3 "getHash3"

#define __DLL_GRAD2 "getGrad2"
#define __DLL_GRAD3 "getGrad3"

#define __DLL_VALUE2 "getValue2"
#define __DLL_VALUE3 "getValue3"

#define __DLL_SIMPLEX2 "getSimplex2"
#define __DLL_SIMPLEX3 "getSimplex3"

#define __DLL_VORONOI2 "getVoronoi2"
#define __DLL_VORONOI3 "getVoronoi3"

#define __DLL_WORLEY2 "getWorley2"
#define __DLL_WORLEY3 "getWorley3"

#define __DLL_RINGS2 "getRings2"
#define __DLL_RINGS3 "getRings3"

world
	New()
		if(SIGNAL_USE_DLL)
			if(!fexists(SIGNAL_DLL_PATH))
				CRASH("Unable to locate [SIGNAL_DLL_PATH]! Did you set SIGNAL_DLL_PATH properly? Did you place a copy of the Signal DLL in your source?")

			else
				var/version = call(SIGNAL_DLL_PATH, "getVersion")()
				if(version != __DLL_VERSION)
					CRASH("[SIGNAL_DLL_PATH] version ([version]) does not match the required version ([__DLL_VERSION])! Are you using the most recent Signal DLL with the most recent Signal library?")

		..()

/*
The functions below are not meant to be used by the library user. They are only meant for use internally.
*/

proc
	__distanceEuclidean(dx, dy, dz) // Euclidean distance metric for cellular noise
		return (dx * dx + dy * dy + dz * dz)

	__distanceManhattan(dx, dy, dz) // Manhattan distance metric for cellular noise
		return abs(dx) + abs(dy) + abs(dz)

	__distanceChebyshev(dx, dy, dz) // Chebyshev distance metric
		return max(abs(dx), abs(dy), abs(dz))

	__quinticInterp(t) // This is the interpolation function used by the basic noise functions below.
							  // It results in the smoothest result (versus linear & cubic interpolation).
		return t * t * t * (t * (t * 6 - 15) + 10)

	__dot2(list/arr, a, b) // calculate dot product for a two element array
		return a * arr[1] + b * arr[2]

	__dot3(list/arr, a, b, c) // calculate dot product for a three element array
		return a * arr[1] + b * arr[2] + c * arr[3]

	__hash2(x, y, seed) // compute a hash (FNV-1A) of x, y coordinates and seed and xor fold it down to 8 bits
		#ifndef DISABLE_DLL_OPTIMIZATION

		return text2num(call(SIGNAL_DLL_PATH, __DLL_HASH2)(num2text(x), num2text(y), num2text(seed)))

		#else

		. = __FNV_16_OFFSET
		. ^= x; . *= __FNV_16_PRIME
		. ^= y; . *= __FNV_16_PRIME
		. ^= seed; . *= __FNV_16_PRIME

		return ((. >> 8) ^ (. & __FNV_MASK_8))

		#endif

	__hash3(x, y, z, seed) // compute a hash (FNV-1A) of x, y, z coordinates and seed and xor fold it down to 8 bits
		#ifndef DISABLE_DLL_OPTIMIZATION

		return text2num(call(SIGNAL_DLL_PATH, __DLL_HASH3)(num2text(x), num2text(y), num2text(z), num2text(seed)))

		#else

		. = __FNV_16_OFFSET
		. ^= x; . *= __FNV_16_PRIME
		. ^= y; . *= __FNV_16_PRIME
		. ^= z; . *= __FNV_16_PRIME
		. ^= seed; . *= __FNV_16_PRIME

		return ((. >> 8) ^ (. & __FNV_MASK_8))

		#endif

	__valueNoise2(x, y, ix, iy, seed) // calculate 2D value noise
		return (__hash2(ix, iy, seed) / 255) * 2 - 1

	__valueNoise3(x, y, z, ix, iy, iz, seed) // calculate 3D value noise
		return (__hash3(ix, iy, iz, seed) / 255) * 2 - 1

	__gradNoise2(x, y, ix, iy, seed) // calculate 2D gradient noise
		. = (__hash2(ix, iy, seed) * 2) + 1
		return (x - ix) * __grad2_lut[.] + (y - iy) * __grad2_lut[. + 1]

	__gradNoise3(x, y, z, ix, iy, iz, seed) // calculate 3D gradient noise
		. = ( __hash3(ix, iy, iz, seed) * 3) + 1
		return (x - ix) * __grad3_lut[.] + (y - iy) * __grad3_lut[. + 1] + (z - iz) * __grad3_lut[. + 2]

	__interpX2(x, y, xs, x0, x1, iy, seed, noise_function) // function used to interpolate between integers, providing smooth noise
		. = call(noise_function)(x, y, x0, iy, seed)
		return . + xs * (call(noise_function)(x, y, x1, iy, seed) - .)

	__interpXY2(x, y, xs, ys, x0, x1, y0, y1, seed, noise_function) // function used to interpolate between integers, providing smooth noise
		. = __interpX2(x, y, xs, x0, x1, y0, seed, noise_function)
		return . + ys * (__interpX2(x, y, xs, x0, x1, y1, seed, noise_function) - .)

	__interpX3(x, y, z, xs, x0, x1, iy, iz, seed, noise_function) // function used to interpolate between integers, providing smooth noise
		. = call(noise_function)(x, y, z, x0, iy, iz, seed)
		return . + xs * (call(noise_function)(x, y, z, x1, iy, iz, seed) - .)

	__interpXY3(x, y, z, xs, ys, x0, x1, y0, y1, iz, seed, noise_function) // function used to interpolate between integers, providing smooth noise
		. = __interpX3(x, y, z, xs, x0, x1, y0, iz, seed, noise_function)
		return . + ys * (__interpX3(x, y, z, xs, x0, x1, y1, iz, seed, noise_function) - .)

	__interpXYZ3(x, y, z, xs, ys, zs, x0, x1, y0, y1, z0, z1, seed, noise_function) // function used to interpolate between integers, providing smooth noise
		. = __interpXY3(x, y, z, xs, ys, x0, x1, y0, y1, z0, seed, noise_function)
		return . + zs * (__interpXY3(x, y, z, xs, ys, x0, x1, y0, y1, z1, seed, noise_function) - .)

/*
Below are the lookup tables used by various functions in the library. Do not modify these.
*/
var
	list/__grad2_lut = list(
		0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0,
		-1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1,
		1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1,
		0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0,
		0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0,
		-1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1,
		1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1,
		0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0,
		0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0,
		-1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1,
		1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1, 0, -1, 1, 0, -1, 0, 0, 1,
		0, -1, 1, 0, -1, 0)

	list/__grad3_lut = list(
		0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0,
		1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1,
		0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0,
		0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0,
		1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1,
		0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0,
		0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0,
		1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1,
		0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0,
		0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0,
		1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1,
		0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0,
		0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0,
		1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1,
		0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0,
		0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, -1, 0)

	list/__simplex_grad3_lut = list(
		list(1, 1, 0), list(-1, 1, 0), list(1, -1, 0), list(-1, -1, 0),
		list(1, 0, 1), list(-1, 0, 1), list(1, 0, -1), list(-1, 0, -1),
		list(0, 1, 1), list(0, -1, 1), list(0, 1, -1), list(0, -1, -1))

	list/__simplex_perm_lut = list(
		151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142,
		8, 99, 37, 240, 21, 10, 23, 190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117,
		35, 11, 32, 57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71,
		134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41,
		55, 46, 245, 40, 244, 102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89,
		18, 169, 200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226,
		250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182,
		189, 28, 42, 223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43,
		172, 9, 129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97,
		228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239,
		107, 49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254,
		138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180,
		151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142,
		8, 99, 37, 240, 21, 10, 23, 190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117,
		35, 11, 32, 57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71,
		134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41,
		55, 46, 245, 40, 244, 102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89,
		18, 169, 200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226,
		250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182,
		189, 28, 42, 223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43,
		172, 9, 129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97,
		228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239,
		107, 49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254,
		138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180)

	list/__simplex_perm_mod12_lut = list(
		7, 4, 5, 7, 6, 3, 11, 1, 9, 11, 0, 5, 2, 5, 7, 9, 8, 0, 7, 6, 9,
		10, 8, 3, 1, 0, 9, 10, 11, 10, 6, 4, 7, 0, 6, 3, 0, 2, 5, 2, 10,
		0, 3, 11, 9, 11, 11, 8, 9, 9, 9, 4, 9, 5, 8, 3, 6, 8, 5, 4, 3,
		0, 8, 7, 2, 9, 11, 2, 7, 0, 3, 10, 5, 2, 2, 3, 11, 3, 1, 2, 0,
		7, 1, 2, 4, 9, 8, 5, 7, 10, 5, 4, 4, 6, 11, 6, 5, 1, 3, 5, 1,
		0, 8, 1, 5, 4, 0, 7, 4, 5, 6, 1, 8, 4, 3, 10, 8, 8, 3, 2, 8, 4,
		1, 6, 5, 6, 3, 4, 4, 1, 10, 10, 4, 3, 5, 10, 2, 3, 10, 6, 3,
		10, 1, 8, 3, 2, 11, 11, 11, 4, 10, 5, 2, 9, 4, 6, 7, 3, 2, 9,
		11, 8, 8, 2, 8, 10, 7, 10, 5, 9, 5, 11, 11, 7, 4, 9, 9, 10, 3,
		1, 7, 2, 0, 2, 7, 5, 8, 4, 10, 5, 4, 8, 2, 6, 1, 0, 11, 10, 2,
		1, 10, 6, 0, 0, 11, 11, 6, 1, 9, 3, 1, 7, 9, 2, 11, 11, 1, 0,
		10, 7, 1, 7, 10, 1, 4, 0, 0, 8, 7, 1, 2, 9, 7, 4, 6, 2, 6, 8,
		1, 9, 6, 6, 7, 5, 0, 0, 3, 9, 8, 3, 6, 6, 11, 1, 0, 0, 7, 4, 5,
		7, 6, 3, 11, 1, 9, 11, 0, 5, 2, 5, 7, 9, 8, 0, 7, 6, 9, 10, 8,
		3, 1, 0, 9, 10, 11, 10, 6, 4, 7, 0, 6, 3, 0, 2, 5, 2, 10, 0, 3,
		11, 9, 11, 11, 8, 9, 9, 9, 4, 9, 5, 8, 3, 6, 8, 5, 4, 3, 0, 8,
		7, 2, 9, 11, 2, 7, 0, 3, 10, 5, 2, 2, 3, 11, 3, 1, 2, 0, 7, 1,
		2, 4, 9, 8, 5, 7, 10, 5, 4, 4, 6, 11, 6, 5, 1, 3, 5, 1, 0, 8,
		1, 5, 4, 0, 7, 4, 5, 6, 1, 8, 4, 3, 10, 8, 8, 3, 2, 8, 4, 1, 6,
		5, 6, 3, 4, 4, 1, 10, 10, 4, 3, 5, 10, 2, 3, 10, 6, 3, 10, 1,
		8, 3, 2, 11, 11, 11, 4, 10, 5, 2, 9, 4, 6, 7, 3, 2, 9, 11, 8,
		8, 2, 8, 10, 7, 10, 5, 9, 5, 11, 11, 7, 4, 9, 9, 10, 3, 1, 7, 2,
		0, 2, 7, 5, 8, 4, 10, 5, 4, 8, 2, 6, 1, 0, 11, 10, 2, 1, 10, 6,
		0, 0, 11, 11, 6, 1, 9, 3, 1, 7, 9, 2, 11, 11, 1, 0, 10, 7, 1,
		7, 10, 1, 4, 0, 0, 8, 7, 1, 2, 9, 7, 4, 6, 2, 6, 8, 1, 9, 6, 6,
		7, 5, 0, 0, 3, 9, 8, 3, 6, 6, 11, 1, 0, 0)

	list/__white_lut = list(
		-0.714286, 0.301587, 0.333333, -1, 0.396825, -0.0793651, -0.968254, -0.047619,
		0.301587, -0.111111, 0.015873, 0.968254, -0.428571, 0.428571, 0.047619, 0.84127,
		-0.015873, -0.746032, -0.809524, -0.619048, -0.301587, -0.68254, 0.777778, 0.365079,
		-0.460317, 0.714286, 0.142857, 0.047619, -0.0793651, -0.492063, -0.873016, -0.269841,
		-0.84127, -0.809524, -0.396825, -0.777778, -0.396825, -0.746032, 0.301587, -0.52381,
		0.650794, 0.301587, -0.015873, 0.269841, 0.492063, -0.936508, -0.777778, 0.555556,
		0.68254, -0.650794, -0.968254, 0.619048, 0.777778, 0.68254, 0.206349, -0.555556,
		0.904762, 0.587302, -0.174603, -0.047619, -0.206349, -0.68254, 0.111111, -0.52381,
		0.174603, -0.968254, -0.111111, -0.238095, 0.396825, -0.777778, -0.206349, 0.142857,
		0.904762, -0.111111, -0.269841, 0.777778, -0.015873, -0.047619, -0.333333, 0.68254,
		-0.238095, 0.904762, 0.0793651, 0.68254, -0.301587, -0.333333, 0.206349, 0.52381,
		0.904762, -0.015873, -0.555556, 0.396825, 0.460317, -0.142857, 0.587302, 1, -0.650794,
		-0.333333, -0.365079, 0.015873, -0.873016, -1, -0.777778, 0.174603, -0.84127, -0.428571,
		0.365079, -0.587302, -0.587302, 0.650794, 0.714286, 0.84127, 0.936508, 0.746032, 0.047619,
		-0.52381, -0.714286, -0.746032, -0.206349, -0.301587, -0.174603, 0.460317, 0.238095,
		0.968254, 0.555556, -0.269841, 0.206349, -0.0793651, 0.777778, 0.174603, 0.111111,
		-0.714286, -0.84127, -0.68254, 0.587302, 0.746032, -0.68254, 0.587302, 0.365079,
		0.492063, -0.809524, 0.809524, -0.873016, -0.142857, -0.142857, -0.619048, -0.873016,
		-0.587302, 0.0793651, -0.269841, -0.460317, -0.904762, -0.174603, 0.619048, 0.936508,
		0.650794, 0.238095, 0.111111, 0.873016, 0.0793651, 0.460317, -0.746032, -0.460317,
		0.428571, -0.714286, -0.365079, -0.428571, 0.206349, 0.746032, -0.492063, 0.269841,
		0.269841, -0.365079, 0.492063, 0.873016, 0.142857, 0.714286, -0.936508, 1, -0.142857,
		-0.904762, -0.301587, -0.968254, 0.619048, 0.269841, -0.809524, 0.936508, 0.714286,
		0.333333, 0.428571, 0.0793651, -0.650794, 0.968254, 0.809524, 0.492063, 0.555556,
		-0.396825, -1, -0.492063, -0.936508, -0.492063, -0.111111, 0.809524, 0.333333,
		0.238095, 0.174603, 0.333333, 0.873016, 0.809524, -0.047619, -0.619048, -0.174603,
		0.84127, 0.111111, 0.619048, -0.0793651, 0.52381, 1, 0.015873, 0.52381, -0.619048,
		-0.52381, 1, 0.650794, -0.428571, 0.84127, -0.555556, 0.015873, 0.428571, 0.746032,
		-0.238095, -0.238095, 0.936508, -0.206349, -0.936508, 0.873016, -0.555556, -0.650794,
		-0.904762, 0.52381, 0.968254, -0.333333, -0.904762, 0.396825, 0.047619, -0.84127, -0.365079,
		-0.587302, -1, -0.396825, 0.365079, 0.555556, 0.460317, 0.142857, -0.460317, 0.238095)