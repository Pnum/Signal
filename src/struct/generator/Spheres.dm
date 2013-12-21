Noise
	Generator
		Spheres
			var
				frequency = 1

			proc
				setFrequency(_frequency)
					frequency = _frequency

				getFrequency()
					return frequency

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				x *= frequency
				y *= frequency
				z *= frequency

				var
					dc = sqrt(x * x + y * y + z * z)
					ds = dc - round(dc)

				return 1 - (min(ds, 1 - ds) * 4)

			get2(x, y)
				x += seed
				y += seed

				x *= frequency
				y *= frequency

				var
					dc = sqrt(x * x + y * y)
					ds = dc - round(dc)

				return 1 - (min(ds, 1 - ds) * 4)