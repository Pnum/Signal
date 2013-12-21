Noise
	Modifier
		Polarize
			source_count_req = 1

			get2(x, y)
				if(x == 0) . = 0
				else . = __arctan(y / x)

				return source.get2(sqrt(x * x + y * y), .)

			get3(x, y, z)
				var/theta

				if(x == 0) . = 0
				else . = __arctan(y / x)

				if(z == 0) theta = 0
				else theta = __arctan(sqrt(x * x + y * y) / z)

				return source.get3(sqrt(x * x + y * y + z * z), ., theta)