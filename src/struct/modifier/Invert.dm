Noise
	Modifier
		Invert
			source_count_req = 1

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				return -source.get3(x, y, z)

			get2(x, y)
				x += seed
				y += seed

				return -source.get2(x, y)