Noise
	Generator
		GradientValue
			var
				Noise/Generator/Value/value = new
				Noise/Generator/Gradient/gradient = new

				value_weight = 0.5
				gradient_weight = 0.5

			get2(x, y)
				return ((value.get2(x, y) * value_weight) + (gradient.get2(x, y) * gradient_weight))

			get3(x, y, z)
				return ((value.get3(x, y, z) * value_weight) + (gradient.get3(x, y, z) * gradient_weight))

			setSeed(_seed)
				..(_seed)

				value.setSeed(_seed)
				gradient.setSeed(_seed)

			proc
				setValueWeight(_weight)
					value_weight = _weight

				setGradientWeight(_weight)
					gradient_weight = _weight

				getValueWeight()
					return value_weight

				getGradientWeight()
					return gradient_weight