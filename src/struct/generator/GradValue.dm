Noise
	Generator
		GradValue
			var
				Noise/Generator/Value/value = new
				Noise/Generator/Grad/grad = new

			get2(x, y)
				return (value.get2(x, y) + grad.get2(x, y)) / 2

			get3(x, y, z)
				return (value.get3(x, y, z) + grad.get3(x, y, z)) / 2

			setSeed(_seed)
				..(_seed)

				value.setSeed(_seed)
				grad.setSeed(_seed)