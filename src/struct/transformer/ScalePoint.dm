Noise
	Modifier
		Transformer
			source_count_req = 1

			var
				x_scale = 1
				y_scale = 1
				z_scale = 1

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				return source.get3(x * x_scale, y * y_scale, z * z_scale)

			get2(x, y)
				x += seed
				y += seed

				return source.get2(x * x_scale, y * y_scale)

			proc
				setScale(_x_scale = 1, _y_scale = 1, _z_scale = 1)
					x_scale = _x_scale
					y_scale = _y_scale
					z_scale = _z_scale

				setXScale(_x_scale = 1)
					x_scale = _x_scale

				setYScale(_y_scale = 1)
					y_scale = _y_scale

				setZScale(_z_scale = 1)
					z_scale = _z_scale

				getXScale()
					return x_scale

				getYScale()
					return y_scale

				getZScale()
					return z_scale