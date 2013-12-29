Noise
	Generator
		White
			get2(x, y)
				return __white_lut[__SIMPLEX_HASH2(x, y, seed) + 1]

			get3(x, y, z)
				return __white_lut[__SIMPLEX_HASH3(x, y, z, seed) + 1]