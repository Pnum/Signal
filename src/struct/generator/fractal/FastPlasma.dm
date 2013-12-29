Noise
	Generator
		Fractal
			FastPlasma
				parent_type = /Noise/Generator/Fractal/Plasma

				h = 0
				gain = 0.5
				offset = 0

				get2(x, y)
					if(SIGNAL_USE_DLL)
						return text2num(call(SIGNAL_DLL_PATH, __DLL_FASTPLASMA2)(num2text(x, 16), num2text(y, 16), num2text(seed, 16), num2text(octaves, 16), num2text(gain, 16), num2text(offset, 16), num2text(frequency, 16), num2text(lacunarity, 16)))

					. = ..(x, y)

				get3(x, y, z)
					if(SIGNAL_USE_DLL)
						return text2num(call(SIGNAL_DLL_PATH, __DLL_FASTPLASMA3)(num2text(x, 16), num2text(y, 16), num2text(z, 16), num2text(seed, 16), num2text(octaves, 16), num2text(gain, 16), num2text(offset, 16), num2text(frequency, 16), num2text(lacunarity, 16)))

					. = ..(x, y, z)