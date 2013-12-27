Noise
	Combiner
		Multiply
			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				var
					Noise/source1 = sources[1]
					Noise/sourcen
					nval
					i

				. = (source1.get3(x, y, z) + 1) / 2

				if(length(sources) > 1)
					for(i = 2, i <= length(sources), i ++)
						sourcen = sources[i]
						nval = (sourcen.get3(x, y, z) + 1) / 2
						. *= nval

				. = (. * 2) - 1

			get2(x, y)
				x += seed
				y += seed

				var
					Noise/source1 = sources[1]
					Noise/sourcen
					nval
					i

				. = (source1.get2(x, y) + 1) / 2

				if(length(sources) > 1)
					for(i = 2, i <= length(sources), i ++)
						sourcen = sources[i]
						nval = (sourcen.get2(x, y) + 1) / 2
						. *= nval

				. = (. * 2) - 1