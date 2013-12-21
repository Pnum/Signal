Noise
	Generator
		GradValue
			var
				Noise/Generator/Value/value = new
				Noise/Generator/Grad/grad = new

				value_weight = 0.5
				grad_weight = 0.5

			get2(x, y)
				return ((value.get2(x, y) * value_weight) + (grad.get2(x, y) * grad_weight))

			get3(x, y, z)
				return ((value.get3(x, y, z) * value_weight) + (grad.get3(x, y, z) * grad_weight))

			setSeed(_seed)
				..(_seed)

				value.setSeed(_seed)
				grad.setSeed(_seed)

			proc
				setValueWeight(_weight)
					value_weight = _weight

				setGradWeight(_weight)
					grad_weight = _weight

				getValueWeight()
					return value_weight

				getGradWeight()
					return grad_weight