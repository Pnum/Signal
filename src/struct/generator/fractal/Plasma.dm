Noise
	Generator
		Fractal
			Plasma
				h = 1
				gain = 0.5
				offset = 0.8

				get2(x, y)
					x += seed
					y += seed

					var
						sum = 0
						amp = 1
						i
						n

					x *= frequency
					y *= frequency

					for(i = 0, i < octaves, i ++)
						n = (source.get2(x, y) + offset) * weights[i + 1]

						sum += n * amp
						amp *= gain

						x *= lacunarity
						y *= lacunarity

					return sum

				get3(x, y, z)
					x += seed
					y += seed
					z += seed

					var
						sum = 0
						amp = 1
						i
						n

					x *= frequency
					y *= frequency
					z *= frequency

					for(i = 0, i < octaves, i ++)
						n = (source.get3(x, y, z) + offset) * weights[i + 1]

						sum += n * amp
						amp *= gain

						x *= lacunarity
						y *= lacunarity
						z *= lacunarity

					return sum