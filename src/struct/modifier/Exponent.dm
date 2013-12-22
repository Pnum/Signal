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

				. = source.get3(x, y, z)
				return (abs((. + 1) / 2) ** exponent) * 2 - 1

			get2(x, y)
				x += seed
				y += seed

				. = source.get2(x, y)
				return (abs((. + 1) / 2) ** exponent) * 2 - 1

			proc
				setExponent(_exponent)
					exponent = _exponent

				getExponent()
					return exponent