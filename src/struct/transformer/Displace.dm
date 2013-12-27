Noise
	Transformer
		Displace
			source_count_req = 1

			var
				power = 1

				Noise/x_displace
				Noise/y_displace
				Noise/z_displace

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				var
					nx = x
					ny = y
					nz = z

				if(x_displace)
					nx += x_displace.get3(x, y, z) * power

				if(y_displace)
					ny += y_displace.get3(x, y, z) * power

				if(z_displace)
					nz += z_displace.get3(x, y, z) * power

				return source.get3(nx, ny, nz)

			get2(x, y)
				x += seed
				y += seed

				var
					nx = x
					ny = y

				if(x_displace)
					nx += x_displace.get2(x, y) * power

				if(y_displace)
					ny += y_displace.get2(x, y) * power

				return source.get2(nx, ny)

			proc
				setPower(_power)
					power = _power

				setXDisplaceSource(Noise/_x_displace)
					x_displace = _x_displace

				setYDisplaceSource(Noise/_y_displace)
					y_displace = _y_displace

				setZDisplaceSource(Noise/_z_displace)
					z_displace = _z_displace

				getXDisplaceSource()
					return x_displace

				getYDisplaceSource()
					return y_displace

				getZDisplaceSource()
					return z_displace

				getPower()
					return power