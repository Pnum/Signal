Noise
	Modifier
		Multiply
			source_count_req = 1

			var
				factor = 1

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				return source.get3(x, y, z) * factor

			get2(x, y)
				x += seed
				y += seed

				return source.get2(x, y) * factor

			proc
				setFactor(_factor)
					factor = _factor

				getFactor()
					return factor