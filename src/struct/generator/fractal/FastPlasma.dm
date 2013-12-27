Noise
	Generator
		Fractal
			FastPlasma
				h = 0
				gain = 0.5
				offset = 0

				get2(x, y)
					if(SIGNAL_USE_DLL)
						return text2num(call(SIGNAL_DLL_PATH, __DLL_FASTPLASMA2)(num2text(x, 16), num2text(y, 16), num2text(seed, 16), num2text(octaves, 16), num2text(gain, 16), num2text(offset, 16), num2text(frequency, 16), num2text(lacunarity, 16)))

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
					if(SIGNAL_USE_DLL)
						return text2num(call(SIGNAL_DLL_PATH, __DLL_FASTPLASMA3)(num2text(x, 16), num2text(y, 16), num2text(z, 16), num2text(seed, 16), num2text(octaves, 16), num2text(gain, 16), num2text(offset, 16), num2text(frequency, 16), num2text(lacunarity, 16)))

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