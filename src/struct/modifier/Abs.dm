Noise
	Modifier
		Abs
			source_count_req = 1

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				return abs(source.get3(x, y, z))

			get2(x, y)
				x += seed
				y += seed

				return abs(source.get2(x, y))