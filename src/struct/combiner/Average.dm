Noise
	Combiner
		Average
			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				. = 0
				for(var/Noise/source in sources)
					. += source.get3(x, y, z)

				. /= length(sources)

			get2(x, y)
				x += seed
				y += seed

				. = 0
				for(var/Noise/source in sources)
					. += source.get2(x, y)

				. /= length(sources)