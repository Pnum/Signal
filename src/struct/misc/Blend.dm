Noise
	Blend
		source_count_req = 3

		var
			Noise/source2
			Noise/source3

		New(Noise/_source, Noise/_source2, Noise/_source3)
			if(_source)
				addSource(_source)
				if(_source2)
					addSource(_source2)
					if(_source3)
						addSource(_source3)

		addSource(Noise/_source)
			..(_source)

			if(length(sources) == 2) source2 = sources[2]
			else if(length(sources) == 3) source3 = sources[3]

		get2(x, y)
			x += seed
			y += seed

			var
				a = source.get2(x, y)
				b = source2.get2(x, y)
				c = (source3.get2(x, y) + 1) / 2

			return __LINEAR_INTERP(a, b, c)

		get3(x, y, z)
			x += seed
			y += seed
			z += seed

			var
				a = source.get3(x, y, z)
				b = source2.get3(x, y, z)
				c = (source3.get3(x, y, z) + 1) / 2

			return __LINEAR_INTERP(a, b, c)