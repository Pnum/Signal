Noise
	Generator
		Fractal
			RidgedMulti
				h = 1
				gain = 2
				offset = 1

				get2(x, y)
					x += seed
					y += seed

					var
						signal = 0
						value = 0
						weight = 1
						i

					x *= frequency
					y *= frequency

					for(i = 0, i < octaves, i ++)
						signal = source.get2(x, y)
						signal = abs(signal)
						signal = offset - signal
						signal *= signal
						signal *= weight
						weight = signal * gain
						weight = (weight > 1) ? (1) : (weight < 0) ? (0) : (weight)
						value += (signal * weights[i + 1])

						x *= lacunarity
						y *= lacunarity

					return value - 1

				get3(x, y, z)
					x += seed
					y += seed
					z += seed

					var
						signal = 0
						value = 0
						weight = 1
						i

					x *= frequency
					y *= frequency
					z *= frequency

					for(i = 0, i < octaves, i ++)
						signal = source.get3(x, y, z)
						signal = abs(signal)
						signal = offset - signal
						signal *= signal
						signal *= weight
						weight = signal * gain
						weight = (weight > 1) ? (1) : (weight < 0) ? (0) : (weight)
						value += (signal * weights[i + 1])

						x *= lacunarity
						y *= lacunarity
						z *= lacunarity

					return value - 1