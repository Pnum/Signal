Noise
	Transformer
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

				return source.get3(x + (x_distort.get3(x + 0.18942260742, y + 0.9937133789, z + 0.47816467285) * power),\
								   y + (y_distort.get3(x + 0.40464782714, y + 0.27661132812, z + 0.92304992675) * power),\
								   z + (z_distort.get3(x + 0.82122802734, y + 0.17109680175, z + 0.6842803955) * power))


			get2(x, y)
				x += seed
				y += seed

				return source.get2(x + (x_distort.get2(x + 0.18942260742, y + 0.9937133789) * power), y + (y_distort.get2(x + 0.40464782714, y + 0.27661132812) * power))

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