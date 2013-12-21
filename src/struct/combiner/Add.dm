Noise
	Combiner
		Add
			get2(x, y)
				x += seed
				y += seed

				. = 0
				for(var/Noise/source in sources)
					. += source.get2(x, y)

			get3(x, y)
				x += seed
				y += seed

				. = 0
				for(var/Noise/source in sources)
					. += source.get3(x, y)