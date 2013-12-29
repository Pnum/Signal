Noise
	Combiner
		Power
			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				. = 0
				for(var/Noise/source in sources)
					if(. == 0)
						. = source.get3(x, y, z)

					else
						. = . ** source.get3(x, y, z)

			get2(x, y)
				x += seed
				y += seed

				. = 0
				for(var/Noise/source in sources)
					if(. == 0)
						. = source.get2(x, y)

					else
						. = . ** source.get2(x, y)