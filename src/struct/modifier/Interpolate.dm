Noise
	Modifier
		Interpolate
			source_count_req = 1

			var
				min = -1
				max = 1

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				return (max - min) * (source.get3(x, y, z) + 1) / 2 + min

			get2(x, y)
				x += seed
				y += seed

				return (max - min) * (source.get2(x, y) + 1) / 2 + min

			proc
				setMin(_min = -1)
					min = _min

				setMax(_max = 1)
					max = _max

				getMin()
					return min

				getMax()
					return max

				setMinMax(_min = -1, _max = 1)
					min = _min
					max = _max