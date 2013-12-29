Noise
	Modifier
		Exponent
			source_count_req = 1

			var
				exponent = 1

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				return (abs((source.get3(x, y, z) + 1) / 2) ** exponent) * 2 - 1

			get2(x, y)
				x += seed
				y += seed

				return (abs((source.get2(x, y) + 1) / 2) ** exponent) * 2 - 1

			proc
				setExponent(_exponent)
					exponent = _exponent

				getExponent()
					return exponent