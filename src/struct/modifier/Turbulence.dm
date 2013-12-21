Noise
	Modifier
		Turbulence
			source_count_req = 1

			var
				Noise/Generator/Simplex/x_distort = new
				Noise/Generator/Simplex/y_distort = new
				Noise/Generator/Simplex/z_distort = new

				power = 1

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				var
					x0 = x + 0.18942260742
					y0 = y + 0.9937133789
					z0 = z + 0.47816467285
					x1 = x + 0.40464782714
					y1 = y + 0.27661132812
					z1 = z + 0.92304992675
					x2 = x + 0.82122802734
					y2 = y + 0.17109680175
					z2 = z + 0.6842803955
					dx = x + (x_distort.get3(x0, y0, z0) * power)
					dy = y + (y_distort.get3(x1, y1, z1) * power)
					dz = z + (z_distort.get3(x2, y2, z2) * power)

				return source.get3(dx, dy, dz)

			get2(x, y)
				x += seed
				y += seed

				var
					x0 = x + 0.18942260742
					y0 = y + 0.9937133789
					x1 = x + 0.40464782714
					y1 = y + 0.27661132812
					dx = x + (x_distort.get2(x0, y0) * power)
					dy = y + (y_distort.get2(x1, y1) * power)

				return source.get2(dx, dy)

			proc
				setXDistortSource(Noise/_x_distort)
					x_distort = _x_distort

				setYDistortSource(Noise/_y_distort)
					y_distort = _y_distort

				setZDistortSource(Noise/_z_distort)
					z_distort = _z_distort

				getXDistortSource()
					return x_distort

				getYDistortSource()
					return y_distort

				getZDistortSource()
					return z_distort

				setPower(_power = 1)
					power = _power

				getPower()
					return power