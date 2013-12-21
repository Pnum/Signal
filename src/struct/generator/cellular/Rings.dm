Noise
	Generator
		Cellular
			Rings
				parent_type = /Noise/Generator/Cellular/Worley

				var
					frequency = 1
					amplitude = 1
					phase = 0
					scale = 256

				proc
					setScale(_scale)
						scale = _scale

					setFrequency(_frequency)
						frequency = _frequency

					setAmplitude(_amplitude)
						amplitude = _amplitude

					setPhase(_phase)
						phase = _phase

					getScale()
						return scale

					getAmplitude()
						return amplitude

					getPhase()
						return phase

					getFrequency()
						return frequency

				get2(x, y)
					if(SIGNAL_USE_DLL)
						return text2num(call(SIGNAL_DLL_PATH, __DLL_RINGS2)(num2text(x, 16), num2text(y, 16), num2text(seed, 16), num2text(distance_function, 16), num2text(scale, 16), num2text(frequency, 16), num2text(amplitude, 16), num2text(phase, 16), num2text(coeff_1, 16), num2text(coeff_2, 16), num2text(coeff_3, 16), num2text(coeff_4, 16)))

					. = ..(x, y)
					. = amplitude * sin((. * frequency) + phase) * 2 - 1

					return simplex.get2(. * scale, . * scale)

				get3(x, y, z)
					if(SIGNAL_USE_DLL)
						return text2num(call(SIGNAL_DLL_PATH, __DLL_RINGS3)(num2text(x, 16), num2text(y, 16), num2text(z, 16), num2text(seed, 16), num2text(distance_function, 16), num2text(scale, 16), num2text(frequency, 16), num2text(amplitude, 16), num2text(phase, 16), num2text(coeff_1, 16), num2text(coeff_2, 16), num2text(coeff_3, 16), num2text(coeff_4, 16)))

					. = ..(x, y, z)
					. = amplitude * sin((. * frequency) + phase) * 2 - 1

					return simplex.get3(. * scale, . * scale, . * scale)