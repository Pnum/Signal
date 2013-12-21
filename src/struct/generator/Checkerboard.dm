Noise
	Generator
		Checkerboard
			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				return (round(x) & 1 ^ round(y) & 1 ^ round(z) & 1) ? -1 : 1

			get2(x, y)
				x += seed
				y += seed

				return (round(x) & 1 ^ round(y) & 1) ? -1 : 1