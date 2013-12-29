Noise
	NormalMap
		parent_type = /Noise/Modifier
		source_count_req = 1

		var
			x_scale = 1
			y_scale = 1
			z_scale = 1

		proc
			setScale(_x_scale, _y_scale, _z_scale = 1)
				setXScale(_x_scale)
				setYScale(_y_scale)
				setZScale(_z_scale)

			setXScale(_x_scale)
				if(_x_scale == 0) return
				x_scale = _x_scale

			setYScale(_y_scale)
				if(_y_scale == 0) return
				y_scale = _y_scale

			setZScale(_z_scale)
				if(_z_scale == 0) return
				z_scale = _z_scale

			getXScale()
				return x_scale

			getYScale()
				return y_scale

			getZScale()
				return z_scale

		get2(x, y)
			. = source.get2(x, y)

			var
				Nx = . - source.get2(x, y + (1 / y_scale))
				Ny = . - source.get2(x + (1 / x_scale), y)

				l = sqrt((Nx * Nx) + (Ny * Ny) + 1)

			Nx /= l
			Ny /= l

			return list(Nx, Ny, 1)

		get3(x, y, z)
			. = source.get3(x, y, z)

			var
				Nx = . - source.get3(x, y + (1 / y_scale), z)
				Ny = . - source.get3(x + (1 / x_scale), y, z)
				Nz = . - source.get3(x, y, z + (1 / z_scale))

				l = sqrt((Nx * Nx) + (Ny * Ny) + (Nz * Nz))

			Nx /= l
			Ny /= l
			Nz /= l

			return list(Nx, Ny, Nz)