Noise
	Modifier
		Polar
			source_count_req = 1

			get2(x, y)
				var
					u = __arctan(x, y) / 6.28318530718
					v = ((arcsin(1 / sqrt(x * x + y * y + 1))) / 6.28318530718) + 0.5

				x = cos((v - 0.5) * 6.28318530718) * sin(u * 6.28318530718)
				y = cos((v - 0.5) * 6.28318530718) * cos(u * 6.28318530718)

				return source.get2(x, y)