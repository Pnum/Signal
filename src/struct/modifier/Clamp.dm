Noise
	Modifier
		Clamp
			source_count_req = 1

			var
				lower_bound = -1
				upper_bound = 1

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				return min(max(source.get3(x, y, z), lower_bound), upper_bound)

			get2(x, y)
				x += seed
				y += seed

				return min(max(source.get2(x, y), lower_bound), upper_bound)

			proc
				setLowerBound(_lower_bound = -1)
					lower_bound = _lower_bound

				setUpperBound(_upper_bound = 1)
					upper_bound = _upper_bound

				getLowerBound()
					return lower_bound

				getUpperBound()
					return upper_bound

				setBounds(_lower_bound = -1, _upper_bound = 1)
					lower_bound = _lower_bound
					upper_bound = _upper_bound