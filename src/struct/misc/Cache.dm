Noise
	Cache
		source_count_req = 1

		var
			cached_value = null
			c_x = 0
			c_y = 0
			c_z = 0

		get2(x, y)
			if(c_x == x && c_y == y && (cached_value != null))
				return cached_value

			c_x = x
			c_y = y
			cached_value = source.get2(x, y)

			return cached_value

		get3(x, y, z)
			if(c_x == x && c_y == y && c_z == z && (cached_value != null))
				return cached_value

			c_x = x
			c_y = y
			c_z = z
			cached_value = source.get3(x, y, z)

			return cached_value