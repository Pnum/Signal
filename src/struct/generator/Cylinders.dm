Noise
	Generator
		Cylinders
			var
				frequency = 1

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				x *= frequency
				z *= frequency

				var
					dc = sqrt(x * x + z * z)
					ds = dc - round(dc)

				return 1 - (min(ds, 1 - ds) * 4)

			get2(x, y)
				x += seed
				y += seed

				x *= frequency

				var/ds = x - round(x)

				return 1 - (min(ds, 1 - ds) * 4)

			proc
				setFrequency(_frequency)
					frequency = _frequency

				getFrequency()
					return frequency