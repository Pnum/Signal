Noise
	Combiner
		Min
			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				. = 268435456
				for(var/Noise/source in sources)
					. = min(., source.get3(x, y, z))

			get2(x, y)
				x += seed
				y += seed

				. = 268435456
				for(var/Noise/source in sources)
					. = min(., source.get3(x, y))