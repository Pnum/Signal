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
						return text2num(call(SIGNAL_DLL_PATH, __DLL_RINGS2)(num2text(x), num2text(y), num2text(seed), num2text(distance_function), num2text(scale), num2text(frequency), num2text(amplitude), num2text(phase), num2text(coeff_1), num2text(coeff_2), num2text(coeff_3), num2text(coeff_4)))

					. = ..(x, y)
					. = amplitude * sin((. * frequency) + phase) * 2 - 1

					return simplex.get2(. * scale, . * scale)

				get3(x, y, z)
					if(SIGNAL_USE_DLL)
						return text2num(call(SIGNAL_DLL_PATH, __DLL_RINGS3)(num2text(x), num2text(y), num2text(z), num2text(seed), num2text(distance_function), num2text(scale), num2text(frequency), num2text(amplitude), num2text(phase), num2text(coeff_1), num2text(coeff_2), num2text(coeff_3), num2text(coeff_4)))

					. = ..(x, y, z)
					. = amplitude * sin((. * frequency) + phase) * 2 - 1

					return simplex.get3(. * scale, . * scale, . * scale)