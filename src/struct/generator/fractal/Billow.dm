Noise
	Generator
		Fractal
			Billow
				h = 1
				gain = 0.5

				get2(x, y)
					x += seed
					y += seed

					var
						value = 0
						signal = 0
						g = 1
						i

					x *= frequency
					y *= frequency

					for(i = 0, i < octaves, i ++)
						signal = source.get2(x, y)
						signal = 2 * abs(signal) - 1
						value += signal * g

						x *= lacunarity
						y *= lacunarity

						g *= gain

					value += 0.5
					return value / 2

				get3(x, y, z)
					x += seed
					y += seed
					z += seed

					var
						value = 0
						signal = 0
						g = 1
						i

					x *= frequency
					y *= frequency
					z *= frequency

					for(i = 0, i < octaves, i ++)
						signal = source.get3(x, y, z)
						signal = 2 * abs(signal) - 1
						value += signal * g

						x *= lacunarity
						y *= lacunarity
						z *= lacunarity

						g *= gain

					value += 0.5
					return value / 2